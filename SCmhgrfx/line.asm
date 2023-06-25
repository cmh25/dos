; --------------------------------------------------------------
;			   line.asm
;			   10-14-98 
;		    *for svga mode 103h - 800x600 256 color
;
; Uses Bresenham's line drawing algorithm.  Vertical and horizontal 
; lines are special-cased.	
;	
; -------------------------------------------------------------- 

.model large,c

.486	   

include svga.inc
;***********************
; CODE SEGMENT
;***********************
code segment word public 'CODE'

Line proc far c public,xstart:word,ystart:word,
		       xend:word,yend:word,color:byte	  
		       
	local	end_addr:word, deltax:word, deltay:word

mGetstartaddr macro 
	xor dx,dx	       ;
	mov ax,800	       ; get start_addr
	mov bx,ystart	       ;
	mul bx		       ; 
	mov bx,xstart	       ;
	add ax,bx	       ; 
	adc dx,0	       ;
	mov di,ax	       ; di has start addr    
	mov bh,0	       ; see which window we need to setup	
	mov bl,0	       ; set window a (dx has window)	   
	mov ax,4f05h	       ;
	push ax 	       ;
	push dx 	       ;
	int 10h		       ;
	pop dx		       ; set window b
	pop ax		       ;
	mov bh,0	       ;
	mov bl,1	       ;
	int 10h 	       ;		
	endm

mGetendaddr macro	       ;
	xor eax,eax	       ;
	xor ebx,ebx	       ;
	mov ax,800	       ; get end_addr
	mov bx,yend	       ;
	mul ebx 	       ; 
	xor ebx,ebx	       ;
	mov bx,xend	       ;
	add eax,ebx	       ;
	mov end_addr,ax	       ;			
	endm	 
	
	mov ax,0a000h
	mov es,ax		       

	mov ax,ystart	       ; make sure we're drawing
	.if ax > yend	       ; from top to bottom
	  xchg ax,yend	       ; (or vertically)
	  mov ystart,ax
	  mov ax,xstart
	  xchg ax,xend
	  mov xstart,ax
	.endif
	
	mov bx,xend	       ; check for vertical line
	sub bx,xstart	       ; (slope undefined) 
	.if bx == 0  
	  mov ax,ystart
	  mGetstartaddr	
	  jmp draw_vline	
	.endif
				     
;************************************************
; Not vertical, so find out if:
;
; x-major y-increasing or horizontal
; x-major y-decreasing
; y-major y-increasing
; y-major y-decreasing
;************************************************

	mov ax,yend		  ; change in y
	sub ax,ystart		  ;
	mov deltay,ax		  ;
	.if ax==0
		;make sure hline is drawn left to right
		mov ax,xstart
		.if ax>xend
			xchg ax,xend
			mov xstart,ax
		.endif
		mGetStartAddr
		jmp draw_hline
	.endif

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;find out xi or yi and xmajor or ymajor
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ax,xstart
	.if ax<xend
		;xi
		mov ax,xend
		sub ax,xstart
		mov deltax,ax
		.if ax<deltay
			;ymxi
			mGetStartAddr
			jmp draw_ymxiline
		.endif
		.if ax>=deltay
			;xmxi
			mGetStartAddr
			jmp draw_xmxiline
		.endif
	.endif
	.if ax>xend
		;xd
		mov ax,xstart
		sub ax,xend
		mov deltax,ax
		.if ax<deltay
			;ymxd
			mGetStartAddr
			jmp draw_ymxdline
		.endif
		.if ax>=deltay
			;xmxd
			mGetStartAddr
			jmp draw_xmxdline
		.endif
	.endif

Draw_vline:		
	mov cx,yend
	sub cx,ystart  
	inc cx
	mov al,color
Pixloop1:    
	
	;***************************
	; unrollable	
	;*************************** 
	dec cx
	jz done  
	stosb	
	dec di		 
	add di,800
	.if carry? 
	  push ax
	  mIncwindows 
	  pop ax
	.endif	  
	;***************************
	jmp pixloop1 
	
