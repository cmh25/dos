;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				  aformat.asm
;				   12-22-99
;
; Formats a 1.44M floppy using the cmh file system
; Tracks - 80 (1 track on each side of cylinder)
; Cylinders - 80
; Sectors per track - 19
; Heads - 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.model large
.stack 100h
.data
	buffer		db	512 dup(0ffh)
.code
start:
	mov ax,@data
	mov es,ax
	mov ah,2
	mov al,1
	mov ch,0
	mov cl,1
	mov dh,0
	mov bx,offset buffer
	int 13h

	mov ax,0040h
	mov es,ax
	mov di,0072h
	mov ax,0
	stosw
	mov ax,13h
	db 0eah
	dw 0f000h
	dw 0ef6fh

	;mov ah,0
	;int 16h
	mov ax,40h
	mov ds,ax
	mov al,0bh
	out 20h,al
	out 0ebh,al
	in al,20h
	out 0ebh,al

	mov ah,0
	int 16h


	mov ax,4c00h
	int 21h

end start
