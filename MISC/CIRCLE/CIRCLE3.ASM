; --------------------------------------------------------------
;			 circle3.asm 
;			   10-1-98
;	
; -------------------------------------------------------------- 

.model large,c

.486				     

include vga.inc  

circle proto far c, :word, :word, :word, :byte

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
	
	;;;;;;;;;;;;;;;;;;
	;for circle proc
	;;;;;;;;;;;;;;;;;;
	eterm			word		0
	deltax			word		0
	deltay			word		0
	center_addr		word		0
	oct1_addr		word		0
	oct2_addr		word		0
	oct3_addr		word		0
	oct4_addr		word		0
	oct5_addr		word		0
	oct6_addr		word		0
	oct7_addr		word		0
	oct8_addr		word		0
	oct14_bit_mask		byte		0
	oct85_bit_mask		byte		0
	oct23_bit_mask		byte		0
	oct76_bit_mask		byte		0
	;;;;;;;;;;;;;;;;;;;;
	
	rad			word		0
	xcord			word		25
	ycord			word		20 
	clr			byte		1

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
	
	invoke circle,320,240,20,1		       
	mov ax,0700h
	int 21h
	mov ax,0c00h
	mov cx,320
	mov dx,240
	int 10h 		 
	
	mov ax,0700h
	int 21h
	
	mov ax,03h
	int 10h
	
	mov ax,4c00h
	int 21h
		
start endp   

circle proc far c public, xcenter:word, ycenter:word, radius:word, color:byte

	mov ax,data
	mov ds,ax   
		     
	mSetwritemode 3	    
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;setup initial deltax and deltay
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ax,2
	mov deltax,ax
	mul radius
	mov deltay,ax  
	
	;;;;;;;;;;;;;;;;;;;;;;
	;setup eterm	      
	;;;;;;;;;;;;;;;;;;;;;;
	mov eterm,500
	
	;;;;;;;;;;;;;;;;;;;;;;;;
	;get center address 
	;and initial bitmask	
	;;;;;;;;;;;;;;;;;;;;;;;;
	mov ax,80
	mul ycenter
	mov center_addr,ax
	mov ax,xcenter
	mov bl,8
	div bl
	mov cl,ah
	;.if cl == 0	 
	;  dec center_addr 
	;.endif		  
	cbw
	add center_addr,ax
	mov oct14_bit_mask,128
	ror oct14_bit_mask,cl
	mov oct85_bit_mask,128
	ror oct85_bit_mask,cl
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	;get all 8 starting addresses
	;and initial bitmasks		
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ax,80
	mul radius
	mov bx,center_addr
	sub bx,ax
	mov oct1_addr,bx
	mov oct8_addr,bx 
	mov bx,center_addr
	add bx,ax
	mov oct5_addr,bx
	mov oct4_addr,bx   
	mov ax,center_addr
	mov oct2_addr,ax
	mov oct3_addr,ax
	mov oct7_addr,ax
	mov oct6_addr,ax
	mov ax,radius
	mov bl,8
	div bl
	mov cl,ah 
	cbw   
	add oct2_addr,ax
	add oct3_addr,ax
	sub oct7_addr,ax
	sub oct6_addr,ax  
	mov al,oct14_bit_mask
	mov oct23_bit_mask,al
	mov oct76_bit_mask,al 
	ror oct23_bit_mask,cl
	.if oct23_bit_mask > al
	  inc oct2_addr
	  inc oct3_addr
	.endif
Nonew23addr: 
	rol oct76_bit_mask,cl
	.if oct76_bit_mask < al
	  dec oct7_addr
	  dec oct6_addr 
	.endif	 
Nonew76addr:
		
	mov ax,0a000h
	mov es,ax 
	
	;;;;;;;;;;;;;;;;;;;;;;;;;
	;adjust radius to compare
	;with eterm. 500 so we
	;make sure and stay pos
	;;;;;;;;;;;;;;;;;;;;;;;;;
	dec radius
	add radius,500	
	
	;;;;;;;;;;;;;;;;;;;;;;;;
	;set these regs for a 
	;fast loop
	;;;;;;;;;;;;;;;;;;;;;;;;
	mov bx,deltax
	mov cx,deltay
	mov dx,eterm
	
	;;;;;;;;;;;;;;;;;;;;;;;;
	;this is where the 
	;drawing gets done
	;;;;;;;;;;;;;;;;;;;;;;;;  
	mSetmapmask color	;
	mSetsr 0ffh		 ;
				  ;
	mov di,center_addr	    ;	remove later
	mov al,oct14_bit_mask	     ;
	mov ah,es:[di]		      ;
	stosb			       ;

