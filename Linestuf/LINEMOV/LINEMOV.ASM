; --------------------------------------------------------------
;			linemov.asm 
;			  5-30-98
;	
; -------------------------------------------------------------- 

.model large,c

.486

include vga.inc
includelib vga.lib 

line proto far c,:word,:word,:word,:word,:byte

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

	xxx0		word	319
	yyy0		word	174
	xxx1		word	119
	yyy1		word	20
	p0oldx0		word	0
	p0oldy0		word	0
	p0oldx1		word	0
	p0oldy1		word	0  
	p1oldx0		word	0
	p1oldy0		word	0
	p1oldx1		word	0
	p1oldy1		word	0 
	inc_val		word	1
	
	start_addr	word	0     ; these are for line proc
	end_addr	word	0 
	bit_mask_start	byte	0 
	bit_mask_end	byte	0 
	deltax		word	0
	deltay		word	0		  

data ends
;***********************
; CODE SEGMENT
;***********************
code segment word public 'CODE'
	assume cs:code,ds:data

Start proc    

	mov ax,data
	mov ds,ax			      
	
	mov ax,10h
	int 10h  
		
	mov ax,0700h					
	int 21h     
	
	mSetwritemode 3  
	
Outerloop:
		       
	mov cx,85
Lineloop1:	 
	push cx 	
	mov ah,1
	int 16h
	jnz done1	
	call eolddnew1 
	mov ax,inc_val
	add xxx1,ax
	add xxx1,ax	
	call eolddnew0
	mov ax,inc_val
	add xxx1,ax 
	add xxx1,ax
	add xxx1,ax	
	pop cx
	dec cx
	jnz lineloop1	
	
	mov cx,75
Lineloop2:	 
	push cx 	
	mov ah,1
	int 16h
	jnz done1	
	call eolddnew1 
	mov ax,inc_val
	add yyy1,ax
	add yyy1,ax	
	call eolddnew0
	mov ax,inc_val
	add yyy1,ax
	add yyy1,ax	
	pop cx
	dec cx
	jnz lineloop2		  
	
	.if inc_val == 1
	  neg inc_val
	.else
	  add inc_val,2
	.endif
	jmp outerloop
	
Done1:
	
	mov ax,0700h
	int 21h
	
	mov ax,03h
	int 10h
	
	mov ax,4c00h
	int 21h
		
start endp  

EoldDnew1 proc
			
	mov di,6e00h
	mSetsr 0
	;invoke line,p1oldx0,p1oldy0,p1oldx1,p1oldy1,1
	mov di,6e00h
	mSetsr 0ffh
	invoke line,xxx0,yyy0,xxx1,yyy1,1
	invoke setstartaddr,6e00h
	mov ax,xxx0
	mov p1oldx0,ax
	mov ax,yyy0
	mov p1oldy0,ax
	mov ax,xxx1
	mov p1oldx1,ax
	mov ax,yyy1
	mov p1oldy1,ax 
	ret	
	      
EoldDnew1 endp
	
EoldDnew0 proc
		
	mov di,0
	mSetsr 0
	;invoke line,p0oldx0,p0oldy0,p0oldx1,p0oldy1,1	
	mov di,0
	mSetsr 0ffh
	invoke line,xxx0,yyy0,xxx1,yyy1,1
	invoke setstartaddr,0
	mov ax,xxx0
	mov p0oldx0,ax
	mov ax,yyy0
	mov p0oldy0,ax
	mov ax,xxx1
	mov p0oldx1,ax
	mov ax,yyy1
	mov p0oldy1,ax 
	ret
	
EoldDnew0 endp			      

line proc far c public,xstart:word,ystart:word,
		       xend:word,yend:word,color:byte	

	mov ax,data
	mov ds,ax    
	
mGetstartaddr macro 
	mov ax,80
	mul ystart 
	mov start_addr,ax
	mov ax,xstart 
	mov bl,8
	div bl
	mov cl,ah
	cbw
	add start_addr,ax  
	add start_addr,di;????????????????????
	mov bit_mask_start,1
	ror bit_mask_start,cl	   
	endm

