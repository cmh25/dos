; --------------------------------------------------------------
;			Grapher.asm
;			  4-28-98
;                     By: Charlie Hall
;                  Assembled on masm 6.11
; --------------------------------------------------------------

.model small

.486 
  
  include string.inc 

.stack 

.data 
   
  rstack real4 500 dup (?)	; home made real4 stack
  rstackp word ?		; stack pointer for homemade 
				; real4 stack  
  buffer byte 300 dup (?)	; memory location to
				; store string	      
  xvalb real4 ?			; initial xval
  cxval real4 -32.0		; never changes
  _xval real4 ?			; only gets incremented	       
  xval sword ?			; xval rounded integer
  yval sdword ?			; initial yval
  yvalword sword ?		; for final plotting
  expr real4 ?			; evaluated expression
  expr_to_power real4 ?         ; base for exponents
  num real4 ?			; number 
  num_to_power real4 ?		; base for exponents
  mulval real4 1.0		; for multiplying the first
				; number by 1
  mulvalten real4 10.0		; for multiplying a number
				; by 10 when
				; another number is found  
  current byte ?		; current character
  currentword word ?		; for transfer to co-processor		      
  fract real4 ?			; decimal value   
  fractb real4 ?		; base decimal value to add 
				; to fract 
  fractvalb real4 0.1		; this always stays = 0.1
  fractval real4 0.1		; for multiplying a number by
				; a fraction
				; to add to fract
  fractvalmul real4 0.1		; mul * fractval to decrease
  power real4 ?			; power to be raised to  
  powerint sdword ?		; power in int form
  timesv real4 ?		; number to be multiplied by;  
  divv real4 ?			; number to be divided by
  term real4 ?			; value of the term  
  hexcorrect real4 48.0		; sub from 30h-39h to get 0-9 
  zout real4 0.0		; to set a real4 variable to 0
  incval real4 0.001		; inc for xvalb and _xval
  ten byte 10			; just 10
  tenr real4 10.0		; just 10

.code
  
.startup
						  
Main proc
		
Begin:				      
 
  lea ax,rstack			; setup homemade
  mov rstackp,ax		; real4 stack
  
  fld cxval			;
  fst _xval			; reset x values to -32.0
  fstp xvalb			;
						
  mov ax,0003h			; clear page
  int 10h			;				   
		  
  mGetstring buffer		; get string	 
  mEatspaces buffer		; and remove spaces
  
  lea ax,buffer 		 ;
  mov bp,ax			 ;
  mov al,[bp]			 ; check for quit
  .if al == 'q' || al == 'Q'	 ;
    jmp quit			 ;
  .endif			 ;
 
  call setup
    
  fld _xval	    ;
  fmul tenr	    ; multiply by ten for scale	
  fistp xval	    ;

Plotloop: 
		 
  call getexpr	
  
  fld expr
  fmul tenr	     ; multiply by ten for scale
  fistp yval			
      
;***********
; PLOT
;***********  
  .if (xval >= -320) && (xval <= 319)
    .if (yval >= -240) && (yval <= 240)	
      
      mov ax,xval	   ;
      add ax,320	   ; get x
      mov cx,ax		   ;
		       
      fild yval		   ;
      fistp yvalword	   ;
      mov ax,240	   ; get y
      sub ax,yvalword	   ;
      mov dx,ax		   ;
    
      mov ax,0c05h	   ;
      int 10h		   ; plot point
    .endif		   ;
  .endif
.if xval <= 319		   ; repeat if not too big for screen
  
  lea ax,buffer 		; ds:bp points to inbuffer
  mov bp,ax			; 
 
  mov al,[bp]			; current contains current 
  mov current,al		; character
  cbw				;
  mov currentword,ax		;
  
  fld _xval			;
  fadd incval			; increment x values
  fst xvalb			;
  fst _xval			;
  fmul tenr			; multiply by ten for scale	
  fistp xval			;

  jmp plotloop
.endif 
     
  mov ax,0700h		   ; wait for key to proceed
  int 21h		   ; 
  
  jmp begin		   ; start all over
  
Quit:
  mov ax,0003h		   ;
  int 10h		   ; exit routine
  mov ax,4c00h		   ;
  int 21h		   ;
	 
   
