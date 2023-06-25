; --------------------------------------------------------------
;			 ellp6.asm 
;			  10-1-98
;	
; -------------------------------------------------------------- 

.model large,c

.486		     

include vga.inc  
include cmhgrfx.inc
includelib cmhgrfx.lib

;ellipse proto far c, :word, :word, :word, :word, :byte

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
	;for ellipse proc
	;;;;;;;;;;;;;;;;;;
	quad1_addr		word		0
	quad2_addr		word		0
	quad3_addr		word		0
	quad4_addr		word		0
	center_addr		word		0  
	quad14_bit_mask		byte		0
	quad23_bit_mask		byte		0
	deltax			word		0
	deltay			word		0
	eterm			real8		?
	xrad2			real8		?
	yrad2			real8		?
	xrad22			real8		?
	yrad22			real8		? 
	div4			real8		4.0  
	div2			real8		0.5 
	subv			real8		1.0 
	junk			real10		?  
	flatxleft		word		0
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	      
	xradd			word		0 
	yradd			word		0 
	xleft			word		319
	xright			word		321
	ytop			word		239
	ybott			word		241
	clr			byte		1    
	skip			byte		3

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
	
	mEraseold macro
	  ;invoke ellipse,320,240,xradd,yradd,0 
	  invoke line,xleft,ytop,xright,ytop,0
	  invoke line,xleft,ybott,xright,ybott,0
	  invoke line,xleft,ytop,xleft,ybott,0
	  invoke line,xright,ytop,xright,ybott,0
	endm

	mDrawnew macro
	  .if xradd >= 0 && yradd >=0
	    invoke ellipse,320,240,xradd,yradd,clr			     
	  .endif
	  invoke line,xleft,ytop,xright,ytop,4
	  invoke line,xleft,ybott,xright,ybott,4
	  invoke line,xleft,ytop,xleft,ybott,4
	  invoke line,xright,ytop,xright,ybott,4	
	endm		  
	
	mDrawnew
	
Eloop:
			
	mov ax,10h
	int 16h		
	
	.if ah == 48h  ; up arrow
	  mov skip,3
Skip1:	
	  .if ytop == 0 || ybott == 479
	    jmp eloop
	  .endif	
	  mEraseold	    
	  inc yradd  
	  dec ytop
	  inc ybott  
	  mDrawnew
	  .if skip != 0 
	    dec skip
	    jmp skip1
	  .endif
	  jmp eloop
	.endif
	.if ah == 50h  ; down arrow
	  mov skip,3
Skip2:
	  .if yradd == 0  
	    jmp eloop
	  .endif	  
	  mEraseold		
	  dec yradd
	  inc ytop
	  dec ybott   
	  mDrawnew	  
	  .if skip != 0 
	    dec skip
	    jmp skip2
	  .endif  
	  jmp eloop
	.endif	      
	.if ah == 4dh  ; right arrow
	  mov skip,3
Skip3:	 
	  .if xleft == 0 || xright == 639
	    jmp eloop
	  .endif
	  mEraseold		  
	  inc xradd 
	  dec xleft
	  inc xright  
	  mDrawnew	  
	  .if skip != 0 
	    dec skip
	    jmp skip3
	  .endif	  
	  jmp eloop
	.endif
	.if ah == 4bh  ; left arrow
	  mov skip,3
Skip4:
	  .if xradd == 0 
	    jmp eloop
	  .endif	
	  mEraseold	    
	  dec xradd  
	  inc xleft
	  dec xright  
	  mDrawnew	   
	  .if skip != 0 
	    dec skip
	    jmp skip4
	  .endif	  
	  jmp eloop
	.endif	 
	.if ah == 30h ; b
	  mov clr,1  
	  jmp eloop
	.endif
	.if ah == 13h ; r
	  mov clr,4	     
	  jmp eloop
	.endif
	.if ah == 22h ; g
	  mov clr,2	   
	  jmp eloop
	.endif
	.if ah == 01h ; esc
	  jmp done
	.endif	 
	jmp eloop
		
Done:
	
	mov ax,03h
	int 10h
	
	mov ax,4c00h
	int 21h
		
start endp   

