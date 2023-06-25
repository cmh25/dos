; --------------------------------------------------------------
;			  fpoly.asm
;                         10-25-98  
;
;Draws filled polygons
;This proc draws the same polygon that Poly proc (unfilled) will draw
;
;Parameters:
;	color		byte
;	count		word - number of vertices
;	line_list_ptr	dword - far pointer to buffer (3000 words)
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
	
Fpoly proc far c public,color:byte,count:word,line_list_ptr:dword,
			vertex:vararg			   

	local   deltax:word,deltay:word,topy_ptr:word,
		botty_ptr:word,xstart:word,ystart:word,xend:word,yend:word,
		hline_count:word,top_y:word,top_x:word,lastx:word,lasth:word
		
	local   reset:word,line_count:word,upx:word,upy:word,downx:word,
		downy:word,bott_y:word,end_addr:word,last_x:word,
		topedgey1_ptr:word,topedgey2_ptr:word,
		topedgex1:word,topedgex2:word,bottedgey1_ptr:word,
		bottedgey2_ptr:word	
			
		
	pusha
	push ds
	push es
;
;implement far pointer here
;store high word in ds
;			      

	lds di,line_list_ptr

	mov ax,ds               ;setup es for copying xcoords to buffer 
	mov es,ax                    
	
	mov ax,0		;clear buffer so no leftovers	
	lds di,line_list_ptr
	mov cx,3000
	rep stosw           
	
	mSetMapMask 1111b	;setup for drawing
	mSetWriteMode 3
	mSetSR color
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;find top and bottom-
;               rotates through vertex list recording
;               the lowest and highest ycoords in topy
;               and botty, respectively.
;               cx - keeps track of vlist position
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        
	mov cx,count
	mov si,2          
	mov ax,vertex[si]        
	mov topy_ptr,si  
	mov top_y,ax     
	mov bx,vertex[si]
	mov botty_ptr,si   
	mov bott_y,bx        
	add si,4  
Vloop:           
	dec cx 
	jz donevloop
	.if ax > vertex[si]     ;then new topy
	  mov ax,vertex[si]          
	  mov topy_ptr,si  
	  mov top_y,ax  
	.endif           
	.if bx < vertex[si]	 ;then new botty  
	  mov bx,vertex[si]
	  mov botty_ptr,si  
	  mov bott_y,bx 
	.endif
	add si,4 
	jmp vloop 
Donevloop:        
	mov si,botty_ptr
	mov ax,vertex[si]
	mov si,topy_ptr
	sub ax,vertex[si] 
	inc ax
	mov hline_count,ax      ;number of hlines to draw   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;find top and bottom edges                                 
;and find out if upleft, downleft, or vert/slope test
;but first, make sure all y's are not equal
;if they are, setup the variables and jmp to 1horizontalline
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
	mov cx,count
	mov si,2
checkhloop:
	mov ax,vertex[si]   
	cmp ax,top_y
	jne nothorizontalline   
	add si,4
	dec cx
	jnz checkhloop   
	;       
	;we got through the loop without finding                        
	;a different value, so it's a horizontal                        
	;line(or a pixel) 
	;so we need to find hline_count,xstart,ystart,xend,and yend;
	;and jmp straight to drawhlinelist
	;
	mov hline_count,0       ;(js donehlinelist)
	mov ax,top_y
	mov ystart,ax
	mov yend,ax
	mov si,0  
	mov cx,count
	mov bx,vertex[si]
	mov dx,vertex[si] 
	dec cx
xstartxendloop:   
	add si,4
	mov ax,vertex[si]
	cmp ax,bx
	jae nonewxstart
	mov bx,ax
nonewxstart:            
	cmp ax,dx
	jbe nonewxend
	mov dx,ax
nonewxend:
	dec cx
	jnz xstartxendloop  
	mov xstart,bx
	mov xend,dx    
	mov ax,0a000h
	mov es,ax       
	jmp only1hline          ;there is only one hline to draw
				;so we'll jmp here
	

nothorizontalline:
	mov cx,count            ;for end of list
	shl cx,2
	
	mov si,topy_ptr
	mov ax,vertex[si]
	mov top_y,ax
	;
	;search down the list till edge is found
	;                