main endp 
	  
; **************************************************************
; procedure section
; **************************************************************

; --------------------------------------------------------------
;  getexpr
; --------------------------------------------------------------

getexpr proc
   
 fld zout
 fstp expr 
 
 Loopexpr:	
  ; ------------------------------
  ; if current = '0'-'9' or 'x' or '.'
  ; ------------------------------
  .if ((al>='0')&&(al<='9'))||((al=='x')||(al=='X'))||(al=='.') 
    mPush4 num,rstack,rstackp
    mPush4 mulval,rstack,rstackp	;
    call getnum 			; all fraction action
    fld num				; goes through getnum
    fstp expr				;
    mPop4 mulval,rstack,rstackp
    mPop4 num,rstack,rstackp
    jmp loopexpr
  .endif 
  
  ; ------------------------------
  ; if current = '*'
  ; ------------------------------

  .if al == '*'
    mCurrent_eq_next 
    mPush4 timesv,rstack,rstackp
    call gettimes
    fld expr
    fmul timesv
    fstp expr
    mPop4 timesv,rstack,rstackp
    jmp loopexpr
  .endif
  
  ; ------------------------------
  ; if current = '/'
  ; ------------------------------
  
  .if al == '/'
    mCurrent_eq_next
    mPush4 divv,rstack,rstackp
    call getdiv
    fld expr
    fdiv divv
    fstp expr
    mPop4 divv,rstack,rstackp
    jmp loopexpr
  .endif
  
  ; ------------------------------
  ; if current = '+'
  ; ------------------------------
  
  .if al == '+'
    mCurrent_eq_next
    mPush4 term,rstack,rstackp
    call getterm
    fld expr
    fadd term
    fstp expr
    mPop4 term,rstack,rstackp
    jmp loopexpr
  .endif
  
  ; ------------------------------
  ; if current = '-'
  ; ------------------------------
  
  .if al == '-'
    mCurrent_eq_next
    mPush4 term,rstack,rstackp
    call getterm
    fld expr
    fsub term
    fstp expr
    mPop4 term,rstack,rstackp
    jmp loopexpr
  .endif
  
  ; ------------------------------
  ; if current = '(' or '['
  ; ------------------------------
  
  .if (al == '(')||(al == '[')
    mCurrent_eq_next 
    call getexpr	      
    jmp loopexpr
  .endif
  
  ; ------------------------------
  ; if current = ')' or ']'
  ; ------------------------------
  
  .if (al == ')')||(al == ']')
    mCurrent_eq_next  
    .if al == '^'
      mCurrent_eq_next
      mPush4 power,rstack,rstackp
      call getpower         
      fld power		     ;
      fistp powerint	     ; sub 1 from power
      sub powerint,1
      fld expr
      fstp expr_to_power	     
      .while powerint > 0
        fld expr
        fmul expr_to_power
        fstp expr
        sub powerint,1
      .endw      
      mPop4 power,rstack,rstackp
      ret
    .endif    
   ret	    
  .endif 
  
ret

getexpr endp						    

; --------------------------------------------------------------
; getnum
; -------------------------------------------------------------- 

