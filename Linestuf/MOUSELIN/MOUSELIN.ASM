; --------------------------------------------------------------
;                         mouslin.asm
;                          5-29-98    
;
;       
; -------------------------------------------------------------- 

.model large,c

.486       

include cmhgrfx.inc
includelib cmhgrfx.lib  

;***********************
; STACK SEGMENT
;***********************
stack segment word stack 'STACK' 
	dw      512     dup (?)
stack ends
;***********************
; DATA SEGMENT
;***********************
data segment word public 'DATA' 
	
	xxx0            word    0    
	yyy0            word    0
	xxx1            word    0
	yyy1            word    0  
	lastx0          word    0
	lasty0          word    0
	lastx1          word    0
	lasty1          word    0
	color1          byte    0
	
data ends
;***********************
; CODE SEGMENT
;***********************
code segment word public 'CODE'
	assume cs:code,ds:data 
	
Start proc

	mov ax,data
	mov ds,ax                 
	
	mov ax,12h
	int 10h
			
	mov ax,0        ; initialize mouse
	int 33h

	mov ax,0c202h   ; set sampling rate 200/sec
	mov bx,0600h
	int 15h
	
	mov ax,1        ; show mouse cursor
	int 33h
	
	mov color1,0111b
	
Mouselineloop:                     
	
	mov ax,3        ; get button status
	int 33h  
	
	and bl,1
	mov xxx0,cx
	mov yyy0,dx                      
	.while bl == 1     ; then start drawing a line
	  mov ax,3
	  int 33h 
	  .if cx != xxx1 || dx != yyy1            
	    mov xxx1,cx
	    mov yyy1,dx 
	    push cx
	    push dx
	    push bx 
	    mov ax,2
	    int 33h                           
	    invoke line,xxx0,yyy0,xxx1,yyy1,color1      
	    mov ax,1
	    int 33h   
	    pop bx  
	    pop dx
	    pop cx       
	  .endif
	  and bl,1
	.endw   
	mov ah,1
	int 16h  
	jz mouselineloop 
	mov ah,10h
	int 16h
	.if ah == 1
	  jmp donemouse
	.endif
	.if ah == 46 
	  mov ax,2
	  int 33h
	  mov ax,12h
	  int 10h 
	  mov ax,1
	  int 33h
	.endif
	.if ah == 19
	  mov color1,0100b
	.endif
	.if ah == 34
	  mov color1,0010b
	.endif
	.if ah == 48
	  mov color1,0001b
	.endif   
	.if ah == 17
	  mov color1,0111b
	.endif
	.if ah == 25
	  mov color1,0101b
	.endif
	.if ah == 24
	  mov color1,0110b
	.endif   
	jmp mouselineloop
	
Donemouse:      
			
	mov ax,0003h
	int 10h
	
	mov ax,4c00h
	int 21h
	
start endp
code ends
end start