topedgeloop1:
	mov topedgey1_ptr,si
	cmp si,2
	jnz nojmpend
	mov si,cx
	add si,2
nojmpend:
	sub si,4
	mov ax,vertex[si]
	cmp ax,top_y
	je topedgeloop1  
	
	mov si,topy_ptr
	mov ax,vertex[si]
	;
	;search up list till edge is found
	;
topedgeloop2:
	mov topedgey2_ptr,si
	add si,2
	cmp si,cx
	jnz nojmpbegin
	mov si,0
nojmpbegin:
	add si,2
	mov ax,vertex[si]
	cmp ax,top_y
	je topedgeloop2
	;
	;done finding top edges
	;now find bottom edges
	;
	mov si,botty_ptr
	mov ax,vertex[si]
	mov bott_y,ax
	;
	;search down the list till edge is found
	;
bottedgeloop1:
	mov bottedgey1_ptr,si
	cmp si,2
	jnz nojmpend1
	mov si,cx
	add si,2
nojmpend1:
	sub si,4
	mov ax,vertex[si]
	cmp ax,bott_y
	je bottedgeloop1
	mov si,botty_ptr
	mov ax,vertex[si]
	;
	;search up list till edge is found
	;
bottedgeloop2:
	mov bottedgey2_ptr,si
	add si,2
	cmp si,cx
	jnz nojmpbegin1
	mov si,0
nojmpbegin1:
	add si,2
	mov ax,vertex[si]
	cmp ax,bott_y
	je bottedgeloop2    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;edges found
;now get and compare topedgex1 and topedgex2
;if equal - top is pointed
;if topedgex1 < topedgex2 - jmp downleft
;if topedgex1 > topedgex2 - jmp upleft
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov si,topedgey1_ptr
	sub si,2
	mov ax,vertex[si]
	mov topedgex1,ax
	mov si,topedgey2_ptr
	sub si,2
	mov bx,vertex[si]
	mov topedgex2,bx
	cmp ax,bx
	jb downleft
	ja upleft
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;the top was pointed
;so do a vert check and a slope test to determine 
;which direction through the vertex list takes us 
;down the left edge          
;get upx,downx,upy,and downy while we're at it in case
;we have to do a slope test
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov cx,count
	shl cx,2
	mov si,topy_ptr
	sub si,2
	mov ax,vertex[si]
	mov top_x,ax
	add si,4
	cmp si,cx
	jnz nojmpbegin2
	mov si,0
nojmpbegin2:
	mov ax,vertex[si]
	mov upx,ax  
	add si,2
	mov ax,vertex[si]
	mov upy,ax
	mov si,topy_ptr
	sub si,2
	cmp si,0
	jnz nojmpend3
	mov si,cx
nojmpend3:
	sub si,4
	mov ax,vertex[si]
	mov downx,ax
	add si,2
	mov ax,vertex[si]
	mov downy,ax
	;
	;upx,upy,downx,and downy found
	;
	mov ax,top_x
	cmp ax,downx
	jb downxhigher
	ja downxlower
	je downxvert
downxhigher:
	cmp ax,upx
	jae upleft
	jb slopetest
downxlower:
	cmp ax,upx
	jbe downleft
	ja slopetest
downxvert:
	cmp ax,upx
	jb downleft
	jae upleft        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;both downx and upx were either both higher or both lower
;than top_x so we will do a slope test to see which one
;takes us down the left edge
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
slopetest:               
	finit                   ;compare the slopes, the lowest one is
	fild top_x              ;the left edge
	fild downx
	fsub
	fild top_y
	fild downy
	fsub
	fdiv
	fild top_x
	fild upx
	fsub
	fild top_y
	fild upy
	fsub
	fdiv   
	fcompp
	fstsw ax
	sahf   
	jbe upleft      
	     
