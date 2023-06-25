; --------------------------------------------------------------
;			 ellipse.asm
;			   10-12-98
;
;Parameters:
;	xcenter 	word
;	ycenter 	word
;	xrad		word
;	yrad		word
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
	
Ellipse proc far c public, xcenter:word, ycenter:word,
			   xrad:word, yrad:word, color:byte	
			   
	local quad1_addr:word, quad2_addr:word, quad3_addr:word,
	      quad4_addr:word, center_addr:word, quad14_bit_mask:byte,
	      quad23_bit_mask:byte, deltax:word, deltay:word
	local eterm[8]:real8, xrad2[8]:real8, yrad2[8]:real8, 
	      xrad22[8]:real8,yrad22[8]:real8, div4[8]:real8, 
	      div2[8]:real8, min1[8]:real8,junk[8]:real8, flatxleft:word	

	pusha
	push es

	finit

	mSetMapMask 1111b
	mSetWriteMode 3
	mSetSR color
	
	;************************
	;initialize local real8's
	;************************
	fld1
	fld1
	fadd
	fld1
	fadd
	fld1
	fadd 
	fstp div4	
	fld1 
	fld1
	fld1 
	fadd
	fdiv 
	fstp div2	
	fld1
	fstp min1
	finit
	;************************	
	
	mov deltax,0 
	   
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;macro to draw four quads pixels
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mDraw_quads macro 
	  mov di,quad1_addr
	  mov al,quad14_bit_mask 
	  mov ah,es:[di]
	  stosb		
	  mov di,quad4_addr
	  mov ah,es:[di]
	  stosb	
	  mov di,quad2_addr
	  mov al,quad23_bit_mask
	  mov ah,es:[di]
	  stosb	
	  mov di,quad3_addr
	  mov ah,es:[di]
	  stosb		  
	endm   
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;macro to compare eterm to zero using 
	;the coprocessor and transfer the high
	;byte of the status word to the low
	;byte of the flags register
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mComp_eterm0 macro	
	  fldz
	  fld eterm
	  fcompp
	  fstp junk
	  fstsw ax
	  sahf
	endm   
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;macro for: yrad22 * deltax < xrad22 * deltay	   
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mCheck_region  macro
	  fild deltay
	  fmul xrad22
	  fild deltax
	  fmul yrad22
	  fcompp
	  fstsw ax
	  sahf
	endm	
	
	;;;;;;;;;;;;;;;;;;;;;;;;
	;setup xrad2 and yrad2	
	;;;;;;;;;;;;;;;;;;;;;;;; 
	fild xrad
	fimul xrad
	fstp xrad2
	fild yrad
	fimul yrad
	fstp yrad2
	
	;;;;;;;;;;;;;;;;;;;;;;;;
	;setup xrad22 and yrad22
	;;;;;;;;;;;;;;;;;;;;;;;; 
	fld xrad2
	fadd xrad2
	fstp xrad22
	fld yrad2
	fadd yrad2
	fstp yrad22
	
	;;;;;;;;;;;;;;;;;;;
	;setup deltay
	;;;;;;;;;;;;;;;;;;;
	mov ax,yrad
	mov deltay,ax	 
	
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
	mov al,128 
	ror al,cl 
	mov quad14_bit_mask,al				  
	mov quad23_bit_mask,al
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	;get all 4 starting addresses		
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ax,yrad
	mov bx,80
	mul bx 
	mov bx,ax
	mov ax,center_addr
	sub ax,bx
	mov quad1_addr,ax
	mov quad2_addr,ax
	mov ax,center_addr
	add ax,bx
	mov quad3_addr,ax
	mov quad4_addr,ax
		
	mov ax,0a000h
	mov es,ax   
		    
	;;;;;;;;;;;;;;;;;;;;;;;;;;
	;check for flat ellipse   
	;xrad == 0 || yrad == 0
	;;;;;;;;;;;;;;;;;;;;;;;;;;    
	.if xrad == 0 
	  mov ax,yrad 
	  inc ax
	  add yrad,ax  
	  mov al,quad14_bit_mask
	  .while yrad > 0 
	    mov di,quad1_addr 
	    mov ah,es:[di] 
	    stosb	    
	    add quad1_addr,80
	    dec yrad
	  .endw	  
	  jmp done
	.endif	
	
	.if yrad == 0  
	  mov al,quad14_bit_mask
	  mov cx,xrad	 
	  .while cx > 0
	    rol al,1
	    .if carry?
	      dec center_addr
	    .endif  
	    dec cx
	  .endw	 
	  mov bx,xrad 
	  inc bx
	  add xrad,bx 
	  mov di,center_addr
	  .while xrad > 0 
	    mov ah,es:[di]
	    stosb	    
	    dec di
	    ror al,1
	    .if carry?
	      inc di
	    .endif 
	    dec xrad	    
	  .endw 
	  jmp done
	.endif
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;
	;draw first pixels
	;;;;;;;;;;;;;;;;;;;;;;;;;;
	mDraw_quads   
		
