; --------------------------------------------------------------
;			setmode.asm
;			  10-7-98
;
;Sets the video mode
;
;Parameters:
;	mode		word
;       
; -------------------------------------------------------------- 

.model large,c
	      
.486
	   
;***********************
; CODE SEGMENT
;***********************
code segment word public 'CODE'

SetMode proc far c public, mode:word

     push ax
     mov ax,mode
     int 10h  
     pop ax
     ret
		
SetMode endp
code ends 
end 
