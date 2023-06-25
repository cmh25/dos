;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				startinf.asm
;				 12-25-99
;
; Copies a DOS .exe file into a 512 byte buffer.
; Then writes the buffer to the boot sector of a:
; This one outputs control regs and occupied memory segments
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
start:
	jmp skip
      bootdisk:
	;
	; Instructions to be copied to boot disk
	; Execution will begin here at bootup
	;********************************************************************
	;********************************************************************
	mov al,69
	call outc
	mov al,70
	call outc
	mov al,76
	call outc
	mov al,58
	call outc
	mov al,32
	call outc
	pushfd
	pop edx
	call outedx
	mov al,67
	call outc
	mov al,82
	call outc
	mov al,48
	call outc
	mov al,58
	call outc
	mov al,32
	call outc
	mov edx,cr0
	call outedx
	mov al,67
	call outc
	mov al,82
	call outc
	mov al,50
	call outc
	mov al,58
	call outc
	mov al,32
	call outc
	mov edx,cr2
	call outedx
	mov al,67
	call outc
	mov al,82
	call outc
	mov al,51
	call outc
	mov al,58
	call outc
	mov al,32
	call outc
	mov edx,cr3
	call outedx
	mov al,67
	call outc
	mov al,82
	call outc
	mov al,52
	call outc
	mov al,58
	call outc
	mov al,32
	call outc
	mov edx,cr4
	call outedx
	call outmemlocs
      finished:
	jmp finished
	;----------------------------------------------------
	; Function to output the contents of the edx register
	;----------------------------------------------------
      outedx:
	mov cx,33
	mov edi,00000001h
      again1:
	ror edi,1
	dec cx
	jz doneoutedx
	test edx,edi
	jz out0
	jnz out1
      out0:
	mov al,48
	call outc
	jmp again1
      out1:
	mov al,49
	call outc
	jmp again1
	;-------------------------------------------
	; Function to output the character in al
	;-------------------------------------------
      outc:
	mov ah,0eh
	mov bh,0
	int 10h
	ret
      doneoutedx:
	mov al,0ah
	call outc
	mov al,0dh
	call outc
	ret
	;----------------------------------------------
	; Function to display memory information
	;----------------------------------------------
      outmemlocs:
	mov ax,0
	mov es,ax
      check:
	mov al,0
	mov di,0
	mov cx,15
	repz scasb
	.if cx==0
		jmp skipit
	.endif
	push ax
	mov ah,0
	int 16h
	pop ax
	mov dx,es
	call outreg
	mov al,0ah
	call outc
	mov al,0dh
	call outc
      skipit:
	mov ax,es
	add ax,1
	jc dolastseg
	mov es,ax
	jmp check
      outreg:
	mov bx,dx
	rol bx,4
	and bx,000fh
	mov al,bl
	add al,48
	.if al>57
		add al,7
	.endif
	call outc
	mov bx,dx
	rol bx,8
	and bx,000fh
	mov al,bl
	add al,48
	.if al>57
		add al,7
	.endif
	call outc
	mov bx,dx
	ror bx,4
	and bx,000fh
	mov al,bl
	add al,48
	.if al>57
		add al,7
	.endif
	call outc
	mov bx,dx
	and bx,000fh
	mov al,bl
	add al,48
	.if al>57
		add al,7
	.endif
	call outc
	ret
      dolastseg:
	ret

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
