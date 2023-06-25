; --------------------------------------------------------------
;			slicline.asm 
;			   5-26-98  
;
; bresenham slice line
;
; horizontal,diagonal, and vertical lines are special cased 
;
; pixel accumulation is used for xmajor lines
;	
; -------------------------------------------------------------- 

.model large,c

.486	   

include vga.inc  

line proto far c,:word,:word,:word,:word,:byte

;***********************
; STACK SEGMENT
;***********************
stack segment word stack 'STACK' 
	dw	512	dup (?)
stack ends
;***********************
; DATA SEGMENT
;***********************
data segment word public 'DATA' 
	
	xxx0		word	0    
	yyy0		word	0
	xxx1		word	0
	yyy1		word	0  
	lastx0		word	0
	lasty0		word	0
	lastx1		word	0
	lasty1		word	0  
	
	start_addr	word	0     ; these are for line proc
	end_addr	word	0 
	bit_mask_start	byte	0 
	bit_mask_end	byte	0 
	deltax		word	0
	deltay		word	0
	first_run	word	0
	last_run	word	0
	run_length	word	0   
	counter 	word	0  
	error_term	word	0
	adjup		word	0
	adjdown 	word	0 
	error_detect	word	0
	
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
			
	mov ax,0	; initialize mouse
	int 33h 
	
	mov ax,1	; show mouse cursor
	int 33h     
	
Mouselineloop:			   
	
	mov ax,3	; get button status
	int 33h  
	
	and bl,1
	mov xxx0,cx
	mov yyy0,dx			 
	.while bl == 1	   ; then start drawing a line
	  mov ax,3
	  int 33h 
	  .if cx != xxx1 || dx != yyy1		  
	    mov xxx1,cx
	    mov yyy1,dx	
	    push cx
	    push dx
	    push bx 
	    mov ax,2
	    int 33h			      
	    invoke line,xxx0,yyy0,xxx1,yyy1,0001b	
	    mov ax,1
	    int 33h   
	    pop bx  
	    pop dx
	    pop cx	 
	  .endif
	  and bl,1
	.endw	
	mov ah,1
	int 16h
	jz mouselineloop	
	
	mov ax,0700h
	int 21h
			
	mov ax,0003h
	int 10h
	
	mov ax,4c00h
	int 21h
	
start endp

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
	mov bit_mask_end,128
	ror bit_mask_end,cl	
	endm			  
	
	mov ax,0a000h
	mov es,ax		      
	
	mSetmapmask color							
	mSetwritemode 3 
	mSetsr 0ffh	
	
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

Byteloop2:			      ;draw all full bytes
	mov ah,es:[di]
	rep stosb  
		  
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
;*********************************************
; cx: counter for each runloop
; dx: counter ro determine when runs are done
; bx: error_term
;*********************************************	 

	mov ax,deltay		   ; run_length
	xor dx,dx
	div deltax					  
				
	push dx
	mov run_length,ax	
	
	shl dx,1		   ; adjup
	mov adjup,dx		  
	
	mov bx,deltax		   ; adjdown 
	push bx
	shl bx,1
	mov adjdown,bx
	       
	mov cx,run_length	   ; first and last run
	shr cx,1
	inc cx
	mov first_run,cx
	mov last_run,cx	
	
	pop error_detect	   
	shl error_detect,1	
	
	pop bx			   ; error_term
				   
	and ax,1			; initial error_term	  
	.if (ax == 0) && (adjup == 0)	; ax has run_length
	  dec first_run
	.endif
	.if ax != 0
	  add bx,deltax
	.endif		    
	
	mov cx,first_run
	mov dx,deltax
	mov al,bit_mask_start
	ror al,1			  

Firstrun5:			  
	;***************************
	; this loop can be unrolled
	;***************************
	mov ah,es:[di]		
	stosb
	add di,79
	dec cx 
	jz donefirstrun5  
	;***************************
	  
	jmp firstrun5		    
Donefirstrun5:
	mov cx,run_length	   
	ror al,1  
	.if al == 10000000b
	  inc di  
	.endif
	dec dx
	jz lastrun5
Fullrun5:
	add bx,adjup
	.if bx >= error_detect
	  sub bx,adjdown
	  inc cx
	.endif 
Runloop5:
	mov ah,es:[di]		   ; this loop can be 
	stosb			   ; unrolled
	add di,79
	dec cx	
	jz donerun5
	jmp runloop5	