Downleft:    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;down the vertex list takes us down the seft edge so we'll
;scan down and then scan up
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;*********************************************************;
;arrival here could be used for backface removal
;if we dedicate polygon vertices to always being listed
;in counterclockwise order, going up the vertex list 
;will take us down the left edge
;if we are dedicated to this rule and going down the vertex
;list takes us down the left edge, it means the polygon has 
;its back to us, in which case we will return without
;drawing the polygon
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
pop es
pop ds
popa
ret                             ;for backface removal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;scan downleft-
;       starts at the top and scans to the bottom going
;       down through the vertex list.
;       si - has index of current item in the vertex list
;       di - line_list_ptr   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
	lds di,line_list_ptr
	mov reset,0     
	mov cx,count
	shl cx,2 
	add cx,2                
	mov si,topedgey1_ptr            
Scandownrightd:      
	mov ax,vertex[si]       ;get the first coords of the line
	mov ystart,ax      
	mov es:[di],ax
	inc di
	inc di  
	dec si
	dec si   
	mov ax,vertex[si]
	mov xstart,ax    
	mov es:[di],ax
	inc di
	inc di
	dec si 
	js endlist3d
	dec si  
Resume3d:       
	mov ax,vertex[si]
	mov yend,ax  
	mov es:[di],ax
	inc di
	inc di
	push si
	dec si  
	dec si    
	mov ax,vertex[si]  
	mov xend,ax   
	mov es:[di],ax
	inc di
	inc di  
	inc reset
	mov ax,xend
	mov xstart,ax  
	mov ax,yend
	mov ystart,ax 
	mov es:[di],ax
	inc di
	inc di
	mov ax,xstart
	mov es:[di],ax
	inc di
	inc di   
	 
	pop si        
	cmp si,bottedgey2_ptr   
	jz donescan3d        
	dec si
	dec si
			
	dec si
	js endlist3d
	dec si   

	jmp resume3d
Endlist3d:          
	xor si,si               ;jmp to end of list
	add si,count                
	add si,count                     
	add si,count                
	add si,count                  
	sub si,2               
	jmp Resume3d
Donescan3d:     
	
	sub di,2		;zero out the two odd words	 
	mov ax,0                ;and backup di
	mov es:[di],ax
	sub di,2
	mov es:[di],ax          
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;scan upright-       
;       starts at the top and scans to the bottom going
;       up through the vertex list.
;       cx - lets us know when to jump to beginning of vertex list
;       si - has index of current item in the vertex list
;       di - line_list_ptr      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;       
	mov si,topedgey2_ptr  
	mov line_count,0           
   
Scanupleftd:          
	mov ax,vertex[si]
	mov ystart,ax    
	mov es:[di],ax
	inc di
	inc di
	
	dec si
	dec si     
	mov ax,vertex[si]
	mov xstart,ax  
	mov es:[di],ax
	inc di
	inc di  
	add si,6
	cmp si,cx
	jz endlist2d
Resume2d:       
	mov ax,vertex[si]
	mov yend,ax 
	mov es:[di],ax
	inc di
	inc di 
	push si
	dec si
	dec si
	mov ax,vertex[si]
	mov xend,ax 
	mov es:[di],ax
	inc di
	inc di    
	inc line_count
	mov ax,xend
	mov xstart,ax  
	mov ax,yend
	mov ystart,ax 
	mov es:[di],ax
	inc di
	inc di
	mov ax,xstart   
	mov es:[di],ax
	inc di
	inc di   
	
	pop si    
	cmp si,bottedgey1_ptr   
	jz donescan2d   
	dec si
	dec si      
		
	add si,6
	cmp si,cx
	jz endlist2d    
	
	jmp resume2d
Endlist2d:          
	mov si,2                ;back to beginning of list
	jmp resume2d
Donescan2d:      
	sub di,2                ;zero out the two odd words     
	mov ax,0                ;and backup di
	mov es:[di],ax
	sub di,2
	mov es:[di],ax 
	jmp formhlinelist

Upleft:                      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;up the vertex list takes us down the left edge so we'll
;scan up and then scan down
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;scan upleft-        
;       starts at the top and scans to the bottom going
;       up through the vertex list.
;       cx - lets us know when to jump to beginning of vertex list
;       si - has index of current item in the vertex list
;       di - line_list_ptr      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;       
	mov si,topedgey2_ptr  
	lds di,line_list_ptr
	mov reset,0     
	mov cx,count
	shl cx,2 
	add cx,2     
   
