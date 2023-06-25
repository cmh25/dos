; --------------------------------------------------------------
;			   pixel.asm
;			   12-8-99
;
; -------------------------------------------------------------- 

.model large,c

.486

;***********************
; CODE SEGMENT
;***********************
code segment word public 'CODE'
	assume cs:code

Pixel proc far c public,x:word,y:word,color:byte

	push es

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;get the address and window
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	xor dx,dx
	mov ax,800 ;screen width
	mov bx,y
	mul bx
	mov bx,x
	add ax,bx
	adc dx,0
	mov di,ax
	mov bx,0
	mov ax,4f05h
	push dx
	int 10h
	pop dx
	mov ax,4f05h
	mov bx,1
	int 10h
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;draw the pixel
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ax,0a000h
	mov es,ax
	mov al,color
	stosb
	pop es
	ret
		
Pixel endp
code ends
end
