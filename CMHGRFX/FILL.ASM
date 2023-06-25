; --------------------------------------------------------------
;			 fill.asm
;			 11-14-98
;
;Fills an area in the screen buffer with a color
;
;Parameters:
;	address 	word - offset in video segment(0a000h)
;	bytecount	word - number of bytes to fill
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

Fill proc far c public,address:word,bytecount:word,color:byte

	pusha
	push es

	mSetMapMask 1111b
	mEnableSR 1111b
	mSetSR color
	mov ax,0a000h
	mov es,ax
	mov di,address
	mov cx,bytecount
	mov al,0ffh
	rep stosb

	pop es
	popa
	ret

Fill endp
code ends
end 