Scanupleft:           
	mov ax,vertex[si]
	mov ystart,ax    
	mov es:[di],ax
	inc di
	inc di
	
	dec si
	dec si     
	mov ax,vertex[si]
	mov xstart,ax  
	mov es:[di],ax
	inc di
	inc di  
	add si,6
	cmp si,cx
	jz endlist2
Resume2:        
	mov ax,vertex[si]
	mov yend,ax 
	mov es:[di],ax
	inc di
	inc di 
	push si
	dec si
	dec si
	mov ax,vertex[si]
	mov xend,ax 
	mov es:[di],ax
	inc di
	inc di    
	inc reset
	mov ax,xend
	mov xstart,ax  
	mov ax,yend
	mov ystart,ax 
	mov es:[di],ax
	inc di
	inc di
	mov ax,xstart   
	mov es:[di],ax
	inc di
	inc di   
	
	pop si    
	cmp si,bottedgey1_ptr   
	jz donescan2    
	dec si
	dec si      
		
	add si,6
	cmp si,cx
	jz endlist2     
	
	jmp resume2
Endlist2:           
	mov si,2                ;back to beginning of list
	jmp resume2
Donescan2:       
	sub di,2                ;zero out the two odd words     
	mov ax,0                ;and backup di
	mov es:[di],ax
	sub di,2
	mov es:[di],ax 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;scan downright-
;       starts at the top and scans to the bottom going
;       down through the vertex list.
;       si - has index of current item in the vertex list
;       di - line_list_ptr   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
	mov si,topedgey1_ptr       
	mov line_count,0        
Scandownright:       
	mov ax,vertex[si]       ;get the first coords of the line
	mov ystart,ax      
	mov es:[di],ax
	inc di
	inc di  
	dec si
	dec si   
	mov ax,vertex[si]
	mov xstart,ax    
	mov es:[di],ax
	inc di
	inc di
	dec si 
	js endlist3
	dec si  
Resume3:        
	mov ax,vertex[si]
	mov yend,ax  
	mov es:[di],ax
	inc di
	inc di
	push si
	dec si  
	dec si    
	mov ax,vertex[si]  
	mov xend,ax   
	mov es:[di],ax
	inc di
	inc di  
	inc line_count
	mov ax,xend
	mov xstart,ax  
	mov ax,yend
	mov ystart,ax 
	mov es:[di],ax
	inc di
	inc di
	mov ax,xstart
	mov es:[di],ax
	inc di
	inc di   
	 
	pop si        
	cmp si,bottedgey2_ptr   
	jz donescan3         
	dec si
	dec si
			
	dec si
	js endlist3
	dec si   

	jmp resume3
Endlist3:           
	xor si,si               ;jmp to end of list
	add si,count                
	add si,count                     
	add si,count                
	add si,count                  
	sub si,2               
	jmp Resume3
Donescan3:      
	
	sub di,2                ;zero out the two odd words     
	mov ax,0                ;and backup di
	mov es:[di],ax
	sub di,2
	mov es:[di],ax          
					
Formhlinelist:  
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;form real hlinelist     
;scan left edge first, right edge last using the appropriate 
;rules for each side
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
Scanleftedge:		
	lds si,line_list_ptr	;set si to beginning of buffer	  
				;di is already set to right place in buffer
	push di                 ;for reset
	push di                 ;for drawhlinelist       
		  
Scan1:      
	mov lasth,0             ;we are guaranteed the first line
	mov lastx,ax            ;will not be horizontal
