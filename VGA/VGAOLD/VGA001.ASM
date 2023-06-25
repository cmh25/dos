; --------------------------------------------------------------
;			 vga001.asm
;			    5-2-98 
; plots one blue pixel in approximately the middle of the screen
; uses the map mask to write to plane0 only
; sends 01h to vga memory
; does not use latches or bitmask
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
  
  mov dx,3c4h		   ; plane0 only
  mov al,2		   ; 
  mov ah,1		   ;
  out dx,ax		   ;
  
  mov ax,0a000h 	   ; es:di points to vga
  mov es,ax		   ;
  mov di,4b28h		   ;  
  
  mov al,1		   ; send '1' to vga memory
  stosb 		   ;
  
  mov ax,0700h		   ; wait for key
  int 21h		   ;
  
  mov ax,0003h
  int 10h
				
  mov ax,4c00h             ; exit to dos
  int 21h                  ;
  
main endp 

end       



