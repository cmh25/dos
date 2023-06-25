; --------------------------------------------------------------
;			   pixel.asm
;			   11-18-98
;
;Draws a pixel at any (x,y) coordinate in any color
;
;Parameters:
;	x		word
;	y		word
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

Pixel proc far c public,x:word,y:word,color:byte

	pusha
	push es	
			
	mov ax,0a000h		;point es to vga segment
	mov es,ax		      
				      
	mSetMapMask 1111b	;make sure map mask is ok
	mSetWriteMode 3	;setup for drawing
	mSetSR color
		  
	;
	;get address of pixel
	;
	mov ax,80
	mul y 
	mov di,ax
	mov ax,x 
	mov bl,8
	div bl
	mov cl,ah
	cbw
	add di,ax  
	mov al,128
	ror al,cl
	;
	;draw pixel
	;      
	mov ah,es:[di]	
	stosb

	pop es
	popa
	ret
	   
Pixel endp
code ends
end				       