Donerun5:
	mov cx,run_length
	ror al,1 
	jnc nonewbyte5
	inc di	 
Nonewbyte5:
	dec dx 
	jz lastrun5
	jmp fullrun5
Lastrun5: 
	mov cx,last_run 
Lastrun5l:	
		   
	;***************************
	; this loop can be unrolled 
	;***************************	
	mov ah,es:[di]	    
	stosb		     
	add di,79
	dec cx	
	jz donelastrun5        
	;***************************		     
	  
	jmp lastrun5l	
Donelastrun5:
	ret		       
				
Draw_xmyiline: 
;*********************************************
; cx: counter for each runloop
; dl: bit accumulator
; bx: error_term
;*********************************************	 
	mov ax,deltax		   ; run_length
	mov bx,deltay
	mov dx,0
	div bx	  

	mov run_length,ax    
	push ax
	push dx	
		
	shl dx,1		   ; adjup
	mov adjup,dx	  
		 
	shl bx,1		   ; adjdown
	mov adjdown,bx		   
	       
	shr ax,1		   ; first and last run
	inc ax
	mov first_run,ax
	mov last_run,ax     
	
	pop ax			   ; error_term  
	sub ax,deltay
	sub ax,deltay
	mov error_term,ax	
	      
	pop bx			   ; initial error_term 
	and bx,1	 
	.if (bx == 0) && (adjup == 0)
	  dec first_run
	.endif	 
	.if bx != 0
	  mov ax,error_term
	  add ax,deltay 
	  mov error_term,ax
	.endif			
	
	mov bx,error_term
	mov cx,first_run
	mov dl,bit_mask_start
	ror dl,1 
	xor al,al
Firstrun6:	   
	
	;***************************
	; this loop can be unrolled
	;***************************
	or al,dl	    
	ror dl,1 
	jc newbyte6f
	dec cx
	jz donefirstrun6				 
	;***************************
		
	jmp firstrun6 
Newbyte6f:
	mov ah,es:[di]	 
	stosb		
	xor al,al	  
	dec cx
	jnz firstrun6	
Donefirstrun6:
	mov ah,es:[di]
	stosb
	dec di
	xor al,al
	add di,80
	mov cx,run_length
	dec deltay   
	jz lastrun6					 
Fullrun6:	    
	add bx,adjup		 ; check for error  
	jnc newrun6
	sub bx,adjdown
	inc cx 
Newrun6:	     
	;***************************
	; this loop can be unrolled
	;***************************	   
	or al,dl	   
	ror dl,1 
	jc newbyte6
	dec cx
	jz donerun6	
	;***************************
		
	jmp newrun6	
Newbyte6:
	mov ah,es:[di]
	stosb
	xor al,al	  
	dec cx	  
	jnz newrun6	
Donerun6:			
	mov ah,es:[di]
	stosb
	dec di	
	xor al,al 
	mov cx,run_length	
	add di,80 
	dec deltay 
	jz lastrun6
	jmp fullrun6	
Lastrun6:  
	mov cx,last_run  
Lastrun6l:		
			  
	;***************************
	; this loop can be unrolled
	;***************************
	or al,dl	   
	ror dl,1  
	jc newbyte6l
	dec cx
	jz donelastrun6 	
	;***************************
	  
	jmp lastrun6l
Newbyte6l:  
	mov ah,es:[di]
	stosb
	xor al,al
	dec cx	
	jnz lastrun6l
Donelastrun6:
	mov ah,es:[di]
	stosb
	ret
				

Draw_ymydline:			
;*********************************************
; cx: counter for each runloop
; dx: counter ro determine when runs are done
; bx: error_term
;*********************************************

	mov ax,deltay		   ; run_length
	xor dx,dx
	div deltax

	push dx
	mov run_length,ax	
				   
	shl dx,1		   ; adjup  
	mov adjup,dx		  
	
	mov bx,deltax		   ; adjdown	
	push bx
	shl bx,1
	mov adjdown,bx
	       
	mov cx,run_length	   ; first and last run
	shr cx,1
	inc cx
	mov first_run,cx
	mov last_run,cx	   
	
	pop error_detect
	shl error_detect,1
	
	pop bx			   ; error_term
	
	and ax,1
	.if (ax == 0) && (adjup == 0)
	  dec first_run
	.endif
	.if ax != 0
	  add bx,deltax
	.endif		    
	
	mov cx,first_run
	mov dx,deltax
	mov al,bit_mask_start
	ror al,1   
       