Scan1h: 
	dec reset
	js scanrightedge
	mov ax,ds:[si]          ;setup to scan line
	mov ystart,ax
	inc si
	inc si                     
	mov ax,ds:[si]
	mov xstart,ax
	inc si
	inc si
	mov ax,ds:[si]
	mov yend,ax
	inc si
	inc si
	mov ax,ds:[si]
	mov xend,ax
	inc si
	inc si  
		 
	mov ax,xend
	cmp ax,xstart
	je Draw_vline1
	 
	mov ax,yend             ;setup deltay
	sub ax,ystart               
	jz Hline
	mov deltay,ax              
	
	mov ax,xstart
	.if xend > ax           ;then left to right  
	  mov ax,xend
	  sub ax,xstart
	  mov deltax,ax         ;setup deltax 
	  jmp scanltor1
	.elseif xend < ax       ;then right to left  
	  mov ax,xstart
	  sub ax,xend
	  mov deltax,ax         ;setup deltax
	  jmp scanrtol1
	.endif                  
	
Hline:                                                     
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;if the hline is going from the center out, we will
	;skip it
	;
	;if the hline is going to the middle from the outside,
	;we will draw the last pixel of the previous line if the
	;previous line was not horizontal
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
	cmp lasth,1             ;was last line horizontal?
	jz scan1h               ;yes, so skip this one 
	mov lasth,1
	mov ax,xstart
	cmp ax,xend             ;toward middle?
	ja scan1h               ;no, so skip it
	mov ax,lastx
	mov es:[di],ax
	add di,4
	jmp scan1h
	
Draw_vline1:                    ;then vertical
	
	mov cx,yend
	sub cx,ystart  
	mov ax,xstart
	mov bx,ystart     

Pixloop1:    
	
	;***************************
	; unrollable    
	;*************************** 
	dec cx
	js Scan1        
	mov es:[di],ax
	add di,4
	add bx,1          
	;***************************  
				
	jmp pixloop1                            
	  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;         
Scanltor1:                                                      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	       
	mov ax,deltax   
	cmp ax,deltay
	ja draw_xmyiline11
	jbe draw_ymyiline11   
								 
Draw_ymyiline11:           
	mov cx,deltay           ;counter                     
	mov dx,cx                        
	inc dx            
	neg dx                  ;initial error term 
	shl deltay,1
	shl deltax,1            ;multiply deltax * 2    
	mov ax,xstart
	mov bx,ystart    
Lineloop11: 
	;*****************************
	; unrollable
	;*****************************  
	dec cx
	js Scan1
	mov es:[di],ax
	add di,4
	inc bx    
	add dx,deltax
	jc error11      
	;*****************************  
	
	jmp lineloop11
Error11:          
	sub dx,deltay           ;reset error term           
	inc ax 
	jmp lineloop11                                                   
				
Draw_xmyiline11:            
	mov dx,deltax
	inc dx  
	neg dx                  ;initial error term
	mov cx,deltax           ;counter
	shl deltax,1     
	shl deltay,1    
	mov ax,xstart
	mov bx,ystart   
	mov es:[di],ax          ;always store the first one  
	add di,4        

Lineloop111:     
	;*********************
	; unrollable
	;*********************  
	dec cx
	js Scan1                
	add dx,deltay
	jc error111    
	inc ax
	;********************* 
					  
	jmp lineloop111 
Error111:       
	sub dx,deltax  
	inc bx  
	inc ax  
	mov es:[di],ax    
	add di,4                         
	jmp lineloop111  
		 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Scanrtol1:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		

	mov ax,deltax
	.if ax > deltay 
	  jmp draw_xmyiline12
	.endif
								 
Draw_ymyiline12:           
	mov cx,deltay           ;counter                     
	mov dx,cx                        
	inc dx          
	neg dx                  ;initial error term
	shl deltay,1
	shl deltax,1            ;multiply deltax * 2    
	mov ax,xstart
	mov bx,ystart  
		
Lineloop12: 
	;*****************************
	; unrollable
	;*****************************  
	dec cx
	js Scan1
	mov es:[di],ax
	add di,4
	inc bx  
	add dx,deltax
	jc error12      
	;*****************************  
	
	jmp lineloop12
Error12:                
	sub dx,deltay   
	dec ax  
	jmp lineloop12                                                   
				
Draw_xmyiline12:        
	mov dx,deltax
	inc dx   
	neg dx                  ;initial error term
	mov cx,deltax           ;counter
	shl deltax,1     
	shl deltay,1    
	mov ax,xstart  
	mov bx,ystart  
	
