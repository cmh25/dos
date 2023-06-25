; --------------------------------------------------------------
;			ballmov6.asm 
;			  5-20-98   
;
; uses write mode0
; animated ball is byte alligned
;	
; -------------------------------------------------------------- 

.model large

.486		  

include vga.inc
includelib vga.lib

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

	border_path	db	"BORDER.BMP",0
	ball_path	db	"BALL.BMP",0 
	blank_path	db	"BLANK.BMP",0
	ball_plane0	db	50 dup (0) 
	ball_plane1	db	50 dup (0)
	ball_plane2	db	50 dup (0)
	ball_plane3	db	50 dup (0)
	blank_plane0	db	50 dup (0)
	blank_plane1	db	50 dup (0)
	blank_plane2	db	50 dup (0)
	blank_plane3	db	50 dup (0)
	ball_addr	word	?
	blank_addr	word	? 
	ballx_pos	word	50				    
	bally_pos	word	50 
	ghostx_pos	word	?
	ghosty_pos	word	?
	last_ballx_pos	word	?
	last_bally_pos	word	?
	page_num	word	0 
	x_inc		word	1
	y_inc		word	1


data ends
;***********************				

; CODE SEGMENT
;***********************
code segment word public 'CODE'    
	
	assume cs:code,ds:data	       

Start proc 
	mov ax,data
	mov ds,ax	       
			 
	mov ax,10h		    ; mode 10h
	int 10h		      
	   
	;
	; put border on page0
	;
	
	invoke bmp2vga,offset border_path,6d10h	
	 
	;
	; put border on page1
	;
	
	invoke bmp2vga,offset border_path,0db10h			     
	
	;
	; put ball in memory
	;
	
	invoke bmp2mem,offset ball_path,offset ball_plane0,
		offset ball_plane1,offset ball_plane2,
		offset ball_plane3	    
	
	;
	; put blank in memory
	;
	
	invoke bmp2mem,offset blank_path,offset blank_plane0,
		offset blank_plane1,offset blank_plane2,
		offset blank_plane3
	
	mov ax,0700h
	int 21h
	 
	call get_ball_addr  
	call get_next_xy
Animateloop:	 
	
	call get_next_xy  
	call get_blank_addr   
	call get_ball_addr			  
	call draw_blank	
	call draw_ball					
	invoke setstartaddr,0
	mov ax,1
	mov page_num,ax 
	call get_next_xy
	call get_blank_addr
	call get_ball_addr				   
	call draw_blank   
	call draw_ball			
	invoke setstartaddr,6e00h
	mov ax,0
	mov page_num,ax
	
	mov ax,0100h
	int 16h
	jz animateloop
	mov ax,0700h
	int 21h
	

	mov ax,0700h	    ; wait for key
	int 21h 	    ;
	
	mov ax,0003h	    ; mode 03h
	int 10h 	    ;
	
	mov ax,4c00h	    ; exit to dos
	int 21h 	    ;
		
start endp   

draw_ball proc 
	mov cx,4
Planeloop:
	.if cx == 4  
	  mov dx,3c4h
	  mov ax,0802h
	  out dx,ax
	  mov ax,offset ball_plane3
	
	.endif
	.if cx == 3 
	  mov dx,3c4h
	  mov ax,0402h
	  out dx,ax
	  mov ax,offset ball_plane2
	
	.endif
	.if cx == 2	
	  mov dx,3c4h
	  mov ax,0202h
	  out dx,ax
	  mov ax,offset ball_plane1
	
	.endif
	.if cx == 1  
	  mov dx,3c4h
	  mov ax,0102h
	  out dx,ax
	  mov ax,offset ball_plane0
	
	.endif
	push cx

	mov si,ax
	mov ax,0a000h
	mov es,ax     
	mov ax,page_num
	.if ax == 1
	  mov ax,28160
	.elseif
	  mov ax,0
	.endif
	add ax,ball_addr	     
	mov di,ax 
	mov cx,15
	movsw
Fillloop:     
	push cx
	sub di,82
	movsw
	pop cx
	dec cx
	jnz fillloop
	pop cx	
	dec cx
	jnz planeloop	
	
ret	
draw_ball endp	

draw_blank proc 

	mov cx,4
Planeloop:
	.if cx == 4  
	  mov dx,3c4h
	  mov ax,0802h
	  out dx,ax
	  mov ax,offset blank_plane3
	
	.endif
	.if cx == 3 
	  mov dx,3c4h
	  mov ax,0402h
	  out dx,ax
	  mov ax,offset blank_plane2
	
	.endif
	.if cx == 2	
	  mov dx,3c4h
	  mov ax,0202h
	  out dx,ax
	  mov ax,offset blank_plane1
	
	.endif
	.if cx == 1  
	  mov dx,3c4h
	  mov ax,0102h
	  out dx,ax
	  mov ax,offset blank_plane0
	
	.endif
	push cx

	mov si,ax
	mov ax,0a000h
	mov es,ax     
	mov ax,page_num
	.if ax == 1
	  mov ax,28160
	.elseif
	  mov ax,0
	.endif
	add ax,blank_addr	     
	mov di,ax 
	mov cx,15
	movsw
Fillloop:     
	push cx
	sub di,82
	movsw
	pop cx
	dec cx
	jnz fillloop
	pop cx	
	dec cx
	jnz planeloop	
	
ret	
  

draw_blank endp	  

get_next_xy proc	 
 
	mov ax,ghostx_pos 
	mov last_ballx_pos,ax  
	mov ax,ballx_pos
	mov ghostx_pos,ax
	mov ax,ghosty_pos
	mov last_bally_pos,ax
	mov ax,bally_pos
	mov ghosty_pos,ax

	.if (ballx_pos == 77)||(ballx_pos == 1)		   
	  mov ax,x_inc				      
	  mov bx,-1				    
	  imul bx				    
	  mov x_inc,ax				    
	.endif					    
	.if (bally_pos == 341)||(bally_pos == 23)	  
	  mov ax,y_inc				    
	  mov bx,-1				    
	  imul bx				    
	  mov y_inc,ax				    
	.endif					    
	
	fild ballx_pos		;
	fiadd x_inc		; increment x_pos
	fistp ballx_pos 	;
	
	fild bally_pos		;
	fiadd y_inc		; increment y_pos
	fistp bally_pos 	;
	
ret
get_next_xy	endp							

get_ball_addr proc  
		    
	mov ax,bally_pos
	mov bx,80 
	mul bx
	add ax,ballx_pos
	mov ball_addr,ax
	      
ret	
get_ball_addr endp			    

get_blank_addr proc
	
	mov ax,last_bally_pos
	mov bx,80 
	mul bx
	add ax,last_ballx_pos
	mov blank_addr,ax
	      
ret							
get_blank_addr endp															     

code ends 

end start



	 
		 