Draw_octants:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;first, draw blanks tp 4 planes	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mSetmapmask 1111b 
	mSetsr 0
	  
	mov di,oct1_addr
	mov al,oct14_bit_mask
	mov ah,es:[di]
	stosb	      
	
	mov di,oct4_addr
	mov ah,es:[di]
	stosb
	
	mov di,oct8_addr
	mov al,oct85_bit_mask
	mov ah,es:[di]
	stosb
	
	mov di,oct5_addr
	mov ah,es:[di]
	stosb
	
	mov di,oct2_addr
	mov al,oct23_bit_mask
	mov ah,es:[di]
	stosb
	
	mov di,oct3_addr
	mov ah,es:[di]
	stosb
	
	mov di,oct7_addr
	mov al,oct76_bit_mask
	mov ah,es:[di]
	stosb
	
	mov di,oct6_addr
	mov ah,es:[di]
	stosb	      
		
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;now draw octants
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mSetmapmask color
	mSetsr 0ffh
	   
	mov di,oct1_addr
	mov al,oct14_bit_mask 
	mov ah,es:[di]
	stosb	      
	
	mov di,oct4_addr
	mov ah,es:[di]
	stosb
	
	mov di,oct8_addr
	mov al,oct85_bit_mask
	mov ah,es:[di]
	stosb
	
	mov di,oct5_addr
	mov ah,es:[di]
	stosb
	
	mov di,oct2_addr
	mov al,oct23_bit_mask
	mov ah,es:[di]
	stosb
	
	mov di,oct3_addr
	mov ah,es:[di]
	stosb
	
	mov di,oct7_addr
	mov al,oct76_bit_mask
	mov ah,es:[di]
	stosb
	
	mov di,oct6_addr
	mov ah,es:[di]
	stosb	    
	 
	.if dx < radius	
	  inc bx
	  add dx,bx
	  inc bx
	  ror oct14_bit_mask,1
	  jnc nonewaddr 
	  inc oct1_addr
	  inc oct4_addr
	Nonewaddr:
	  mov al,oct85_bit_mask
	  rol oct85_bit_mask,1
	  .if oct85_bit_mask < al
	    dec oct8_addr
	    dec oct5_addr
	  .endif 
	Nonewaddr2:
	  sub oct7_addr,80
	  sub oct2_addr,80
	  add oct6_addr,80
	  add oct3_addr,80	
	.elseif dx >= radius
	  inc bx
	  add dx,bx
	  sub dx,cx
	  inc bx
	  dec cx
	  dec cx
	  ror oct14_bit_mask,1
	  jnc nonewaddr5  
	  inc oct1_addr
	  inc oct4_addr
	Nonewaddr5:  
	  mov al,oct85_bit_mask
	  rol oct85_bit_mask,1
	  .if oct85_bit_mask < al
	    dec oct8_addr
	    dec oct5_addr
	  .endif   
	Nonewaddr6:  
	  sub oct7_addr,80
	  sub oct2_addr,80
	  add oct6_addr,80
	  add oct3_addr,80 
	  add oct1_addr,80
	  sub oct4_addr,80
	  add oct8_addr,80
	  sub oct5_addr,80  
	  ror oct76_bit_mask,1
	  jnc nonewaddr3  
	  inc oct7_addr
	  inc oct6_addr
	Nonewaddr3:  
	  mov al,oct23_bit_mask
	  rol oct23_bit_mask,1
	  .if oct23_bit_mask < al
	    dec oct2_addr
	    dec oct3_addr
	  .endif
	Nonewaddr4:		 
	.endif
	
	mov ax,cx
	inc ax
	inc ax
	.if bx > ax
	  ret
	.endif	       
	jmp draw_octants
    
ret	

circle endp	

code ends 

end start


