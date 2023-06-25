; --------------------------------------------------------------
;			   fill.asm
;			   12-8-99
;
; Fill(color) - Fills the entire screen with color starting
;		at scanline. The scanline must be evenly
;		divisible by 600. This function is only tested
;		with 103h 800x600 256 color and only for the
;		first two 600 scanline memory pages
;
;
; -------------------------------------------------------------- 

.model large,c

.486

include svga.inc
;***********************
; CODE SEGMENT
;***********************
code segment word public 'CODE'
	assume cs:code

Fill proc far c public,x:word,y:word,color:byte
			local oddind:word

	;
	;get the address and window
	;
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
	;
	;fill up what is left of the first window
	;
	mov ax,0a000h
	mov es,ax
	mov al,color
	mov oddind,di
	add oddind,21248
	mov cx,di
	not cx
	rep stosb
	stosb
	mIncWindows
	mov al,color
	;
	;fill up the middle windows
	;
	mov cx,6
      fillup:
	push cx
	mov cx,0ffffh
	rep stosb
	stosb
	push ax
	push cx
	mIncWindows
	pop cx
	pop ax
	pop cx
	dec cx
	jnz fillup
	;
	;finish up with what we need of the last window
	;
	mov cx,oddind
	mov al,color
	rep stosb
	ret

Fill endp
code ends
end