Firstrun7:		  

	;***************************
	; this loop can be unrolled
	;***************************
	mov ah,es:[di]	   
	stosb
	sub di,81
	dec cx
	jz donefirstrun7	 
	;*************************** 
	  
	jmp firstrun7
Donefirstrun7: 
	mov cx,run_length 
	ror al,1
	.if al == 10000000b
	  inc di
	.endif 
	dec dx
	jz lastrun7
Fullrun7:
	add bx,adjup
	.if bx >= error_detect
	  sub bx,adjdown
	  inc cx
	.endif	
Runloop7:		     
		     
	;***************************
	; this loop can be unrolled
	;***************************
	mov ah,es:[di]	
	stosb
	sub di,81
	dec cx
	jz donerun7	 
	;***************************
		    
	jmp runloop7 
Donerun7:	  
	mov cx,run_length
	ror al,1
	.if al == 10000000b
	  inc di
	.endif 
	dec dx 
	jz lastrun7
	jmp fullrun7 
	
Lastrun7:
	mov cx,last_run 
Lastrun7l:		     
		  
	;***************************
	; this loop can be unrolled
	;***************************	
	mov ah,es:[di]	   
	stosb 
	sub di,81
	dec cx 
	jz donelastrun7 	 
	;***************************	
	  
	jmp lastrun7l	 
Donelastrun7:
	ret						
		    
Draw_xmydline:		  
;*********************************************
; cx: counter for each runloop
; dl: bit accumulator
; bx: error_term
;*********************************************
	mov ax,deltax		   ; run_length
	mov bx,deltay
	mov dx,0
	div bx
				
	mov run_length,ax    
	push ax
	push dx	
		
	shl dx,1		   ; adjup
	mov adjup,dx	  
		 
	shl bx,1		   ; adjdown
	mov adjdown,bx		   
	       
	shr ax,1		   ; first and last run
	inc ax
	mov first_run,ax
	mov last_run,ax     
	
	pop ax			   ; error_term  
	sub ax,deltay
	sub ax,deltay
	mov error_term,ax	
	      
	pop bx			   ; initial error_term 
	and bx,1	 
	.if (bx == 0) && (adjup == 0)
	  dec first_run
	.endif	 
	.if bx != 0
	  mov ax,error_term
	  add ax,deltay 
	  mov error_term,ax
	.endif			
	
	mov bx,error_term
	mov cx,first_run
	mov dl,bit_mask_start
	ror dl,1
	xor al,al
Firstrun8:		
		  
	;***************************
	; this loop can be unrolled
	;***************************
	or al,dl	  
	ror dl,1
	jc newbyte8f 
	dec cx
	jz donefirstrun8     
	;***************************
	
	jmp firstrun8
Newbyte8f:
	mov ah,es:[di]
	stosb
	xor al,al	
	dec cx
	jnz firstrun8
Donefirstrun8:
	mov ah,es:[di]
	stosb
	dec di
	xor al,al
	sub di,80
	mov cx,run_length	 ; only two runs       
	dec deltay		 ; so skip fullrun loop	 
	jz lastrun8	
Fullrun8:	
	add bx,adjup		 ; check for error  
	jnc newrun8
	sub bx,adjdown
	inc cx	
Newrun8:		    
		     
	;***************************
	; this loop can be unrolled
	;***************************
	or al,dl	     
	ror dl,1 
	jc newbyte8
	dec cx
	jz donerun8	  
	;***************************
	    
	jmp newrun8
Newbyte8:
	mov ah,es:[di]
	stosb
	xor al,al
	dec cx 
	jnz newrun8
Donerun8:			
	mov ah,es:[di]
	stosb
	dec di	
	xor al,al 
	mov cx,run_length	
	sub di,80 
	dec deltay 
	jz lastrun8	
	jmp fullrun8	   
	      
Lastrun8: 
	mov cx,last_run	  
Lastrun8l:	      
		       
	;***************************
	; this loop can be unrolled
	;***************************
	or al,dl	   
	ror dl,1 
	jc newbyte8l
	dec cx 
	jz donelastrun8       
	;***************************
	  
	jmp lastrun8l
Newbyte8l:
	mov ah,es:[di]
	stosb 
	xor al,al
	dec cx 
	jnz lastrun8l
Donelastrun8:
	mov ah,es:[di]
	stosb
	ret  
							
line endp				
code ends
end start						 
