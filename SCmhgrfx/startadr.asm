; --------------------------------------------------------------
;			  startadr.asm
;			   12-4-99
;
; SetStartAddr(scanline) - sets the start address for svga modes
; -------------------------------------------------------------- 

.model large,c

.486

;***********************
; CODE SEGMENT
;***********************
code segment word public 'CODE'
	assume cs:code

SetStartAddr proc far c public,scanline:word
    ;
    ;
    ;
    mov dx,3dah
  WaitBlankingEnd:
    in al,dx
    and al,09h
    jnz WaitBlankingEnd
    ;
    ;set start address
    ;    
    mov ax,4f07h
    mov bx,0
    mov dx,scanline
    mov cx,0
    int 10h
    ;
    ;
    ;
    mov dx,3dah
  WaitVRetrace:
    in al,dx
    and al,08h
    jz WaitVRetrace

    ret

SetStartAddr endp
code ends
end
