;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				svga.inc
;				12-8-99
;
; mIncWindows - increments to the next window
; mDecWindows - decrements to the next window
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mIncWindows macro
    mov ax,4f05h
    mov bx,100h
    int 10h		;get window A
    inc dx		;inc to next window
    push dx
    mov ax,4f05h
    mov bx,0
    int 10h		;set new window A
    pop dx
    mov ax,4f05h
    mov bx,1
    int 10h		;set window B same as A
endm

mDecWindows macro
    mov ax,4f05h
    mov bx,100h
    int 10h		;get window A
    dec dx		;dec to next window
    push dx
    mov ax,4f05h
    mov bx,0
    int 10h		;set new window A
    pop dx
    mov ax,4f05h
    mov bx,1
    int 10h		;set window B same as A
endm