getnum proc 

 fld1		 ;  mulval = 1.0
 fstp mulval	 ;
 
 fld zout	 ; set num = 0
 fstp num	 ;
 
 Loopnum: 
  
  ; ------------------------------
  ; if current = '0'-'9' 
  ; ------------------------------
  
  .if (al >= '0')&&(al <= '9')	
    fld num			;
    fmul mulval			; num * mulval
    fstp num			;
   
    fld mulvalten		; mulval = 10.0
    fstp mulval			; 
   
    fild currentword		; hex correct
    fsub hexcorrect		;
    fadd num
    fstp num	
    mCurrent_eq_next
    jmp loopnum
  .endif 
  
  ; ------------------------------
  ; if current = '.'
  ; ------------------------------ 
    
  .if al == '.'
    mCurrent_eq_next	      
    mPush4 fract,rstack,rstackp
    mPush4 fractval,rstack,rstackp
    call getfract
    fld fract
    fadd num
    fstp num
    fstp fract 
    mPop4 fractval,rstack,rstackp
    mPop4 fract,rstack,rstackp
    jmp loopnum
  .endif

  ; ------------------------------
  ; if current = 'x'	
  ; ------------------------------ 
  
  .if (al == 'x')||(al == 'X')
    mCurrent_eq_next 
    .if al == 5eh
      mPush4 power,rstack,rstackp
      mCurrent_eq_next
      call getpower
      fld power		     ;
      fistp powerint	     ; sub 1 from power
      sub powerint,1	     ;
      fld xvalb
      .while powerint > 0    ;
	fmul _xval	     ; x to the power
	sub powerint,1	     ;
      .endw		      
      fstp xvalb
      mPop4 power,rstack,rstackp	
    .endif
  fld num		   ;
  fmul xvalb		   ; multiply num by x
  fstp num		   ;
   
  fld _xval		   ; reset xvalb after exponent
  fstp xvalb		   ;   
  
  jmp loopnum		   ;  
  ret			   ;
  .endif		   ;
	
  ; ------------------------------
  ; if current = '^'
  ; ------------------------------  
  
  .if al == '^'
    mCurrent_eq_next
    mPush4 power,rstack,rstackp	
    call getpower  
    fld power		     ;
    fistp powerint	     ; sub 1 from power
    sub powerint,1
    fld num
    fstp num_to_power
    fld num	     
    .while powerint > 0
      fmul num_to_power 
      sub powerint,1
    .endw  
    fstp num
    mPop4 power,rstack,rstackp
    ret	
  .endif	
ret	
getnum endp			   

; --------------------------------------------------------------
; getfract
; --------------------------------------------------------------
  
getfract proc 

 fld zout
 fstp fract
 
 fld fractvalb
 fstp fractval
 
 Loopfract: 
  
  ; ------------------------------
  ; if current = '0'-'9'
  ; ------------------------------
  
  .if (al >= '0')&&(al <= '9')
   
    fild currentword		; hex correct
    fsub hexcorrect		;
    fmul fractval		; currentword * fractval
    fstp fractb			;
   
    fld fractval		;
    fmul fractvalmul		; .1 to .01 to .001 etc.
    fstp fractval		;			     
  
    fld fract			;
    fadd fractb			; add fractb to fract
    fstp fract			;
    
    mCurrent_eq_next
    jmp loopfract
  .endif
ret
getfract endp 

; --------------------------------------------------------------
; gettimes
; --------------------------------------------------------------

gettimes proc
 
 fld zout
 fstp timesv
 
 Looptimes: 
  
  ; ------------------------------
  ; if current = '0'-'9' or 'x' or '.'
  ; ------------------------------   
  
  .if ((al>='0')&&(al<='9')||(al=='x')&&(al=='X'))||(al=='.')
    mPush4 num,rstack,rstackp
    mPush4 mulval,rstack,rstackp
    call getnum
    fld num
    fstp timesv
    mPop4 mulval,rstack,rstackp
    mPop4 num,rstack,rstackp
    jmp looptimes
  .endif
  
  ; ------------------------------
  ; if current = '(' or '['
  ; ------------------------------
  
  .if (al == '(')||(al == '[') 
    mCurrent_eq_next
    mPush4 expr,rstack,rstackp
    call getexpr
    fld expr
    fstp timesv
    mPop4 expr,rstack,rstackp
    ret
  .endif  
    
ret
gettimes endp
	
; --------------------------------------------------------------
; getdiv
; --------------------------------------------------------------

getdiv proc
 
 fld zout
 fstp divv
 
 Loopdiv: 
   
  ; ------------------------------
  ; if current = '0'-'9' or 'x' or '.'
  ; ------------------------------

  .if ((al>='0')&&(al<='9')||(al=='x')||(al=='X'))||(al=='.')
    mPush4 num,rstack,rstackp
    mPush4 mulval,rstack,rstackp
    call getnum
    fld num
    fstp divv
    mPop4 mulval,rstack,rstackp
    mPop4 num,rstack,rstackp
    ret
  .endif

  ; ------------------------------
  ; if current = '(' or '['
  ; ------------------------------

  .if (al == '(') || (al == '[') 
    mCurrent_eq_next
    mPush4 expr,rstack,rstackp
    call getexpr
    fld expr
    fstp divv
    mPop4 expr,rstack,rstackp
    ret
  .endif
  
