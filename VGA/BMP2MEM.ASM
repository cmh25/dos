; --------------------------------------------------------------
;			bmp2mem.asm 
;			  5-20-98
;                                
; stores a 16-color Win95 bitmap in memory 
; using write mode1
;
; caller must pass:
;		bmp_offset:word - the offset address of the 
;				   path string
;		plane0_offset:word - the offset address of 
;				     memory buffer to store
;				     plane0
;		plane1_offset:word -
;		plane2_offset:word -
;		plane3_offset:word -
;
; --------------------------------------------------------------   

.model large,c

.486

;***********************
; DATA SEGMENT
;***********************
data segment word public 'DATA'  
			      
  handle                word ?
  buffer                byte 500 dup (0)
  width_in_pixels       word ?
  height_in_pixels      word ?
  image_begin           word ?
  blue_val              word ?
  green_val             word ?
  red_val               word ?
  intensity_val         word ?
  shift_count           byte ?
  pix_count             word 0
  row_count             word 0 
  row_adjust            word ?  
  next_row              word ?
  row_read_length       word ?     

data ends
;***********************
; CODE SEGMENT
;***********************
code segment word public 'CODE'
	assume cs:code,ds:data 

Bmp2mem proc far c public, bmp_offset:word,plane0_offset:word,
			  plane1_offset:word,plane2_offset:word,
			  plane3_offset:word    
  
  pusha
  push ds
  push es	
  mov ax,data
  mov ds,ax

  mov ax,3d00h		   ; open file and get handle		  
  mov dx,bmp_offset        ; offset of path string
  int 21h                  
  mov handle,ax              
  
  mov ah,3fh               ; load 500 bytes of file 
  mov bx,handle            ; into buffer to get 
  mov cx,500               ; header info
  mov dx,offset buffer     
  int 21h                  
  
;************************************
; get header info
;************************************     
 
  mov si,offset buffer	  ; ds:si points to width in pixels 
  add si,18							  
  
  mov ax,ds:[si]           ; this is to calculate end of row
  mov width_in_pixels,ax                                   
	   
  add si,4		   ; ds:si points to height in pixels						   
  
  mov ax,ds:[si]           ; this is to calculate end of image
  mov height_in_pixels,ax          
  
;*************************
; set up row_adjust  and row_read_length
;*************************   
  
  mov dx,0
  mov ax,width_in_pixels    ; setup row_read_length     
  mov bx,2                                  
  div bx                     
  .if dx != 0
    add ax,1
  .endif      
  mov row_read_length,ax
  mov dx,0
  mov bx,4
  div bx                        
  
  .if dx != 0               
    mov ax,4               ; adjust for four byte pad
    sub ax,dx              
  .elseif                     
    mov ax,0                
  .endif                                
  add row_read_length,ax                               
  
  mov si,offset buffer	  ; ds:si points to image begin
  add si,10			  
  
  mov ax,4200h		    ; file pointer to image begin
  mov bx,handle 	    ; offset  
  mov cx,0                 
  mov dx,ds:[si]                  
  int 21h                  
  