Region1a:
	;;;;;;;;;;;;;;;;;;;;;;;;
	;setup eterm
	;;;;;;;;;;;;;;;;;;;;;;;; 
	fild yrad
	fmul xrad2
	fld yrad2
	fsub st,st(1)
	fld xrad2
	fdiv div4
	fadd st,st(1)
	fstp eterm	


Region1: 
	mCheck_region  
	jnc region2a
			   
	mComp_eterm0	 
	jnc higheterm	
	   
Loweterm:
		
	inc deltax	 
	ror quad14_bit_mask,1
	.if carry?
	  inc quad1_addr
	  inc quad4_addr
	.endif 
	rol quad23_bit_mask,1  
	.if carry?
	  dec quad2_addr
	  dec quad3_addr
	.endif
	  
	;;;;;;;;;;;;;;;;;
	; new eterm
	;;;;;;;;;;;;;;;;;
	fild deltax
	fmul yrad22
	fadd yrad2
	fadd eterm
	fstp eterm	 
	    
	mDraw_quads		  
	jmp region1

Higheterm:	    
	     
	inc deltax
	dec deltay	
	ror quad14_bit_mask,1
	.if carry?
	  inc quad1_addr
	  inc quad4_addr
	.endif 
	rol quad23_bit_mask,1	
	.if carry?
	  dec quad2_addr
	  dec quad3_addr
	.endif
	add quad1_addr,80
	add quad2_addr,80
	sub quad3_addr,80
	sub quad4_addr,80		       
	      
	;;;;;;;;;;;;;;;;
	; new eterm
	;;;;;;;;;;;;;;;;
	fild deltax
	fmul yrad22
	fadd eterm
	fstp eterm
	fild deltay
	fmul xrad22
	fld eterm
	fsub st,st(1)
	fadd yrad2 
	fstp eterm	
	fstp junk
		      
	mDraw_quads  
	jmp region1
	    
Region2a:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; calculate new eterm
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	fild deltax
	fadd div2
	fmul st,st
	fmul yrad2
	fstp eterm
	fild deltay
	fsub min1
	fmul st,st
	fmul xrad2
	fadd eterm
	fstp eterm
	fld xrad2
	fmul yrad2
	fld eterm
	fsub st,st(1)
	fstp eterm	     
	fstp junk
			     
Region2:	
	.if deltay == 0 
	  mov ax,deltax
	  .if ax == xrad 
	    jmp done 
	  .elseif
	    jmp region1a	
	  .endif
	.endif
	
	mCheck_region 
	.if carry?     
	  jmp done		
	.endif	      
	    
	mComp_eterm0  
	jc loweterm2
		  
Higheterm2:
	
	dec deltay 
	add quad1_addr,80
	add quad2_addr,80
	sub quad3_addr,80
	sub quad4_addr,80
	   
	;;;;;;;;;;;;;;;
	; new eterm
	;;;;;;;;;;;;;;;
	fild deltay
	fmul xrad22
	fld eterm
	fsub st,st(1)
	fadd xrad2
	fstp eterm	     
	fstp junk
	   
	mDraw_quads		
	jmp region2
	  
Loweterm2: 
	   
	dec deltay
	inc deltax 
	ror quad14_bit_mask,1
	.if carry?
	  inc quad1_addr
	  inc quad4_addr
	.endif	
	rol quad23_bit_mask,1  
	.if carry?
	  dec quad2_addr
	  dec quad3_addr
	.endif
	add quad1_addr,80
	add quad2_addr,80
	sub quad3_addr,80
	sub quad4_addr,80	   
	     
	;;;;;;;;;;;;;;;;
	; new eterm
	;;;;;;;;;;;;;;;;
	fild deltay
	fmul xrad22
	fild deltax
	fmul yrad22
	fsub st,st(1)
	fadd eterm
	fadd xrad2
	fstp eterm	 
	fstp junk
	   
	mDraw_quads	 
	jmp region2
	      
Done:
	pop es
	popa
	ret

Ellipse endp
code ends 
end 
