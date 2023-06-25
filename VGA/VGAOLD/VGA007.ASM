; --------------------------------------------------------------
;		       vga007.asm
;			 5-2-98
; blues out the entire screen by filling plane0 
; with ffh(all 1's) using rep stosb
; --------------------------------------------------------------

.model small

.486 

.stack 

.data  
    
.code 
  
.startup
						  
Main proc
		
Begin:

  mov ax,12h               ; change to mode 12h
  int 10h                  ;
  
  mov al,01h               ;
  mov dx,3c4h              ; set map mask to
  mov ah,al                ; plane0 only
  mov al,2                 ;
  out dx,ax                ;
  
  mov ax,0a000h            ;
  mov es,ax                ; fill vga memory with
  mov di,0                 ; 1's to blue out the
  mov al,0ffh              ; entire screen
  mov cx,9600h		   ;
  rep stosb                ;

  mov ax,0700h             ; wait for key
  int 21h                  ;
  
  mov ax,0003h             ; mode 3h
  int 10h                  ;
				
  mov ax,4c00h             ; exit to dos
  int 21h                  ;
  
main endp 

end       



