; --------------------------------------------------------------
;			   poly.asm
;			   10-23-98	
;
;Draws an unfilled polygon by connecting a series of lines
;
;Parameters:
;	color		byte
;	argcount	word
;	vertex		vararg - coordinates of vertices(x:word,y:word)
;
; -------------------------------------------------------------- 

.model large,c

.486	   

include vga.inc		
		  
mGetStartAddr macro 
	mov ax,80
	mul ystart 
	mov di,ax
	mov ax,xstart 
	mov bl,8
	div bl
	mov cl,ah
	cbw
	add di,ax    
	mov al,1
	ror al,cl	   
endm	  
	
mGetEndAddr macro    
	mov ax,80
	mul yend 
	mov end_addr,ax
	mov ax,xend 
	mov bl,8
	div bl
	mov cl,ah
	cbw  
	add end_addr,ax	 
	mov bh,128
	ror bh,cl
endm				  

;***********************
; CODE SEGMENT
;***********************
code segment word public 'CODE'

Poly proc far c public,color:byte,argcount:word,vertex:vararg

	local	firstx:word,firsty:word,xstart:word,ystart:word,
		xend:word,yend:word,deltax:word,deltay:word,end_addr:word

	pusha
	push es
	
	mov ax,0a000h		 
	mov es,ax				
	mov si,0 
	mSetMapMask 1111b	;make sure map mask is ok
	mSetWriteMode 3	;setup for drawing
	mSetSR color
			   
	
	mov ax,vertex[si]
	mov firstx,ax
	mov xstart,ax
	inc si
	inc si	    
	mov ax,vertex[si]
	mov firsty,ax
	mov ystart,ax
	inc si
	inc si	  
	mov ax,vertex[si]
	mov xend,ax
	inc si
	inc si	
	mov ax,vertex[si]
	mov yend,ax
	inc si
	inc si	      
	dec argcount  
	push xend
	push yend 
	push si
	jmp DrawLine

PolyLoop:	 
	pop si	
	pop yend
	pop xend	   
	dec argcount  
	js Donepoly
	jz LastVertex
	mov ax,xend
	mov xstart,ax
	mov ax,yend
	mov ystart,ax
	mov ax,vertex[si]
	mov xend,ax
	inc si
	inc si	
	mov ax,vertex[si]
	mov yend,ax
	inc si
	inc si	   
	push xend
	push yend  
	push si	 
	jmp DrawLine
LastVertex:		  

	sub sp,6
	mov ax,xend	    ; reconnect to first vertex
	mov xstart,ax	    ;
	mov ax,yend	    ;
	mov ystart,ax	    ;
	mov ax,firstx	    ;
	mov xend,ax	    ;
	mov ax,firsty	    ;
	mov yend,ax	    ;				
DrawLine:	      
				      
	mov ax,ystart		;make sure line is drawn top to bottom
	cmp ax,yend
	jb TopToBottomOk
	je Hline		;check for horizontal line
	xchg ax,yend		;top to bottom not ok so switch y's
	mov ystart,ax		;and x's
	mov ax,xstart
	xchg ax,xend
	mov xstart,ax		      
TopToBottomOk:			;line is top to bottom		
	mov ax,yend
	sub ax,ystart
	mov deltay,ax		;deltay
	mov ax,xstart
	cmp ax,xend		;check for vertical line
	je Vline
	ja RightToLeft
LeftToRight:	    
	mov ax,xend		;deltax
	sub ax,xstart
	mov deltax,ax
	cmp ax,deltay
	jbe YMajor1		;ymajor or diagonal
XMajor1:	   
	mGetStartAddr		;setup for xmajor
	mov dx,deltax
	inc dx
	neg dx			;initial error term
	mov cx,deltax			
	shl deltax,1	 
	mov si,deltay
	shl si,1
	mov bl,al
	xor al,al
	ror bl,1	  
Pixloop1:	
	or al,bl	      
	ror bl,1 
	jc newbyte1	  
	dec cx
	js done
	add dx,si
	jc newrun1						  
	jmp pixloop1	
Newbyte1:   
	dec cx
	js done
	add dx,si
	jc newruninbyte1   
	mov ah,es:[di]
	stosb			
	xor al,al
	jmp pixloop1	
Newrun1:	
	sub dx,deltax
	mov ah,es:[di]
	stosb			
	xor al,al
	add di,79	
	jmp pixloop1 
Newruninbyte1: 
	sub dx,deltax	 
	mov ah,es:[di]
	stosb			
	xor al,al
	add di,80
	jmp pixloop1					
