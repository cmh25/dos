; --------------------------------------------------------------
;			spltscr2.asm 
;			  5-16-98
;	
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

	scanline		word	350  
	bmp_path		db	"DRAWING.BMP",0
	split_path		db	"SPLIT.BMP",0 
	image_path		db	"IMAGE.BMP",0
	image2_path		db	"IMAGE2.BMP",0 
	current_path		word	?    
	image_num		word	0

data ends
;***********************
; CODE SEGMENT
;***********************
code segment word public 'CODE'
	assume cs:code,ds:data

Start proc  

	mov ax,data
	mov ds,ax	
	mov ax,10h
	int 10h 	   
	
	invoke Setstartaddr,6e00h	
				
	invoke bmp2vga,offset bmp_path,0db10h	; draw bitmap  
	
	invoke bmp2vga,offset split_path,6d10h
		
	mov ax,0700h
	int 21h   
	
	mov ax,offset image_path
	mov current_path,ax
	
Repeatloop:	    
	mov cx,87
Scrolluploop:  
	push cx	
	invoke Setsplitscreen,scanline
	dec scanline	
	dec scanline 
	dec scanline
	dec scanline	
	
	mov ah,1			 ; check key
	int 16h
	jnz done  
	
	pop cx
	dec cx	    
	jnz scrolluploop  
	
	invoke bmp2vga,current_path,0ac96h 
	.if image_num == 0
	  mov ax,offset image2_path
	  mov current_path,ax
	  inc image_num
	  inc image_num
	.elseif image_num == 2
	  mov ax,offset image_path
	  mov current_path,ax 
	  dec image_num
	  dec image_num  
	.endif
	
	mov cx,87
Scrolldownloop:
	push cx   
		
	invoke Setsplitscreen,scanline	
				     
	inc scanline 
	inc scanline 
	inc scanline
	inc scanline	
	
	mov ah,1			 ; check key
	int 16h
	jnz done 
								 
	pop cx
	dec cx			
	jnz scrolldownloop
	
	mov ah,1			 ; check key
	int 16h
	jz repeatloop				
	
Done: 
	mov ax,0700h
	int 21h 
	
	mov ax,03h
	int 10h
	
	mov ax,4c00h
	int 21h
		
start endp

code ends 

end start


