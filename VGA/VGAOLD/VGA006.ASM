; --------------------------------------------------------------
;			vga006.asm
;			  5-2-98
; displays the 16 colors of mode 12h
;		 
; --------------------------------------------------------------

.model small

.486 

.stack 

.data
  
  color byte 1
  line byte 0	
    
.code
  
.startup
						  
Main proc
		
Begin: 

  mov ax,0012h
  int 10h
  
  mov bx,0
  mov cx,0
  mov dx,5
  .while dx < 480
    .while line < 28
      .while cx < 640 
	mov ah,0ch
	mov al,color
	int 10h
	inc cx
      .endw  
      mov cx,0
      inc dx
      inc line
    .endw
    sub line,28
    mov cx,0
    inc dx
    inc dx
    inc color
  .endw
  
  mov ax,0		 ;
  int 33h		 ;
			 ; mouse
  mov ax,1		 ;
  int 33h		 ;		
  
  mov ax,0700h
  int 21h
  
  mov ax,0003h
  int 10h
  
  mov ax,4c00h		   ; exit to dos
  int 21h		   ;
  
main endp 

end	  



