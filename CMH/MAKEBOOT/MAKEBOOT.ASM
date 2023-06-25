;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				makeboot.asm
;				 12-21-99
;
; Copies a DOS .exe file into a 512 byte buffer.
; Then writes the buffer to drive 0, cylinder 0, track 0, sector 1
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.model small
.586p
.stack 100h
.data
	buffer		db	512 dup(0)
	error1		db	0dh,'Something went wrong!$'
	success 	db	0dh,'OK$'
	count		db	4
.code
	org 7bfeh
start:
	jmp skip
      bootdisk:
	;
	; Instructions to be copied to boot disk
	; Execution will begin here at bootup
	;********************************************************************
	;********************************************************************
	mov ax,cs
	mov ds,ax
	mov es,ax
	mov si,testvar
	mov eax,[si]
	add eax,2
	cmp eax,55555555h
	jz stop
	mov ax,0e30h
	mov bh,0
	int 10h
      stop:
	jmp stop
      testvar:
	dd 55555554h
	;********************************************************************
	;********************************************************************
      skip:
	;
	; Copy CS:bootdisk to buffer (512 bytes)
	;
	mov ax,@data
	mov ds,ax
	push ds
	mov es,ax
	mov di,offset buffer
	mov ax,cs
	mov ds,ax
	mov cx,skip
	sub cx,bootdisk
	mov si,bootdisk
	rep movsb
	pop ds
	;
	; Write buffer to file
	;
      again:
	dec count
	cmp count,0
	jz error
	mov ah,0
	mov dl,0
	int 13h
	mov ax,0301h
	mov ch,0
	mov cl,1
	mov dh,0
	mov dl,0
	mov bx,offset buffer
	int 13h
	cmp ah,0
	jnz again
	mov dx,offset success
	mov ah,9
	int 21h
	jmp done
      error:
	;
	; Error handling
	;
	mov dx,offset error1
	mov ah,9
	int 21h
      done:
	;
	; Exit
	;
	mov ax,4c00h
	int 21h

end start
