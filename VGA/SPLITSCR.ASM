; --------------------------------------------------------------
;		       splitscr.asm 
;			  5-16-98
;			
; sets the splitscreen start scanline
; 
; caller must pass:
;		scanline:word
; -------------------------------------------------------------- 

.model large,c

.486 
		    
;***********************
; CODE SEGMENT
;***********************
code segment word public 'CODE'
	assume cs:code

setsplitscreen proc far c public, scanline:word    
	
  push ax
  push cx
  push dx
	
  mov dx,3dah
Waitnotvsyncloop:
  in al,dx
  test al,08h
  jnz waitnotvsyncloop 

Waitvsyncloop:
  in al,dx
  test al,08h
  jz waitvsyncloop
	
  mov dx,3d4h
  mov ax,scanline      
  mov ah,al	   
  mov al,18h
  cli
  out dx,ax
  mov ax,scanline	
  and ah,1
  mov cl,4
  shl ah,cl
  mov al,7
  out dx,al	
  inc dx
  in al,dx
  and al,not 10h
  or al,ah	
  out dx,al
  dec dx
  mov ax,scanline	
  and ah,2
  mov cl,3
  ror ah,cl 
  mov al,9
  out dx,al
  inc dx
  in al,dx
  and al,not 40h
  or al,ah
  out dx,al
  sti  
  
  pop dx
  pop cx
  pop ax	
  
  ret
	
setsplitscreen endp					       
code ends 
end 