Lineloop121:     
	;*********************
	; unrollable
	;*********************  
	dec cx
	js Scan1         
	add dx,deltay
	jc error121   
	dec ax
	;********************* 
					  
	jmp lineloop121 
Error121:       
	sub dx,deltax           
	inc bx          
	mov es:[di],ax  
	add di,4     
	dec ax
	jmp lineloop121 
						   
Scanrightedge:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;scan right edge
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
	mov es:[di],ax          ;store last point from left edge
	
	pop di                  ;adjust index in line_list
	add di,2		       

Scan2:        
	mov lasth,0             ;we are guaranteed the first line
	mov lastx,ax            ;will not be horizontal
Scan2h:
	dec line_count
	js drawhlinelist                
	mov ax,ds:[si]          ;setup to scan line
	mov ystart,ax
	inc si
	inc si
	mov ax,ds:[si]
	mov xstart,ax
	inc si
	inc si
	mov ax,ds:[si]
	mov yend,ax
	inc si
	inc si   
	
	mov ax,ds:[si]
	mov xend,ax
	inc si
	inc si                
	
	mov ax,xend
	cmp ax,xstart
	je Draw_vline2
		  
	mov ax,yend             ;setup deltay
	sub ax,ystart               
	jz DrawHline2 
	mov deltay,ax              
	
	mov ax,xstart
	.if xend > ax           ;then left to right  
	  mov ax,xend
	  sub ax,xstart
	  mov deltax,ax         ;setup deltax 
	  jmp scanltor2
	.elseif xend < ax       ;then right to left  
	  mov ax,xstart
	  sub ax,xend
	  mov deltax,ax         ;setup deltax
	  jmp scanrtol2
	.endif
	
Draw_vline2:                    ;then vertical
	
	mov cx,yend
	sub cx,ystart  
	mov ax,xstart 
	mov bx,ystart     

Pixloop2:    
	
	;***************************
	; unrollable    
	;*************************** 
	dec cx
	js Scan2
	mov es:[di],ax
	add di,4
	add bx,1          
	;***************************  
				
	jmp pixloop2   
	
DrawHline2:

	;
	;while scanning down the right edge, we found a horizontal
	;line.  If it's on the bottom, we'll put the biggest xcoord 
	;in ax and jump to drawhlinelist and let it store it for us 
	;as the last on the right side.
	;if it's not on the bottom we'll draw the last pixel of the 
	;previous line if the hline is going toward the middle and 
	;the previous line was not horizontal
	;
	;if it's not on the bottom and the hline is going from the
	;middle to the outside, we'll skip it
	;              
	cmp line_count,0
	jnz notbottomhline              ;it's not on the bottom
	mov ax,xstart
	cmp ax,xend
	ja drawhlinelist
	mov ax,xend
	jmp drawhlinelist   

notbottomhline:  
	cmp lasth,1             ;was last line horizontal?
	jz scan2h               ;yes, so skip this one   
	mov lasth,1
	mov ax,xstart
	cmp ax,xend             ;to middle or away?
	jb scan2h               ;away, so skip it
	mov ax,lastx            ;to middle, so draw lastx  
	mov es:[di],ax         
	add di,4
	jmp scan2h              
	
	  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;         
Scanltor2:                                                      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	       
	mov ax,deltax   
	cmp ax,deltay
	ja draw_xmyiline21
	jbe draw_ymyiline21     
								 
Draw_ymyiline21:           
	mov cx,deltay           ;counter                     
	mov dx,cx                        
	inc dx            
	neg dx                  ;initial error term 
	shl deltay,1
	shl deltax,1            ;multiply deltax * 2    
	mov ax,xstart   
	mov bx,ystart   

Lineloop21: 
	;*****************************
	; unrollable
	;*****************************  
	dec cx
	js Scan2
	mov es:[di],ax
	add di,4
	inc bx    
	add dx,deltax
	jc error21      
	;*****************************  
	
	jmp lineloop21
Error21:          
	sub dx,deltay           ;reset error term           
	inc ax 
	jmp lineloop21                                                   
				