mGetendaddr macro    
	mov ax,80
	mul yend 
	mov end_addr,ax
	mov ax,xend 
	mov bl,8
	div bl
	mov cl,ah
	cbw  
	add end_addr,ax 		 
	add end_addr,di;???????????????????
	mov bit_mask_end,128
	ror bit_mask_end,cl	
	endm			  
	
	mov ax,0a000h
	mov es,ax		      
	
	mSetmapmask color							
	;;;;;;;mSetwritemode 3 
	;;;;;;;mSetsr 0ffh	
	
	mov ax,xstart	       ; make sure we're drawing
	.if ax > xend	       ; from left to right
	  xchg ax,xend	       ; (or vertically)
	  mov xstart,ax
	  mov ax,ystart
	  xchg ax,yend
	  mov ystart,ax
	.endif		  
	
	mov bx,xend	       ; check for vertical line
	sub bx,xstart	       ; (slope undefined) 
	.if bx == 0  
	  mov ax,ystart
	  .if ax > yend	       ; make sure vertical line is
	    xchg ax,yend       ; drawn top to bottom
	    mov ystart,ax
	    mov ax,xstart
	    xchg ax,xend
	    mov xstart,ax
	  .endif	 
	  mGetstartaddr	
	  jmp draw_vline	
	.endif
	
	mov ax,yend	      ; check for horizontal line
	sub ax,ystart	      ; (slope == 0)  
	.if ax == 0	
	  mGetstartaddr
	  mGetendaddr	
	  jmp draw_hline	   
	.endif	 
				     
	.if ax == bx		    ; check for diagonal line	
	  mGetstartaddr		    ; (slope == 1)		 
	  jmp draw_dlineyi	    ; dline,y-increasing       
	.else 
	  mov ax,ystart
	  sub ax,yend
	  .if ax == bx		  
	    mGetstartaddr
	    jmp draw_dlineyd	     ; dline,y-decreasing 
	  .endif
	.endif	
	
;************************************************
; if we've come this far, we need to find out if:
;
; x-major y-increasing
; x-major y-decreasing
; y-major y-increasing
; y-major y-decreasing
;************************************************ 
	
	mov ax,xend		 ; change in x
	sub ax,xstart
	mov deltax,ax		  
	
	mGetstartaddr	
		
	mov di,start_addr	 ; setup di 

	mov ax,yend
	.if ax > ystart		  ; then y is increasing
	  sub ax,ystart		  ; ax has change in y
	  mov deltay,ax	
	  mov bx,xend
	  sub bx,xstart		  ; bx has change in x
	  .if ax > bx
	    jmp draw_ymyiline	  ; y-major,y-increasing		  
	  .else 
	    jmp draw_xmyiline	  ; x-major,y-increasing	   
	  .endif
	.else			  ; then y is decreasing			      
	  mov ax,ystart
	  sub ax,yend		  ; ax has change in y
	  mov deltay,ax 	  
	  mov bx,xend
	  sub bx,xstart		  ; bx has change in x 
	  .if ax > bx
	    jmp draw_ymydline	  ; y-major,y-decreasing		   
	  .else
	    jmp draw_xmydline	  ; x-major,y-decreasing
	  .endif	
	.endif	 

Draw_vline:	
	mov di,start_addr	
	mov cx,yend
	sub cx,ystart
	inc cx	
	mov al,bit_mask_start
	ror al,1
Pixloop1:    
	
	;***************************
	; unrollable	
	;***************************
	mov ah,es:[di]
	stosb	 
	add di,79 
	dec cx
	jz donevline	  
	;***************************
	
	jmp pixloop1
Donevline:
	ret

Draw_hline:		
	mov cx,end_addr
	sub cx,start_addr
	mov di,start_addr 
;*****************************
; one byte
;*****************************
	.if cx == 0	
	  ror bit_mask_start,1	   
	  mov al,bit_mask_start   
	  dec al			  
	  or al,bit_mask_start
	  mov bl,10000000b   
	  sub bl,bit_mask_end
	  or bl,10000000b
	  and al,bl
	  mov ah,es:[di]
	  stosb					   
	  ret		  
	.endif					     
;******************************
; two bytes
;******************************
	.if cx == 1 
	  mov bl,bit_mask_start  
	  ror bl,1		 
	  xor al,al 
				
Firstbyte:	  
	  ;*************************
	  ; unrollable
	  ;*************************
	  or al,bl
	  ror bl,1    
	  jc storefirstbyte  
	  ;*************************			 
	  jmp firstbyte	
Storefirstbyte:	
	  mov ah,es:[di]
	  stosb	      
	  mov bl,bit_mask_end
	  xor al,al 
					    
Lastbyte:	 
	  
	  ;*************************
	  ; unrollable
	  ;*************************	  
	  or al,bl
	  rol bl,1 
	  jc storelastbyte 
	  ;*************************
	   
	  jmp lastbyte	 
Storelastbyte:
	  mov ah,es:[di]
	  stosb
	  ret		
	.endif
;**********************	
; more than two bytes 
;**********************
	mov bl,bit_mask_start 
	ror bl,1	      
	xor al,al  
	      
Firstbyte2:	
	;***************************
	; unrollable
	;***************************
	or al,bl	     
	ror bl,1 
	jc storefirstbyte2			  
	;***************************	
	jmp firstbyte2	   
Storefirstbyte2:	
	mov ah,es:[di]	   
	stosb					
	sub cx,1
	mov al,0ffh			

Byteloop2:			      
	rep stosb		      ;draw all full bytes
		  
	mov bl,bit_mask_end
	xor al,al
Lastbyte2:     
	;***************************
	; unrollable
	;***************************	  
	or al,bl	 
	rol bl,1  
	jc storelastbyte2	 
	;***************************	     
		      
	jmp lastbyte2
Storelastbyte2:	    
	mov ah,es:[di]	    
	stosb				
	ret	    