; the one in cmhgrfx.lib is used
;ellipse proc far c public, xcenter:word, ycenter:word, xrad:word, yrad:word, color:byte 
;	
;	finit
;	
;	mov deltax,0 
;	   
;	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	;macro to draw four quads pixels
;	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	mDraw_quads macro 
;	  mSetmapmask 1111b 
;	  mSetsr 0	  
;	  mov di,quad1_addr
;	  mov al,quad14_bit_mask
;	  mov ah,es:[di]
;	  stosb		
;	  mov di,quad4_addr
;	  mov ah,es:[di]
;	  stosb	
;	  mov di,quad2_addr
;	  mov al,quad23_bit_mask
;	  mov ah,es:[di]
;	  stosb	
;	  mov di,quad3_addr
;	  mov ah,es:[di]
;	  stosb
;	  mSetmapmask color
;	  mSetsr 0ffh	   
;	  mov di,quad1_addr
;	  mov al,quad14_bit_mask 
;	  mov ah,es:[di]
;	  stosb		
;	  mov di,quad4_addr
;	  mov ah,es:[di]
;	  stosb	
;	  mov di,quad2_addr
;	  mov al,quad23_bit_mask
;	  mov ah,es:[di]
;	  stosb	
;	  mov di,quad3_addr
;	  mov ah,es:[di]
;	  stosb	 
;	endm   
;	
;	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	;macro to compare eterm to zero using 
;	;the coprocessor and transfer the high
;	;byte of the status word to the low
;	;byte of the flags register
;	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	mComp_eterm0 macro	
;	  fldz
;	  fld eterm
;	  fcompp
;	  fstp junk
;	  fstsw ax
;	  sahf
;	endm   
;	
;	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	;macro for: yrad22 * deltax < xrad22 * deltay	   
;	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	mCheck_region  macro
;	  fild deltay
;	  fmul xrad22
;	  fild deltax
;	  fmul yrad22
;	  fcompp
;	  fstsw ax
;	  sahf
;	endm	
;	
;	;;;;;;;;;;;;;;;;;;;;;;;;
;	;setup xrad2 and yrad2	
;	;;;;;;;;;;;;;;;;;;;;;;;; 
;	fild xrad
;	fimul xrad
;	fstp xrad2
;	fild yrad
;	fimul yrad
;	fstp yrad2
;	
;	;;;;;;;;;;;;;;;;;;;;;;;;
;	;setup xrad22 and yrad22
;	;;;;;;;;;;;;;;;;;;;;;;;; 
;	fld xrad2
;	fadd xrad2
;	fstp xrad22
;	fld yrad2
;	fadd yrad2
;	fstp yrad22
;	
;	;;;;;;;;;;;;;;;;;;;
;	;setup deltay
;	;;;;;;;;;;;;;;;;;;;
;	mov ax,yrad
;	mov deltay,ax	 
;	
;	;;;;;;;;;;;;;;;;;;;;;;;;
;	;get center address 
;	;and initial bitmask	
;	;;;;;;;;;;;;;;;;;;;;;;;;
;	mov ax,80
;	mul ycenter
;	mov center_addr,ax
;	mov ax,xcenter
;	mov bl,8
;	div bl
;	mov cl,ah	  
;	cbw
;	add center_addr,ax
;	mov al,128 
;	ror al,cl 
;	mov quad14_bit_mask,al				  
;	mov quad23_bit_mask,al
;	
;	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;	;get all 4 starting addresses		
;	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	mov ax,yrad
;	mov bx,80
;	mul bx 
;	mov bx,ax
;	mov ax,center_addr
;	sub ax,bx
;	mov quad1_addr,ax
;	mov quad2_addr,ax
;	mov ax,center_addr
;	add ax,bx
;	mov quad3_addr,ax
;	mov quad4_addr,ax
;		
;	mov ax,0a000h
;	mov es,ax   
;		    
;	;;;;;;;;;;;;;;;;;;;;;;;;;;
;	;set drawing environment
;	;;;;;;;;;;;;;;;;;;;;;;;;;;
;	mSetwritemode 3	
;	
;	;;;;;;;;;;;;;;;;;;;;;;;;;;
;	;check for flat ellipse   
;	;xrad == 0 || yrad == 0
;	;;;;;;;;;;;;;;;;;;;;;;;;;;    
;	.if xrad == 0 
;	  mov ax,yrad 
;	  inc ax
;	  add yrad,ax  
;	  mov al,quad14_bit_mask
;	  .while yrad > 0
;	    mSetmapmask 1111b
;	    mSetsr 0	
;	    mov di,quad1_addr 
;	    mov ah,es:[di] 
;	    stosb
;	    dec di
;	    mSetmapmask color
;	    mSetsr 0ffh
;	    stosb
;	    add quad1_addr,80
;	    dec yrad
;	  .endw	
;	  ret  
;	.endif	
;	
;	.if yrad == 0  
;	  mov al,quad14_bit_mask
;	  mov cx,xrad	 
;	  .while cx > 0
;	    rol al,1
;	    .if carry?
;	      dec center_addr
;	    .endif  
;	    dec cx
;	  .endw	 
;	  mov bx,xrad 
;	  inc bx
;	  add xrad,bx 
;	  mov di,center_addr
;	  .while xrad > 0	  ; this could be better?????????
;	    mSetmapmask 1111b
;	    mSetsr 0	
;	    mov ah,es:[di]
;	    stosb
;	    dec di
;	    mSetmapmask color
;	    mSetsr 0ffh	
;	    stosb
;	    dec di 
;	    ror al,1
;	    .if carry?
;	      inc di
;	    .endif 
;	    dec xrad	    
;	  .endw
;	  ret
;	.endif
;	
;	;;;;;;;;;;;;;;;;;;;;;;;;;;
;	;draw first pixels
;	;;;;;;;;;;;;;;;;;;;;;;;;;;
;	mDraw_quads   
;		
;Region1a:
;	;;;;;;;;;;;;;;;;;;;;;;;;
;	;setup eterm
;	;;;;;;;;;;;;;;;;;;;;;;;; 
;	fild yrad
;	fmul xrad2
;	fld yrad2
;	fsub st,st(1)
;	fld xrad2
;	fdiv div4
;	fadd st,st(1)
;	fstp eterm	
;
;
;Region1: 
;	mCheck_region  
;	jnc region2a
;			   
;	mComp_eterm0	 
;	jnc higheterm	
;	   
;Loweterm:
;		
;	inc deltax	 
;	ror quad14_bit_mask,1
;	.if carry?
;	  inc quad1_addr
;	  inc quad4_addr
;	.endif 
;	rol quad23_bit_mask,1  
;	.if carry?
;	  dec quad2_addr
;	  dec quad3_addr
;	.endif
;	  
;	;;;;;;;;;;;;;;;;;
;	; new eterm
;	;;;;;;;;;;;;;;;;;
;	fild deltax
;	fmul yrad22
;	fadd yrad2
;	fadd eterm
;	fstp eterm	 
;	    
;	mDraw_quads		  
;	jmp region1
;
;Higheterm:	    
;	     
;	inc deltax
;	dec deltay	
;	ror quad14_bit_mask,1
;	.if carry?
;	  inc quad1_addr
;	  inc quad4_addr
;	.endif 
;	rol quad23_bit_mask,1	
;	.if carry?
;	  dec quad2_addr
;	  dec quad3_addr
;	.endif
;	add quad1_addr,80
;	add quad2_addr,80
;	sub quad3_addr,80
;	sub quad4_addr,80		       
;	      
;	;;;;;;;;;;;;;;;;
;	; new eterm
;	;;;;;;;;;;;;;;;;
;	fild deltax
;	fmul yrad22
;	fadd eterm
;	fstp eterm
;	fild deltay
;	fmul xrad22
;	fld eterm
;	fsub st,st(1)
;	fadd yrad2 
;	fstp eterm	
;	fstp junk
;		      
;	mDraw_quads  
;	jmp region1
;	    
;Region2a:
;	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	; calculate new eterm
;	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	fild deltax
;	fadd div2
;	fmul st,st
;	fmul yrad2
;	fstp eterm
;	fild deltay
;	fsub subv
;	fmul st,st
;	fmul xrad2
;	fadd eterm
;	fstp eterm
;	fld xrad2
;	fmul yrad2
;	fld eterm
;	fsub st,st(1)
;	fstp eterm	     
;	fstp junk
;			     
;Region2:	
;	.if deltay == 0 
;	  mov ax,deltax
;	  .if ax == xrad
;	    ret 
;	  .elseif
;	    jmp region1a	
;	  .endif
;	.endif
;	
;	mCheck_region 
;	.if carry? 
;	  ret		
;	.endif	      
;	    
;	mComp_eterm0  
;	jc loweterm2
;		  
;Higheterm2:
;	
;	dec deltay 
;	add quad1_addr,80
;	add quad2_addr,80
;	sub quad3_addr,80
;	sub quad4_addr,80
;	   
;	;;;;;;;;;;;;;;;
;	; new eterm
;	;;;;;;;;;;;;;;;
;	fild deltay
;	fmul xrad22
;	fld eterm
;	fsub st,st(1)
;	fadd xrad2
;	fstp eterm	     
;	fstp junk
;	   
;	mDraw_quads		
;	jmp region2
;	  
;Loweterm2: 
;	   
;	dec deltay
;	inc deltax 
;	ror quad14_bit_mask,1
;	.if carry?
;	  inc quad1_addr
;	  inc quad4_addr
;	.endif	
;	rol quad23_bit_mask,1  
;	.if carry?
;	  dec quad2_addr
;	  dec quad3_addr
;	.endif
;	add quad1_addr,80
;	add quad2_addr,80
;	sub quad3_addr,80
;	sub quad4_addr,80	   
;	     
;	;;;;;;;;;;;;;;;;
;	; new eterm
;	;;;;;;;;;;;;;;;;
;	fild deltay
;	fmul xrad22
;	fild deltax
;	fmul yrad22
;	fsub st,st(1)
;	fadd eterm
;	fadd xrad2
;	fstp eterm	 
;	fstp junk
;	   
;	mDraw_quads	 
;	jmp region2
;
;ellipse endp	
code ends 
end start
