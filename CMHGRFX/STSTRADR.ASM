; --------------------------------------------------------------
;			ststradr.asm 
;			  10-31-98
;			 
;Sets the start address of the refresh buffer
;
;Parameters:
;	start_addr		byte - high byte of address
;
; -------------------------------------------------------------- 

.model large,c

.486 

;***********************
; CODE SEGMENT
;***********************
code segment word public 'CODE'

SetStartAddr proc far c public, start_addr:byte
	      
  push ax
  push dx   

  mov dx,3d4h			;set high byte of start address
  mov ah,start_addr		;
  mov al,0ch			;
  out dx,ax			;
  
  mov dx,3dah			;wait till new address takes effect
WaitNotVS:			;
  in al,dx			;
  and al,08h			;
  jnz WaitNotVS			;
WaitVS: 			;
  in al,dx			;
  and al,08h			;
  jz WaitVS			;
		   
  pop dx
  pop ax  
  ret
	
SetStartAddr endp
code ends 
end 
