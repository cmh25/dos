; --------------------------------------------------------------
;			  setmode.asm
;			   12-4-99
;
; SetMode(mode) - sets the svga mode
;
; -------------------------------------------------------------- 

.model large,c

.486

;***********************
; CODE SEGMENT
;***********************
code segment word public 'CODE'
	assume cs:code

SetMode proc far c public,mode:word
	
	mov ax,4f02h
	mov bx,mode
	.if bx<100h	      ;check if vga mode
		mov ax,mode
	.endif
	int 10h
	ret
		
SetMode endp
code ends
end
