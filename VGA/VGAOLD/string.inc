;0602:0024 B80002         MOV       AX,0200  
;0602:0027 B20A           MOV       DL,0A  
;0602:0029 CD21           INT       21  
;0602:002B B20D           MOV       DL,0D  
;0602:002D CD21           INT       21  
;0602:002F 8D1E0400       LEA       BX,WORD PTR [0004]  
;0602:0033 BA0000         MOV       DX,0000  
;0602:0036 EB08           JMP       0040  
;0602:0038 8A17           MOV       DL,BYTE PTR [BX]  
;0602:003A B80002         MOV       AX,0200  
;0602:003D CD21           INT       21  
;0602:003F 43             INC       BX  
;0602:0040 80FA0D         CMP       DL,0D  
;0602:0043 75F3           JNZ       0038 

mOutstring macro buffer
  MOV       AX,0200h  
  MOV       DL,0Ah  
  INT       21h  
  MOV       DL,0Dh  
  INT       21h  
  LEA       BX,buffer
  MOV       DX,0
  JMP       done
loop0:  
  MOV       DL,BYTE PTR [BX]  
  MOV       AX,0200h  
  INT       21h  
  INC       BX  
 done: 
  CMP       DL,0Dh 
  JNZ       loop0
  endm

;0602:0028 B80002         MOV       AX,0200  
;0602:002B B20A           MOV       DL,0A  
;0602:002D CD21           INT       21  
;0602:002F B20D           MOV       DL,0D  
;0602:0031 CD21           INT       21  
;0602:0033 8CD8           MOV       AX,DS  
;0602:0035 8EC0           MOV       ES,AX  
;0602:0037 8D06D607       LEA       AX,WORD PTR [07D6]  
;0602:003B 8BF8           MOV       DI,AX  
;0602:003D B0FF           MOV       AL,FF  
;0602:003F AA             STOSB       
;0602:0040 8D06D607       LEA       AX,WORD PTR [07D6]  
;0602:0044 8BD0           MOV       DX,AX  
;0602:0046 B8000A         MOV       AX,0A00  
;0602:0049 CD21           INT       21  
;0602:004B 8CD8           MOV       AX,DS  
;0602:004D 8EC0           MOV       ES,AX  
;0602:004F 8D06D607       LEA       AX,WORD PTR [07D6]  
;0602:0053 8BF8           MOV       DI,AX  
;0602:0055 83C002         ADD       AX,02  
;0602:0058 8BF0           MOV       SI,AX  
;0602:005A 8A04           MOV       AL,BYTE PTR [SI]  
;0602:005C EB0A           JMP       0068  
;0602:005E 3C20           CMP       AL,20  
;0602:0060 7503           JNZ       0065  
;0602:0062 46             INC       SI  
;0602:0063 EB01           JMP       0066  
;0602:0065 A4             MOVSB       
;0602:0066 8A04           MOV       AL,BYTE PTR [SI]  
;0602:0068 3C0D           CMP       AL,0D  
;0602:006A 75F2           JNZ       005E  
;0602:006C A4             MOVSB       

mGetstring macro buffer
MOV       AX,0200h
MOV       DL,0Ah 
INT       21h 
MOV       DL,0Dh 
INT       21h 
MOV       AX,DS  
MOV       ES,AX  
LEA       AX,buffer
MOV       DI,AX  
MOV       AL,0FFh  
STOSB       
LEA       AX,buffer
MOV       DX,AX  
MOV       AX,0A00h  
INT       21h  
endm

mEatspaces macro buffer
  MOV       AX,DS  
  MOV       ES,AX  
  LEA       AX,buffer
  MOV       DI,AX  
  ADD       AX,02h  
  MOV       SI,AX  
  MOV       AL,BYTE PTR [SI]  
  JMP       b0
loop0:
  CMP       AL,20h  
  JNZ       b1
  INC       SI  
  JMP       b2
b1:
  MOVSB       
b2:
  MOV       AL,BYTE PTR [SI]  
b0:
  CMP       AL,0Dh  
  JNZ       loop0
  MOVSB       
endm

mPush4 macro val,stack,stackp
  PUSHA       
  PUSHF       
  MOV       AX,DS  
  MOV       ES,AX  
  MOV       AX,word ptr [stackp]
  MOV       DI,AX  
  LEA       AX,word ptr [val]
  MOV       SI,AX  
  MOV       CX,0004h 
  CLD         
  REP MOVSB   
  ADD       word ptr [stackp],04h  
  POPF        
  POPA 
endm

mPop4 macro val,stack,stackp
  PUSHA       
  PUSHF       
  SUB       word ptr [stackp],04h 
  MOV       AX,DS  
  MOV       ES,AX  
  LEA       AX,word ptr [val]
  MOV       DI,AX  
  MOV       AX,word ptr [stackp]
  MOV       SI,AX  
  MOV       CX,0004h 
  CLD         
  REP MOVSB   
  POPF        
  POPA 
endm

mCurrent_eq_next macro
  INC       BP  
  MOV       AL,BYTE PTR [BP]  
  MOV       BYTE PTR [current],AL  
  CBW         
  MOV       WORD PTR [currentword],AX
endm