Draw_xmyiline21:            
	mov dx,deltax
	inc dx    
	neg dx                  ;initial error term
	mov cx,deltax           ;counter
	shl deltax,1     
	shl deltay,1    
	mov ax,xstart     
	mov bx,ystart  
Lineloop211:     
	;*********************
	; unrollable
	;********************* 
	dec cx
	js Scan2        
	add dx,deltay
	jc error211      
	inc ax
	;********************* 
					  
	jmp lineloop211 
Error211:       
	sub dx,deltax  
	inc bx  
	mov es:[di],ax
	add di,4    
	inc ax                   
	jmp lineloop211  
		 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Scanrtol2:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		

	mov ax,deltax
	.if ax > deltay 
	  jmp draw_xmyiline22
	.endif
								 
Draw_ymyiline22:           
	mov cx,deltay           ;counter                     
	mov dx,cx                        
	inc dx     
	neg dx                  ;initial error ter
	shl deltay,1
	shl deltax,1            ;multiply deltax * 2    
	mov ax,xstart      
	mov bx,ystart   


Lineloop22: 
	;*****************************
	; unrollable
	;*****************************  
	dec cx
	js Scan2
	mov es:[di],ax
	add di,4
	inc bx  
	add dx,deltax
	jc error22      
	;*****************************  
	
	jmp lineloop22
Error22:                
	sub dx,deltay   
	dec ax  
	jmp lineloop22                                                   
				
Draw_xmyiline22:        
	mov dx,deltax
	inc dx
	neg dx                  ;initial error term     
	mov cx,deltax           ;counter
	shl deltax,1     
	shl deltay,1    
	mov ax,xstart   
	mov bx,ystart  
	mov es:[di],ax          ;store first on this side
	add di,4         
	
Lineloop221:     
	
	;*********************
	; unrollable
	;*********************  
	dec cx
	js Scan2                 
	add dx,deltay
	jc error221
	dec ax  
	;********************* 
					  
	jmp lineloop221 
Error221:       
	sub dx,deltax           
	inc bx     
	dec ax;???      
	mov es:[di],ax  
	add di,4  
	jmp lineloop221 
		     
Drawhlinelist: 
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;at this point, the hline list is formed and will now be drawn
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
	mov es:[di],ax
	
	pop si			;line_list_ptr	 
				     
	mov ax,top_y            ;the topy coordinate
	dec ax                  ;to adjust for the inc in the loop
	mov ystart,ax           
	mov yend,ax             
	
	mov ax,0a000h
	mov es,ax  

Getcoords: 
	     
	dec hline_count
	js donehlinelist        
	mov ax,ds:[si]
	mov xstart,ax
	add si,2
	mov ax,ds:[si]
	mov xend,ax
	add si,2   
	inc ystart
	inc yend   
	
only1hline:     
					
	mGetEndAddr   
	mGetStartAddr
	mov cx,end_addr
	sub cx,di               ;length of line in bytes
	mov dl,al 
	cmp cx,0
	jnz TwoOrMoreBytes      
	ror dl,1                ;only one byte
	mov al,dl        
	dec al                    
	or al,dl
	mov bl,10000000b           
	sub bl,bh
	or bl,10000000b
	and al,bl
	jmp Donehline                                                
TwoOrMoreBytes:                 ;two or more bytes
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
	cmp cx,1                ;if only two bytes, skip middle
	jz LastByte     
Byteloop:                       ;draw all full bytes     
	dec cx                  ;first byte stored         
	mov ax,0ffffh             
	test di,1
	jz NoOddByte
	stosb                   ;store odd leading byte 
	dec cx
NoOddByte:             
	shr cx,1
	rep stosw               ;store all except last byte      
	adc cx,0                ;store last odd full byte
	rep stosb                        
	mov bl,bh
	xor al,al                                                           
LastByte:                         
	or al,bl
	rol bl,1 
	jc Donehline       
	jmp lastbyte                                                                                    
		     
Donehline:
	mov ah,es:[di]
	stosb
	jmp getcoords

Donehlinelist:	
	pop es
	pop ds
	popa
	ret
		
Fpoly endp
code ends
end 
		     
			    
	






								 
