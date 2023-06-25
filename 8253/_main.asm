.model large,c

.486 

include 8253.inc
includelib 8253.lib

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
data ends
;***********************
; CODE SEGMENT
;***********************
code segment word public 'CODE'
	assume cs:code,ds:data

Start proc    

	mov ax,data
	mov ds,ax
	
    ; do ra mi fa so la di do
    invoke Sound,262
    invoke Delay,10
    invoke Sound,294
    invoke Delay,10
    invoke Sound,330
    invoke Delay,10
    invoke Sound,349
    invoke Delay,10
    invoke Sound,392
    invoke Delay,10
    invoke Sound,440
    invoke Delay,10
    invoke Sound,494
    invoke Delay,10
    invoke Sound,523
    invoke Delay,10
    invoke NoSound
    invoke Delay,100
    ; some where over the rainbow
    invoke Sound,220
    invoke Delay,80
    invoke Sound,440
    invoke Delay,80
    invoke Sound,415
    invoke Delay,40
    invoke Sound,330
    invoke Delay,20
    invoke Sound,370
    invoke Delay,20
    invoke Sound,415
    invoke Delay,40
    invoke Sound,440
    invoke Delay,40
    ; way up high
    invoke Sound,220
    invoke Delay,80
    invoke Sound,370
    invoke Delay,80
    invoke Sound,330
    invoke Delay,160
    invoke NoSound
	
	mov ax,4c00h
	int 21h
		
start endp

code ends
end start