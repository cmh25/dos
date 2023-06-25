; --------------------------------------------------------------
;			ststradr.asm 
;			  5-16-98
;			 
; sets the start address of the refresh buffer
;
; caller must pass:
;		start_addr:word 
; -------------------------------------------------------------- 

.model large,c

.486 

;***********************
; CODE SEGMENT
;***********************
code segment word public 'CODE'
	assume cs:code

setstartaddr proc far c public, start_addr:word
	      
  push ax
  push dx
  
  mov dx,3dah
Waitvsyncloop:
  in al,dx
  test al,08h
  jz waitvsyncloop  

Waitnotvsyncloop:
  in al,dx
  test al,08h
  jnz waitnotvsyncloop

  mov dx,3d4h
  mov ax,start_addr	
  mov al,0ch	    
  cli
  out dx,ax
  mov ax,start_addr    
  mov ah,al	   
  mov al,0dh	     
  out dx,ax
  sti 
  
  pop dx
  pop ax
  
  ret
	
setstartaddr endp					  
code ends 
end 


