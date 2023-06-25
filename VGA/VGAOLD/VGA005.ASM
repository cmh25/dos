; --------------------------------------------------------------
;			 vga005.asm
;			   5-2-98
; displays an example of graphics mode 8x8 font	
;               
; --------------------------------------------------------------

.model small

include string.inc

.486 

.stack 

.data 

  buffer db 1,2,3,4,5,6,11,12,14,15,16,17,18,19,20,21,22,23,253,171,0dh
    
.code 
  
.startup
						  
Main proc
		
Begin: 

  mov ax,0012h
  int 10h
  
  mov ax,0c000h		  ;
  mov es,ax		  ; set font
  mov ax,4deeh		  ;
  mov bp,ax		  ;
  mov ax,1120h		  ;
  int 10h		  ;
  
  mOutstring  buffer   
  
  mov ax,0700h		  ; wait for key
  int 21h		  ;
  
  mov ax,0003h
  int 10h
				
  mov ax,4c00h             ; exit to dos
  int 21h                  ;
  
main endp 

end       



