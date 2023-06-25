; --------------------------------------------------------------
;			 putchar.asm
;			  11-18-98   
;
;Draws an ascii character at any (x,y) coordinate in any color
;
;Parameters:
;	x		word
;	y		word
;	character	byte
;	color		byte
;       
; -------------------------------------------------------------- 

.model large,c

.486   
 
include vga.inc	
	  
;***********************
; CODE SEGMENT
;***********************
code segment word public 'CODE'    

PutChar proc far c public,x:word,y:word,character:byte,color:byte

	pusha
	push es
	;
	;get font table
	;	    
	push bp
	mov ax,1130h
	mov bh,02h
	int 10h
	;
	;store the pointers 
	;		
	mov ax,es
	mov fs,ax
	mov si,bp 
	pop bp
	push cx
	;
	;setup video segment
	;
	mov ax,0a000h
	mov es,ax	 
	;
	;set color
	;
	mSetMapMask 1111b
	mSetWriteMode 3
	mSetSR color
	;
	;get the start address and pixel offset
	;  
	mov ax,y
	mov bx,80
	mul bx
	push ax
	mov ax,x
	mov bx,8
	xor dx,dx
	div bx
	pop di
	add di,ax
	mov cx,dx    ;cx has first pixel			
		
	mov al,character	
	pop bx		;this remains to count through loop
	mul bl	      
	add si,ax	
				    
charloop:
	
	mov al,es:[di] ;load latches
	mov al,fs:[si]
	shr al,cl
	stosb	  
	mov al,es:[di] ;load latches 
	xor ax,ax
	mov ah,fs:[si]
	shr ax,cl
	stosb	    
	add di,78			
	inc si
	dec bl
	jnz charloop	
	
done:	
	pop es
	popa
	ret

PutChar endp
code ends 
end 
