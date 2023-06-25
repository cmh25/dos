;ints.asm     12-26-99
.model small
.486p
.stack 100h
.data
.code
start:
	xor dx,dx
      incport:
	inc dx
	in al,dx
	jmp incport


	mov ah,0
	int 16h

	mov ax,4c00h
	int 21h
end start
