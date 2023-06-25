; --------------------------------------------------------------
;			 vga003.asm
;			   5-2-98
; puts a dashed line across the middle of the screen
;               
; --------------------------------------------------------------

.model small

.486 

.stack 

.data 

  line byte 0	
    
.code 
  
.startup
						  
Main proc
		
Begin: 
  
  mov ax,12h		   ; mode 12h
  int 10h		   ;		  
  
  mov dx,3c4h		   ;
  mov al,2		   ; plane0 only
  mov ah,1		   ;
  out dx,ax		   ;
  
  mov dx,3ceh		   ;
  mov al,8		   ; bit mask		   
  out dx,ax		   ;
  inc dx		   ;
  mov ax,01010101b
  out dx,ax		   ;
  
  mov ax,0a000h 	   ; es:di points to vga
  mov es,ax		   ;
  mov di,4b00h		   ;  
  
  mov cl,es:[di]	   ; load latches
  
  .while line < 80 
  
    mov al,0ffh		   ;
    stosb		   ; put '1111 1111' in vga memory
  
    inc line	
  .endw    

  mov ax,0700h		   ; wait for key
  int 21h		   ;
  
  mov ax,0003h
  int 10h
				
  mov ax,4c00h             ; exit to dos
  int 21h                  ;
  
main endp 

end       