YMajor1:	
	mGetStartAddr		;setup for ymajor
	mov cx,deltay 
	mov si,deltay			     
	mov dx,cx			 
	inc dx					   
	neg dx			;initial error term
	shl si,1
	mov bx,deltax		;multiply deltay * 2
	shl bx,1		
	ror al,1		  
Lineloop1: 
	dec cx
	js done
	mov ah,es:[di]
	stosb		 
	add di,79			
	add dx,bx 
	jc error1	
	jmp lineloop1
Error1: 	  
	sub dx,si		;reset error term	
	ror al,1
	adc di,0	       
	jmp lineloop1							 
RightToLeft: 
	mov ax,xstart		;deltax
	sub ax,xend
	mov deltax,ax 
	cmp ax,deltay
	jbe YMajor2		;ymajor or diagonal
XMajor2:       
	mGetStartAddr		;setup for xmajor
	mov dx,deltax
	inc dx
	neg dx			;initial error term
	mov cx,deltax			
	shl deltax,1	 
	mov si,deltay
	shl si,1
	mov bl,al
	xor al,al
	ror bl,1	  
Pixloop2:	
	or al,bl		
	rol bl,1
	jc newbyte2	  
	dec cx
	js done
	add dx,si
	jc newrun2						  
	jmp pixloop2	
Newbyte2:   
	dec cx
	js done
	add dx,si
	jc newruninbyte2   
	mov ah,es:[di]
	stosb  
	sub di,2			
	xor al,al
	jmp pixloop2	
Newrun2:	
	sub dx,deltax
	mov ah,es:[di]
	stosb			
	xor al,al
	add di,79	
	jmp pixloop2 
Newruninbyte2: 
	sub dx,deltax	 
	mov ah,es:[di]
	stosb			
	xor al,al
	add di,78
	jmp pixloop2					
YMajor2:       
	mGetStartAddr		;setup ymajor
	mov cx,deltay 
	mov si,deltay			     
	mov dx,cx			 
	inc dx				   
	neg dx			;initial error term
	shl si,1
	mov bx,deltax		;multiply deltay * 2
	shl bx,1		
	ror al,1		  
Lineloop2: 
	dec cx
	js done
	mov ah,es:[di]
	stosb		 
	add di,79			
	add dx,bx 
	jc error2	
	jmp lineloop2
Error2:	  
	sub dx,si		;reset error term	 
	rol al,1
	sbb di,0	       
	jmp lineloop2							 
Vline:		 
	mGetStartAddr		;setup vline
	mov cx,yend
	sub cx,ystart  
	inc cx
	ror al,1
Pixloop3:    
	dec cx
	jz done  
	mov ah,es:[di]
	stosb			 
	add di,79					
	jmp pixloop3	
Hline:	    
	mov ax,xstart		;setup hline
	cmp ax,xend
	jb LeftToRightOk 
	xchg ax,xend
	mov xstart,ax
LeftToRightOk:	     
	mGetEndAddr   
	mGetStartAddr
	mov cx,end_addr
	sub cx,di		;length of line in bytes
	mov dl,al 
	cmp cx,0
	jnz TwoOrMoreBytes	
	ror dl,1		;only one byte
	mov al,dl	 
	dec al			  
	or al,dl
	mov bl,10000000b	   
	sub bl,bh
	or bl,10000000b
	and al,bl
	jmp done						     
TwoOrMoreBytes: 		;two or more bytes
	mov bl,al	
	ror bl,1		 
	xor al,al				
FirstByte:	 
	or al,bl
	ror bl,1    
	jc storefirstbyte				 
	jmp Firstbyte	
StoreFirstByte:		 
	mov ah,es:[di]
	stosb	     
	mov bl,bh
	xor al,al 
	cmp cx,1		;if only two bytes, skip middle
	jz LastByte	
Byteloop:			;draw all full bytes	 
	dec cx			;first byte stored	   
	mov ax,0ffffh		  
	test di,1
	jz NoOddByte
	stosb			;store odd leading byte	
	dec cx
NoOddByte:	       
	shr cx,1
	rep stosw		;store all except last byte	 
	adc cx,0		;store last odd full byte
	rep stosb			 
	mov bl,bh
	xor al,al							    
LastByte:			  
	or al,bl
	rol bl,1 
	jc done 	   
	jmp lastbyte											
Done:	
	mov ah,es:[di]		;store the last pixel
	stosb		
	jmp PolyLoop

DonePoly:
	pop es
	popa
	ret

Poly endp
code ends
end				       
