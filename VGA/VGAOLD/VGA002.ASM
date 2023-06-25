; --------------------------------------------------------------
;			    vga002.asm
;			      5-2-98
; demonstrates the bitmask by writing ffh to plane0 only
; in a progressive congiguration of the bit mask, once at
; each key press
;               
; --------------------------------------------------------------

.model small

.486 

.stack 

.data 

  bit_mask	word 0
  orval 	word 1
  cutoff	word 128
  high_bits	word 0
    
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
  
  mov dx,3ceh		   ; set GC to 8 (bit mask)
  mov al,8		   ; 
  out dx,al		   ;
  
  .while bit_mask < 255 
    mov ax,orval
    .while ax <= cutoff	
      mov ax,bit_mask
      xor ax,ax
      or ax,high_bits
      or ax,orval
      mov bit_mask,ax 
      
      mov ax,0700h	   ; wait for key
      int 21h		   ;
      
      call plotdot
      mov ax,orval
      shl ax,1
      mov orval,ax
    .endw
    mov ax,cutoff
    or high_bits,ax
    shr ax,1 
    mov cutoff,ax 
    mov ax,1
    mov orval,ax
  .endw
    
  mov ax,0700h		   ; wait for key
  int 21h		   ;
  
  mov ax,0003h
  int 10h
				
  mov ax,4c00h             ; exit to dos
  int 21h		   ;
  
plotdot proc 
  
  mov dx,3cfh		   ; bit mask	  
  mov ax,bit_mask	   ;
  out dx,ax		   ;
  
  mov ax,0a000h 	   ; es:di points to vga
  mov es,ax		   ;
  mov di,4b20h		   ; 
  
  mov cl,es:[di]	   ; load latches
  
  mov di,4b28h		   ; change vga offset
  
  mov al,11111111b	   ;
  stosb 		   ; put '1111 1111' in vga memory   
  
  ret 
  
plotdot endp			   
  
main endp 

end       