Draw_dlineyi:		
	mov cx,yend
	sub cx,ystart  
	inc cx
	mov di,start_addr	
	mov al,bit_mask_start 
	ror al,1	
Pixloop3:      
	
	;***************************
	; unrollable
	;***************************
	mov ah,es:[di]
	stosb 
	add di,79
	ror al,1
	jc newbyte3 
	dec cx
	jz done3	
	;***************************
		 
	jmp pixloop3
Newbyte3:
	inc di	
	dec cx	
	jz done3
	jmp pixloop3
Done3: 
	ret

Draw_dlineyd:	  
	mov cx,ystart
	sub cx,yend 
	inc cx
	mov di,start_addr  
	mov al,bit_mask_start
	ror al,1	
Pixloop4:	
	
	;***************************
	; unrollable
	;***************************
	mov ah,es:[di]
	stosb 
	sub di,81
	ror al,1
	jc newbyte4 
	dec cx 
	jz done4	 
	;***************************
	
	jmp pixloop4
Newbyte4:
	inc di
	dec cx
	jz done4
	jmp pixloop4
Done4: 
	ret					
				 
Draw_ymyiline:		
	mov cx,deltay			     
	mov dx,cx			 
	inc dx			; error term + 1   
	neg dx	
	shl deltay,1
	mov bx,deltax		; multiply deltay * 2
	shl bx,1		
	mov di,start_addr 
	mov al,bit_mask_start
	ror al,1
Lineloop5: 
	;*****************************
	; unrollable
	;*****************************
	mov ah,es:[di]		
	stosb 
	add di,79	 
	dec cx 
	js done5		
	add dx,bx 
	jc error5      
	;*****************************
	jmp lineloop5	  
Error5:
	sub dx,deltay	      ; reset error term
	ror al,1	      ; advance y 
	jnc lineloop5	
	inc di	       
	jmp lineloop5			      
Done5:	 
	ret				 
				
Draw_xmyiline: 
	mov dx,deltax
	inc dx
	neg dx		   
	mov cx,deltax		
	mov di,start_addr	
	shl deltax,1
	shl deltay,1		      
	xor al,al
	mov bl,bit_mask_start 
	ror bl,1	  
Pixloop6:  
	;*********************
	; unrollable
	;*********************
	or al,bl	      
	ror bl,1 
	jc newbyte6	  
	dec cx
	js done6
	add dx,deltay
	jc newrun6	
	;*********************		  
	jmp pixloop6	
Newbyte6:
	dec cx
	js done6
	add dx,deltay
	jc newruninbyte6  
	mov ah,es:[di]
	stosb		
	xor al,al
	jmp pixloop6	
Newrun6:	      
	sub dx,deltax
	mov ah,es:[di]
	stosb
	dec di	
	xor al,al
	add di,80	
	jmp pixloop6 
Newruninbyte6:
	sub dx,deltax
	mov ah,es:[di]
	stosb
	dec di
	xor al,al
	add di,81
	jmp pixloop6	
Done6:	 
	mov ah,es:[di]
	stosb							      
	ret						

Draw_ymydline:		
	mov cx,deltay		; multiply deltay * 2	     
	mov dx,cx		; to know when we're done  
	inc dx			; error term + 1  
	neg dx	
	shl deltay,1		
	mov bx,deltax		; multiply deltay * 2
	shl bx,1		
	mov di,start_addr    
	mov al,bit_mask_start
	ror al,1
Lineloop7:  
	;**********************
	; unrollable
	;**********************
	mov ah,es:[di]		
	stosb 
	sub di,81	 
	dec cx 
	js done7		
	add dx,bx 
	jc error7    
	;**********************
	jmp lineloop7
Error7:
	sub dx,deltay	      
	ror al,1	      
	jnc lineloop7
	inc di	       
	jmp lineloop7			      
Done7:	 
	ret							
		    
Draw_xmydline:	    
	mov dx,deltax
	inc dx
	neg dx		   
	mov cx,deltax		
	mov di,start_addr   
	shl deltax,1
	shl deltay,1		      
	mov al,0
	mov bl,bit_mask_start 
	ror bl,1	  
Pixloop8:
	;************************
	; unrollable
	;************************
	or al,bl	 
	ror bl,1 
	jc newbyte8	  
	dec cx
	js done8
	add dx,deltay
	jc newrun8	    
	;************************			  
	jmp pixloop8	
Newbyte8:
	dec cx
	js done8
	add dx,deltay
	jc newruninbyte8  
	mov ah,es:[di]
	stosb		
	xor al,al
	jmp pixloop8	
Newrun8:	      
	sub dx,deltax
	mov ah,es:[di]
	stosb
	dec di	
	xor al,al
	sub di,80	
	jmp pixloop8  
Newruninbyte8:
	sub dx,deltax
	mov ah,es:[di]
	stosb
	dec di
	xor al,al
	sub di,79
	jmp pixloop8	
Done8:	 
	mov ah,es:[di]
	stosb							      
	ret											     

line endp					      

code ends 

end start