;*************************
; get image and store in memory
;*************************     

  mov si,offset buffer		 ; setup ds:si and		       
  mov ax,ds			 ; es				
  mov es,ax			  		  
  
  mov ax,height_in_pixels	   
			
  .while row_count < ax
    push ax 
      
    mov ax,di			    ; setup next row
    sub ax,80			    
    mov next_row,ax		      
    
    mov ah,3fh			; load row 
    mov bx,handle		; into buffer
    mov cx,row_read_length			   
    mov dx,offset buffer	
    int 21h			 
	 
    mov bx,width_in_pixels
    mov shift_count,6		 
							
     .while pix_count < bx				
       push bx						
							
       ;******************				
       ; get blue plane 				
       ;******************				
							
       mov ax,ds:[si]									
       and ax,68					
       .if ax == 68		    ; both		
	 mov bx,3					
	 mov cl,shift_count				
	 shl bx,cl					
	 or blue_val,bx				
       .endif						
       .if ax == 64		    ; high bit		
	 mov bx,2					
	 mov cl,shift_count				
	 shl bx,cl					
	 or blue_val,bx				
       .endif						
       .if ax == 4		    ; low bit		
	 mov bx,1					
	 mov cl,shift_count				
	 shl bx,cl					
	 or blue_val,bx				
       .endif			    ; get blue_val	
							
       ;******************				
       ; get green plane				
       ;******************				
							
       mov ax,ds:[si]								
       and ax,34					
       .if ax == 34		    ; both		
	 mov bx,3					
	 mov cl,shift_count				
	 shl bx,cl					
	 or green_val,bx				
       .endif						
       .if ax == 32		    ; high bit		
	 mov bx,2					
	 mov cl,shift_count				
	 shl bx,cl					
	 or green_val,bx				
       .endif						
       .if ax == 2		    ; low bit		
	 mov bx,1							
	 mov cl,shift_count						
	 shl bx,cl							
	 or green_val,bx				
       .endif			    ; get green_val		
							
       ;******************						
       ; get red plane					
       ;******************				
							
       mov ax,ds:[si]								
       and ax,17					
       .if ax == 17					
	 mov bx,3					
	 mov cl,shift_count				
	 shl bx,cl					
	 or red_val,bx				
       .endif						
       .if ax == 16					
	 mov bx,2					
	 mov cl,shift_count				
	 shl bx,cl					
	 or red_val,bx				
       .endif						
       .if ax == 1					
	 mov bx,1					
	 mov cl,shift_count				
	 shl bx,cl					
	 or red_val,bx				
       .endif			    ; get red_val	
							
       ;******************				
       ; get intensity plane				
       ;******************   
								 
       mov ax,ds:[si]							
       and ax,136					
       .if ax == 136					
	 mov bx,3					
	 mov cl,shift_count				
	 shl bx,cl					
	 or intensity_val,bx				
       .endif						
       .if ax == 128					
	 mov bx,2					
	 mov cl,shift_count				
	 shl bx,cl					
	 or intensity_val,bx				
       .endif						
       .if ax == 8					
	 mov bx,1					
	 mov cl,shift_count				
	 shl bx,cl					
	 or intensity_val,bx				
       .endif				 ; get intensity val
							
       inc si						
							
       add pix_count,2					
							
       pop bx						
							
       .if pix_count >= bx	    ; then end of row	
	 jmp Store_Byte
Back:				
       .elseif shift_count == 0     ; if we're at the end             
	 jmp Store_Byte 	    ; of a byte, store it     
Back2:								
	 mov shift_count,8					
       .endif			    				
								
       sub shift_count,2					
								
     .endw	   
     mov pix_count,0		  ; reset pix_count    
     
     mov si,offset buffer	  ; reset si   
     
     inc row_count		
	  
     pop ax		     
  .endw 	   
  mov row_count,9		 ; reset row_count	
  
  mov ax,3e00h		   ; close file
  mov bx,handle 	   
  int 21h    
  pop es
  pop ds
  popa		   
  
  ret				      
;************************************************
; this process stores the bytes one plane at a time
;************************************************
Store_Byte:	
 
  mov di,plane0_offset	       ; plane0
  mov ax,blue_val
  stosb 
  mov plane0_offset,di 
				
  mov di,plane1_offset	       ; plane1
  mov ax,green_val
  stosb 
  mov plane1_offset,di	
			      			 
  mov di,plane2_offset		; plane2 
  mov ax,red_val
  stosb 
  mov plane2_offset,di	
  				 
  mov di,plane3_offset		; plane3
  mov ax,intensity_val
  stosb 
  mov plane3_offset,di	
	       
  mov blue_val,0	       
  mov green_val,0	      
  mov red_val,0	      
  mov intensity_val,0  
  .if shift_count == 0
    jmp back2
  .endif
  jmp back                            
	 
bmp2mem endp
code ends 
end 
