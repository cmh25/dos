; File z:\dosbox\progs\cmh01\cmh01.cpp
; Line 21
_main:
	push	bp
	mov	bp,sp
	mov	ax,OFFSET L00716
	call	FAR PTR __aFchkstk
	push	si
	push	di
; Line 22
	push	OFFSET 18
	call	FAR PTR _SetMode
	add	sp,OFFSET 2
; Line 23
	call	FAR PTR ?waitkey@@ZAXXZ
; Line 24
L00711:
	call	FAR PTR _kbhit
	cmp	ax,OFFSET 0
	jne	L00712
; Line 25
; Line 26
	add	WORD PTR ?color@@3FE,OFFSET 1
; Line 27
	call	FAR PTR _rand
	sar	ax,OFFSET 8
	mov	WORD PTR ?x1@@3FE,ax
; Line 28
	call	FAR PTR _rand
	sar	ax,OFFSET 8
	mov	WORD PTR ?y1@@3FE,ax
; Line 29
	call	FAR PTR _rand
	sar	ax,OFFSET 8
	mov	WORD PTR ?x2@@3FE,ax
; Line 30
	call	FAR PTR _rand
	sar	ax,OFFSET 8
	mov	WORD PTR ?y2@@3FE,ax
; Line 31
	call	FAR PTR _rand
	sar	ax,OFFSET 8
	mov	WORD PTR ?x3@@3FE,ax
; Line 32
	call	FAR PTR _rand
	sar	ax,OFFSET 8
	mov	WORD PTR ?y3@@3FE,ax
; Line 33
	mov	ax,WORD PTR ?x1@@3FE
	shl	ax,OFFSET 1
	shl	ax,OFFSET 1
	mov	WORD PTR ?x1@@3FE,ax
; Line 34
	_imul3 	ax,WORD PTR ?y1@@3FE,OFFSET 3
	mov	WORD PTR ?y1@@3FE,ax
; Line 35
	mov	ax,WORD PTR ?x2@@3FE
	shl	ax,OFFSET 1
	shl	ax,OFFSET 1
	mov	WORD PTR ?x2@@3FE,ax
; Line 36
	_imul3 	ax,WORD PTR ?y2@@3FE,OFFSET 3
	mov	WORD PTR ?y2@@3FE,ax
; Line 37
	mov	ax,WORD PTR ?x3@@3FE
	shl	ax,OFFSET 1
	shl	ax,OFFSET 1
	mov	WORD PTR ?x3@@3FE,ax
; Line 38
	_imul3 	ax,WORD PTR ?y3@@3FE,OFFSET 3
	mov	WORD PTR ?y3@@3FE,ax
; Line 39
	push	WORD PTR ?y3@@3FE
	push	WORD PTR ?x3@@3FE
	push	WORD PTR ?y2@@3FE
	push	WORD PTR ?x2@@3FE
	push	WORD PTR ?y1@@3FE
	push	WORD PTR ?x1@@3FE
	push	WORD PTR ?plinelist@@3PEFE+2
	push	WORD PTR ?plinelist@@3PEFE
	push	OFFSET 3
	push	WORD PTR ?color@@3FE
	call	FAR PTR _Fpoly
	add	sp,OFFSET 20
; Line 40
; Line 40
	jmp	L00711
L00712:
; Line 41
	call	FAR PTR ?waitkey@@ZAXXZ
; Line 42
	push	OFFSET 3
	call	FAR PTR _SetMode
	add	sp,OFFSET 2
; Line 43
	mov	ax,OFFSET 0
	jmp	L00709
; Line 44
; Line 44
L00709:
	pop	di
	pop	si
	leave
	ret	OFFSET 0
; Line 47
?waitkey@@ZAXXZ:
	push	bp
	mov	bp,sp
	mov	ax,OFFSET L00718
	call	FAR PTR __aFchkstk
	push	si
	push	di
; Line 48
	mov	ah,OFFSET 0
; Line 49
	int	OFFSET 22
; Line 50
	jmp	L00715
; Line 50
L00715:
	pop	di
	pop	si
	leave
	ret	OFFSET 0
