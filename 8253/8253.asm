; --------------------------------------------------------------
;			 8253.asm
;			  5-9-98
;
;Sound proc far c public,freq:word
;Delay proc far c public,del:word
;NoSound proc far c
;	
; -------------------------------------------------------------- 

.model large,c

.486

;***********************
; CODE SEGMENT
;***********************
code segment word public 'CODE'

Sound proc far c public,freq:word
	;
	;initialize channel 2 of timer chip
	;
	mov al,0b6h
	out 43h,al
	;
	;calculate frequency
	;
	mov dx,12h
	mov ax,34deh
	div freq
	;
	;set frequency
	;
	out 42h,al
	mov al,ah
	out 42h,al
	;
	;turn speaker on
	;
	in al,61h
	or al,3
	out 61h,al

	ret
Sound endp

Delay proc far c public,del:word

       local starttime:dword,time:dword,deltime:word

       push es
       push ds
       ;
       ;setup es:di and ds:si
       ;
       mov ax,ss
       mov es,ax
       mov ax,0040h
       mov ds,ax
       mov si,006ch
       lea di,starttime

       ;
       ;get start time
       ;
       mov cx,4
       rep movsb

       ;
       ;delay loop
       ;
DelayLoop:
       ;
       ;get time
       ;
       mov si,006ch
       lea di,time
       mov cx,4
       rep movsb

       ;
       ;subtract start time from time
       ;
       fild time
       fisub starttime
       fistp deltime
       ;
       ;multiply deltime by 5 to make 1=approx 1/100 sec (5*18.2)
       ;
       mov ax,deltime
       mov bx,5
       mul bx
       mov deltime,ax

       ;
       ;compare to delay
       ;
       mov ax,del
       cmp ax,deltime
       jae DelayLoop

       pop ds
       pop es
       ret

Delay endp

NoSound proc far c public
	;
	;turn off speaker
	;
	in al,61h
	;xor al,3
	and al,11111100b
	out 61h,al

	ret
NoSound endp
code ends
end
