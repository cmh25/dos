; --------------------------------------------------------------
;			 circle.asm
;			  10-12-98
;
;Parameters:
;	xcenter 	word
;	ycenter 	word
;	radius		word
;	color		byte
;
; -------------------------------------------------------------- 

.model large,c

.486				     

include vga.inc
			     
;***********************
; CODE SEGMENT
;***********************
code segment word public 'CODE'

Circle proc far c public, xcenter:word, ycenter:word, radius:word, color:byte

	local eterm:word, deltax:word, deltay:word, center_addr:word,
	      oct1_addr:word, oct2_addr:word, oct3_addr:word, 
	      oct4_addr:word, oct5_addr:word, oct6_addr:word,
	      oct7_addr:word, oct8_addr:word, oct14_bit_mask:byte,
	      oct85_bit_mask:byte, oct23_bit_mask:byte, 
	      oct76_bit_mask:byte

	pusha
	push es

	mSetMapMask 1111b
	mSetWriteMode 3
	mSetSR color

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
	add radius,499	
	
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
Draw_octants:  
		
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
	  jmp done
	.endif	       
	jmp draw_octants	
	
Done:
	pop es
	popa
	ret

Circle endp
code ends 
end