Draw_hline:	  
	mov cx,xend
	sub cx,xstart
	inc cx
	mov al,color	 
	       
	push di 		; if we know we're not going to 
	add di,cx		; wrap to a new window in the middle
	.if carry?		; of the line, we can use rep stosb
	  pop di		;   
	  jmp hlineloop 	; **Implement rep stosw here sometime**
	.else			;	
	  pop di		;
	  dec cx		;
	  rep stosb		;
	  jmp done		;
	.endif			;

Hlineloop:		 
	dec cx
	jz done
	mov es:[di],al
	add di,1		; inc doesn't set carry flag!   
	.if carry?   
	  push ax
	  mIncwindows	 
	  pop ax
	.endif
	jmp hlineloop
								 
Draw_ymxiline:
	mov cx,deltay 
	mov si,deltay			     
	mov dx,cx			 
	inc dx			; error term + 1   
	neg dx	
	shl si,1
	mov bx,deltax		; multiply deltax * 2
	shl bx,1		
	mov al,color		  
Lineloop1: 
	;*****************************
	; unrollable
	;*****************************	
	dec cx
	js done
	mov es:[di],al
	add di,800
	.if carry?
	  push ax
	  push bx
	  push dx
	  mIncwindows
	  pop dx
	  pop bx
	  pop ax
	.endif				
	add dx,bx 
	jc error1      
	;*****************************	
	
	jmp lineloop1
Error1: 	  
	sub dx,si	      ; reset error term     
	add di,1
	.if carry?
	  push ax
	  push bx
	  push dx
	  mIncwindows
	  pop dx
	  pop bx
	  pop ax
	.endif	       
	jmp lineloop1							 
				
Draw_xmxiline:
	mov dx,deltax
	inc dx
	neg dx		   
	mov cx,deltax
	shl deltax,1	 
	mov si,deltay
	shl si,1
	mov al,color	
Pixloop2:   
	;*********************
	; unrollable
	;********************* 
	dec cx
	js done		
	mov es:[di],al
	add di,1
	.if carry?
	  push ax
	  push dx
	  mIncwindows
	  pop dx
	  pop ax
	.endif	  
	add dx,si
	jc newrun2	
	;********************* 
					  
	jmp pixloop2	
Newrun2:	
	sub dx,deltax		
	add di,800
	.if carry?
	  push ax
	  push dx
	  mIncwindows
	  pop dx
	  pop ax
	.endif	
	jmp pixloop2 

Draw_ymxdline:
	mov cx,deltay		; multiply deltay * 2	 
	mov si,deltay		; to know when we're done  
	mov dx,cx		
	inc dx			; error term + 1  
	neg dx		    
	shl si,1	
	mov bx,deltax		; multiply deltay * 2
	shl bx,1
	mov al,color	
Lineloop3:	 
	;*****************************
	; unrollable
	;***************************** 
	dec cx
	js done	
	mov es:[di],al
	add di,800
	.if carry?
	  push ax
	  push bx
	  push dx
	  mIncwindows
	  pop dx
	  pop bx
	  pop ax
	.endif			
	add dx,bx 
	jc error3      
	;*****************************	
	   
	jmp lineloop3
Error3:	       
	sub dx,si	      ; reset error term
	sub di,1
	.if carry?
	  push ax
	  push bx
	  push dx
	  mDecwindows
	  pop dx
	  pop bx
	  pop ax
	.endif
	jmp lineloop3							 
      
Draw_xmxdline:
	mov dx,deltax
	inc dx
	neg dx		   
	mov cx,deltax			
	shl deltax,1	 
	mov si,deltay
	shl si,1
	mov al,color	
Pixloop4:   
	;*********************
	; unrollable
	;********************* 
	dec cx
	js done		
	mov es:[di],al
	sub di,1
	.if carry?
	  push ax
	  push dx
	  mDecwindows
	  pop dx
	  pop ax	
	.endif	  
	add dx,si
	jc newrun4	
	;********************* 
					  
	jmp pixloop4	
Newrun4:	
	sub dx,deltax
	add di,800
	.if carry?
	  push ax
	  push dx
	  mIncwindows
	  pop dx
	  pop ax
	.endif	
	jmp pixloop4 
			
Done:
	stosb		
	ret

Line endp
code ends
end				       
