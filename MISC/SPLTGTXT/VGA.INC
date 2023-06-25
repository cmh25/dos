;---------------------------------------------------------------
;                         vga.inc 
;                         5-14-98  
;
;Vga macro definitions and prototypes
;       
; --------------------------------------------------------------

;*********************************
; PROTOTYPES
;*********************************
bmp2vga PROTO c :word,:word
setstartaddr PROTO c :word
setsplitscreen PROTO c :word
							 
;*********************************
; MACROS
;*********************************
mSetMapMask macro map_mask
	push ax
	push dx
	mov dx,3c4h
	mov al,2
	mov ah,map_mask
	out dx,ax 
	pop dx
	pop ax
	endm
	
mSetBitMask macro bit_mask
	push ax
	push dx
	mov dx,3ceh
	mov al,8 
	mov ah,bit_mask     
	out dx,ax
	pop dx
	pop ax 
	endm
	
mSetWriteMode macro write_mode
	push ax
	push dx
	mov dx,3ceh
	mov al,5
	out dx,al
	inc dx
	in al,dx
	and al,not 3
	or al,write_mode  
	out dx,al	 
	pop dx
	pop ax
	endm
	
mSetReadMode macro read_mode
	push ax
	push bx
	push dx
	mov dx,3ceh
	mov al,5
	out dx,al
	inc dx     
	in al,dx
	and al,not 8
	mov bl,(read_mode shl 3)
	or al,bl
	out dx,al  
	pop dx
	pop bx
	pop ax
	endm 
	
mSetALU macro function
	push ax
	push dx
	mov dx,3ceh
	mov al,3
	mov ah,function
	out dx,ax  
	pop dx
	pop ax
	endm
	
mEnableSR	macro selection
	push ax
	push dx
	mov dx,3ceh
	mov al,1
	mov ah,selection
	out dx,ax	 
	pop dx
	pop ax
	endm
	
mSetSR macro selection
	push ax
	push dx
	mov dx,3ceh
	mov al,0
	mov ah,selection
	out dx,ax     
	pop dx
	pop ax
	endm    
	
mSetColorCompare macro selection
	push ax
	push dx
	mov dx,3ceh
	mov al,2
	mov ah,selection
	out dx,ax   
	pop dx
	pop ax
	endm
	
mSetColorDontCare macro selection
	push ax
	push dx
	mov dx,3ceh
	mov al,7
	mov ah,selection
	out dx,ax   
	pop dx
	pop ax
	endm
	
mSetReadMap macro selection
	push ax
	push dx
	mov dx,3ceh
	mov al,4
	out dx,al
	inc dx
	in al,dx
	and al,not 3
	or al,selection
	out dx,al   
	pop dx
	pop ax
	endm
	      