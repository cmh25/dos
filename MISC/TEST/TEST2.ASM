; --------------------------------------------------------------
;			 test2.asm 
;			  9-29-98
;	
; -------------------------------------------------------------- 

.model large,c

.486  
   
include vga.inc
include cmhgrfx.inc
includelib cmhgfx.lib

;***********************
; STACK SEGMENT
;***********************
stack segment word stack 'STACK'
	db 512 dup (?)
stack ends			     
;***********************
; DATA SEGMENT
;***********************
data segment word public 'DATA'   
		
	rad		word		1

data ends
;***********************
; CODE SEGMENT
;***********************
code segment word public 'CODE'
	assume cs:code,ds:data

Start proc    

	mov ax,data
	mov ds,ax   
	
	mov ax,0012h
	int 10h	  
	
	mov ax,0700h
	int 21h
	
	mov ax,0a000h
	mov es,ax
	mov di,0   
	
	mSetmapmask 0001b
	
	mov al,0ffh
	mov cx,38400
	rep stosb 
	
	mov ax,0700h
	int 21h
	       
Circloop:	   
	.while rad < 235
	  invoke circle,320,240,rad,4	
	  inc rad  
	  mov ax,60000
Waitloop:
	  dec ax
	  jnz waitloop
	.endw  
	.while rad > 1
	  invoke circle,320,240,rad,1
	  dec rad  
	  mov ax,60000
Waitloop2:
	  dec ax
	  jnz waitloop2	   
	.endw
	mov ah,1
	int 16h
	jz circloop
	
	mov ax,03h
	int 10h
	
	mov ax,4c00h
	int 21h
		
start endp

code ends 

end start


