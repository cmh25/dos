;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;								 protest2.asm
;								   1-17-00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.model large
.586p
include protest2.inc
.stack 2000h
.data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	crlf		db	0ah,0dh
	message1	db	"OK",0ah,0dh,"$"
	message2	db	"Something went wrong",0ah,0dh,"$"
	buffer1 	db	512 dup(0)
	buffer2345	db	2048 dup(0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
code segment word public use16 'CODE'
	assume cs:code

start:

	mov ax,@data
	mov ds,ax
	mov es,ax

	;
	; copy code16 to sector1
	;
	push ds
	mov di,offset buffer1
	mov ax,cs
	mov ds,ax
	mov si,start16
	mov cx,end16
	sub cx,start16
	rep movsb
	pop ds

	mov cx,3
      try:
	push cx
	mov ax,0
	mov dl,0
	int 13h
	mov bx,offset buffer1
	mov ah,3
	mov al,1
	mov ch,0
	mov cl,1
	mov dh,0
	mov dl,0
	int 13h
	pop cx
	cmp ah,0
	jz writesuccess
	dec cx
	jnz try
	jmp writefail
      writesuccess:
	mov ah,9
	mov dx,offset message1
	int 21h
	jmp writedone
      writefail:
	mov ah,9
	mov dx,offset message2
	int 21h
	jmp writedone
      writedone:

	;
	; copy code32 to sector2345
	;

	mov ax,4c00h
	int 21h

code ends

code16 segment word public use16  'CODE'
	org 7c00h
start16:
	mov ax,13h
	int 10h
	mov ax,0a000h
	mov es,ax
	mov di,0
	mov al,1
	mov cx,64000
	rep stosb
      stay:
	jmp stay

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; DATA
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

      gdt:
	entry_0 	descriptor <>
	code_0		descriptor <0ffffh,7c00h,,9fh,10h,>
	data_0		descriptor <0ffffh,7c00h,,93h,10h,>
	stack_0 	descriptor <0ffffh,9000h,,93h,10h,>
	vga_text	descriptor <0ffffh,8000h,0bh,93h,10h,>
	vga_graph	descriptor <>
      endgdt:

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
end16:
code16 ends

end start