ret
getdiv endp 

; --------------------------------------------------------------
; getterm
; --------------------------------------------------------------

getterm proc
 
 fld zout
 fstp term
 
 Loopterm: 
  
  ; ------------------------------
  ; if current = '0'-'9' or 'x' or '.'
  ; ------------------------------  
  
  .if ((al>='0')&&(al<='9'))||((al=='x')||(al=='X')||(al=='.'))
    mPush4 num,rstack,rstackp
    mPush4 mulval,rstack,rstackp
    call getnum
    fld num
    fstp term
    mPop4 mulval,rstack,rstackp
    mPop4 num,rstack,rstackp
    jmp loopterm
  .endif	 
  
  ; ------------------------------
  ; if current = '(' or '['
  ; ------------------------------
   
  .if (al == '(') || (al == '[')
    mCurrent_eq_next
    mPush4 expr,rstack,rstackp
    call getexpr
    fld expr
    fstp term
    mPop4 expr,rstack,rstackp
    jmp loopterm
  .endif 

  ; ------------------------------
  ; if current = '*'
  ; ------------------------------

  .if al == '*'
    mCurrent_eq_next
    mPush4 timesv,rstack,rstackp
    call gettimes
    fld term
    fmul timesv
    fstp term
    mPop4 timesv,rstack,rstackp 
    jmp loopterm
  .endif

  ; ------------------------------
  ; if current = '/'
  ; ------------------------------
  
  .if al == '/'
    mCurrent_eq_next
    mPush4 divv,rstack,rstackp
    call getdiv
    fld term
    fdiv divv
    fstp term
    mPop4 divv,rstack,rstackp
    jmp loopterm
  .endif

ret
getterm endp		       

; --------------------------------------------------------------
; getpower
; --------------------------------------------------------------

getpower proc 
 
 fld zout
 fstp power
 
 Looppower:  
  
  ; ------------------------------
  ; if current = '0'-'9' or 'x'
  ; ------------------------------ 
  
  .if ((al>='0')&&(al<='9')||(al=='x')||(al=='X'))
    mPush4 num,rstack,rstackp
    mPush4 mulval,rstack,rstackp
    call getnum
    fld num
    fstp power
    mPop4 mulval,rstack,rstackp
    mPop4 num,rstack,rstackp
    ret
  .endif
	
  ; ------------------------------
  ; if current = '(' or '['
  ; ------------------------------   
  
  .if (al == '(')||(al == '[')
    mCurrent_eq_next
    mPush4 expr,rstack,rstackp
    call getexpr
    fld expr
    fstp power
    mPop4 expr,rstack,rstackp
  .endif		    
ret
getpower endp

; --------------------------------------------------------------
; setup
; -------------------------------------------------------------- 

setup proc
 
; --------------------------------
; grid
; -------------------------------- 
  
  mov ax,0012h	      ; change to mode 12	  
  int 10h	      ; 			  
						   
  mov bx,0
  mov cx,10
  mov dx,10	 
  .while cx < 640	   ;
    .while dx < 480	   ; grid 
      mov ax,0c06h	   ;
      int 10h		   ;
      add dx,10		   ;
    .endw		   ;
    mov dx,10		   ;
    add cx,10		   ;
  .endw 		   ;
   
  mov bx,0
  mov cx,320		     ;
  mov dx,0		     ; plot vertical line
  .while dx < 480	     ;
    mov ax,0c01h 
    int 10h		     ;
    add dx,1		     ;
  .endw			     ;
   
  mov bx,0			     
  mov cx,0		     ; 
  mov dx,240		     ;	
  .while cx < 640	     ; plot horizontal 
    mov ax,0c01h	     ; line
    int 10h		     ; 
    add cx,1		     ;
  .endw 		     ;			
	 
  mov ax,0700h		     ; wait for key 
  int 21h		     ; to proceed  

  lea ax,buffer 	     ; ds:bp points to buffer		    
  mov bp,ax		     ;					
								    
  mov al,[bp]		     ;	      
  mov current,al	     ; current contains current 			    
  cbw			     ; character					    
  mov currentword,ax	     ;
					    
  ret 
										    
setup endp

end
