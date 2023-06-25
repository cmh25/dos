; --------------------------------------------------------------
;			spltgtxt.asm 
;			  5-18-98
;				  
; uses write mode 3 to draw test in mode 10h without disturbing 
; the background
; -------------------------------------------------------------- 

.model large,c

.486

include vga.inc
includelib vga.lib 

;***********************
; STACK SEGMENT
;***********************
stack segment word stack 'STACK'
	db 512 dup (?)
stack ends			     
;***********************
; DATA SEGMENT
;***********************
data segment word public 'DATA'	  
				  
	col_count	word	0
	row_count	word	0    
	current_screen	word	0  
	scanline	word	0 
	scan_inc	word	1
	next_row	word	1280   
	back_ind	word	0     
	image_path	db	"IMAGE.BMP",0	

data ends
;***********************
; CODE SEGMENT
;***********************
code segment word public 'CODE'
	assume cs:code,ds:data

spltgtxt proc	  

	mov ax,data
	mov ds,ax	
	mov ax,10h
	int 10h
	
	mov ax,1130h	    ; get font pointer
	mov bx,0200h	    
	int 10h 	    
	
	mov ax,es	    ; ds:si points to font table
	mov ds,ax 
	mov si,bp  
	 
	mov ax,0a000h		 ; es:di points to vga
	mov es,ax
	xor di,di		
		  
	push ds
	push es
	invoke bmp2vga,offset image_path,0db10h	  
	pop es
	pop ds 
	
	mEnablesr 1111b			; black screen
	mSetsr 0
	mSetmapmask 1111b
	
	mSetwritemode 3 
		
	mov al,es:[di]		; load latches	  
	
	mov dx,di	     
	
	push ds
	push es
	invoke setstartaddr,6e00h
	pop es
	pop ds	  
		
Columnloop:	

	push ds
	push es    
	mov ax,data
	mov ds,ax	
	invoke setsplitscreen,scanline	
	.if scanline == 300
	  mov ax,scan_inc
	  neg ax
	  mov scan_inc,ax
	.elseif scanline == 0
	  mov ax,scan_inc
	  mov ax,1
	  mov scan_inc,ax
	.endif
	mov ax,scanline
	add ax,scan_inc
	mov scanline,ax
	
	pop es
	pop ds	       
	
	mov ax,0100h
	int 16h
	jz columnloop

	mov ax,1000h
	int 16h	 
	
	cmp ah,01h		; check 'esc'
	jz done     
	
	cmp ah,1ch		; check 'enter'
	jnz continue  
	push ds
	mov ax,data
	mov ds,ax
	push ax
	mov ax,79
	mov col_count,ax  
	pop ax	       
	pop ds
	jmp enterloop	

Continue:      

	cmp ah,0eh		   ; check 'backspace'
	jnz continue2  
	push ds
	mov ax,data
	mov ds,ax
	dec di
	dec dx	 
	dec col_count
	inc back_ind
	mov al,0     
	pop ds

continue2:
			
	call drawchar 
	push ds	   
	mov ax,data
	mov ds,ax		  
	.if back_ind == 1  
	  dec back_ind
	  dec col_count 
	  dec dx
	  dec di
	.endif			  
	pop ds
	
Enterloop: 
	
	inc dx		  
	
	push ds
	mov ax,data
	mov ds,ax
	inc col_count		
	.if col_count == 80
	  mov dx,next_row
	  add next_row,1280
	  sub col_count,80   
	  inc row_count
	  .if row_count == 20  
	    sub row_count,1
	    add current_screen,1360
	    invoke setstartaddr,current_screen	 
	  .endif
	.endif 
	pop ds
	
	mov di,dx
	
	jmp columnloop

Done:	
	
	mov ax,03h
	int 10h
	
	mov ax,4c00h
	int 21h
		
spltgtxt endp
	       
Drawchar proc 
	    
	push dx	
	push si
	cbw    
	mov bx,14
	mul bx	
	add si,ax	     ; si points to character	   
	
	mov cx,14
Drawcharloop:  
	push cx 		  
	mSetmapmask 1111b     ; clear vga memory
	mSetsr 0   
	movsb
	dec di
	dec si 
	mSetmapmask 0001b
	mSetsr 0ffh		 
					 
	movsb
	pop cx
	dec cx 
	jz done
	add di,79
	jmp drawcharloop 
Done:	
	pop si	   
	pop dx
	ret
	
drawchar endp	
	
end spltgtxt

code ends		       

