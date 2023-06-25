; File c:\msvc\projects\cell06\cell06.cpp
; Line 57
_main:
	push	bp
	mov	bp,sp
	mov	ax,OFFSET L03167
	call	FAR PTR __aFchkstk
	push	si
	push	di
; i = fffc
; Line 59
	push	OFFSET 19
	call	FAR PTR __setvideomode
	add	sp,OFFSET 2
; Line 62
	push	OFFSET 0
	push	OFFSET -32768
	mov	ax,OFFSET L03114
	mov	dx,ds
	push	dx
	push	ax
	call	FAR PTR __open
	add	sp,OFFSET 8
	mov	WORD PTR ?hand@@3HE,ax
; Line 63
	push	OFFSET 0
	push	OFFSET 0
	push	OFFSET 118
	push	WORD PTR ?hand@@3HE
	call	FAR PTR __lseek
	add	sp,OFFSET 8
; Line 64
	push	OFFSET 30400
	push	WORD PTR ?pFileBuffer@@3PEDE+2
	push	WORD PTR ?pFileBuffer@@3PEDE
	push	WORD PTR ?hand@@3HE
	call	FAR PTR __read
	add	sp,OFFSET 8
; Line 65
	push	WORD PTR ?hand@@3HE
	call	FAR PTR __close
	add	sp,OFFSET 2
; Line 68
	add	WORD PTR ?pFileBuffer@@3PEDE,OFFSET 30240
; Line 70
	mov	WORD PTR -4[bp],OFFSET 190
	jmp	L03119
L03116:
; Line 71
; j = fffa
; Line 72
	mov	WORD PTR -6[bp],OFFSET 160
	jmp	L03124
L03121:
; Line 73
; Line 74
	mov	bx,WORD PTR ?pFileBuffer@@3PEDE
	mov	es,WORD PTR ?pFileBuffer@@3PEDE+2
	add	WORD PTR ?pFileBuffer@@3PEDE,OFFSET 1
	mov	al,BYTE PTR es:[bx]
	mov	BYTE PTR ?abyte@@3DE,al
; Line 75
	mov	BYTE PTR ?pixel@@3DE,OFFSET 0
; Line 76
	mov	al,BYTE PTR ?abyte@@3DE
	cbw
	and	ax,OFFSET 128
	cmp	ax,OFFSET 0
	je	L03125
; Line 77
	or	BYTE PTR ?pixel@@3DE,OFFSET 8
; Line 78
L03125:
	mov	al,BYTE PTR ?abyte@@3DE
	cbw
	and	ax,OFFSET 64
	cmp	ax,OFFSET 0
	je	L03126
; Line 79
	or	BYTE PTR ?pixel@@3DE,OFFSET 1
; Line 80
L03126:
	mov	al,BYTE PTR ?abyte@@3DE
	cbw
	and	ax,OFFSET 32
	cmp	ax,OFFSET 0
	je	L03127
; Line 81
	or	BYTE PTR ?pixel@@3DE,OFFSET 2
; Line 82
L03127:
	mov	al,BYTE PTR ?abyte@@3DE
	cbw
	and	ax,OFFSET 16
	cmp	ax,OFFSET 0
	je	L03128
; Line 83
	or	BYTE PTR ?pixel@@3DE,OFFSET 4
; Line 84
L03128:
	mov	bx,WORD PTR ?pNextCellMap@@3PEDE
	mov	es,WORD PTR ?pNextCellMap@@3PEDE+2
	add	WORD PTR ?pNextCellMap@@3PEDE,OFFSET 1
	mov	al,BYTE PTR ?pixel@@3DE
	mov	BYTE PTR es:[bx],al
; Line 85
	mov	BYTE PTR ?pixel@@3DE,OFFSET 0
; Line 87
	mov	al,BYTE PTR ?abyte@@3DE
	cbw
	and	ax,OFFSET 8
	cmp	ax,OFFSET 0
	je	L03129
; Line 88
	or	BYTE PTR ?pixel@@3DE,OFFSET 8
; Line 89
L03129:
	mov	al,BYTE PTR ?abyte@@3DE
	cbw
	and	ax,OFFSET 4
	cmp	ax,OFFSET 0
	je	L03130
; Line 90
	or	BYTE PTR ?pixel@@3DE,OFFSET 1
; Line 91
L03130:
	mov	al,BYTE PTR ?abyte@@3DE
	cbw
	and	ax,OFFSET 2
	cmp	ax,OFFSET 0
	je	L03131
; Line 92
	or	BYTE PTR ?pixel@@3DE,OFFSET 2
; Line 93
L03131:
	mov	al,BYTE PTR ?abyte@@3DE
	cbw
	and	ax,OFFSET 1
	cmp	ax,OFFSET 0
	je	L03132
; Line 94
	or	BYTE PTR ?pixel@@3DE,OFFSET 4
; Line 95
L03132:
	mov	bx,WORD PTR ?pNextCellMap@@3PEDE
	mov	es,WORD PTR ?pNextCellMap@@3PEDE+2
	add	WORD PTR ?pNextCellMap@@3PEDE,OFFSET 1
	mov	al,BYTE PTR ?pixel@@3DE
	mov	BYTE PTR es:[bx],al
; Line 96
L03122:
; Line 96
	sub	WORD PTR -6[bp],OFFSET 1
L03124:
	cmp	WORD PTR -6[bp],OFFSET 0
	jg	L03121
L03123:
; Line 97
	sub	WORD PTR ?pFileBuffer@@3PEDE,OFFSET 320
; Line 98
L03117:
; Line 98
	sub	WORD PTR -4[bp],OFFSET 1
L03119:
	cmp	WORD PTR -4[bp],OFFSET 0
	jg	L03116
L03118:
; Line 100
	mov	WORD PTR ?pNextCellMap@@3PEDE,OFFSET ?NextCellMap@@3QEDE
	mov	WORD PTR ?pNextCellMap@@3PEDE+2,SEG ?NextCellMap@@3QEDE
; Line 101
	mov	WORD PTR ?pNextNeighborCount@@3PEDE,OFFSET ?NextNeighborCount@@3QEDE
	mov	WORD PTR ?pNextNeighborCount@@3PEDE+2,SEG ?NextNeighborCount@@3QEDE
; Line 103
	mov	WORD PTR -4[bp],OFFSET 190
	jmp	L03136
L03133:
; Line 104
; j = fffa
; Line 105
	mov	WORD PTR -6[bp],OFFSET 320
	jmp	L03141
L03138:
; Line 106
; Line 107
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	mov	BYTE PTR es:[bx],OFFSET 0
; Line 108
	les	bx,WORD PTR ?pNextCellMap@@3PEDE
	mov	al,BYTE PTR es:-1[bx]
	cbw
	cmp	ax,OFFSET 1
	jne	L03142
; Line 109
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	add	BYTE PTR es:[bx],OFFSET 1
; Line 110
L03142:
	les	bx,WORD PTR ?pNextCellMap@@3PEDE
	mov	al,BYTE PTR es:-321[bx]
	cbw
	cmp	ax,OFFSET 1
	jne	L03143
; Line 111
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	add	BYTE PTR es:[bx],OFFSET 1
; Line 112
L03143:
	les	bx,WORD PTR ?pNextCellMap@@3PEDE
	mov	al,BYTE PTR es:-320[bx]
	cbw
	cmp	ax,OFFSET 1
	jne	L03144
; Line 113
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	add	BYTE PTR es:[bx],OFFSET 1
; Line 114
L03144:
	les	bx,WORD PTR ?pNextCellMap@@3PEDE
	mov	al,BYTE PTR es:-319[bx]
	cbw
	cmp	ax,OFFSET 1
	jne	L03145
; Line 115
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	add	BYTE PTR es:[bx],OFFSET 1
; Line 116
L03145:
	les	bx,WORD PTR ?pNextCellMap@@3PEDE
	mov	al,BYTE PTR es:1[bx]
	cbw
	cmp	ax,OFFSET 1
	jne	L03146
; Line 117
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	add	BYTE PTR es:[bx],OFFSET 1
; Line 118
L03146:
	les	bx,WORD PTR ?pNextCellMap@@3PEDE
	mov	al,BYTE PTR es:321[bx]
	cbw
	cmp	ax,OFFSET 1
	jne	L03147
; Line 119
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	add	BYTE PTR es:[bx],OFFSET 1
; Line 120
L03147:
	les	bx,WORD PTR ?pNextCellMap@@3PEDE
	mov	al,BYTE PTR es:320[bx]
	cbw
	cmp	ax,OFFSET 1
	jne	L03148
; Line 121
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	add	BYTE PTR es:[bx],OFFSET 1
; Line 122
L03148:
	les	bx,WORD PTR ?pNextCellMap@@3PEDE
	mov	al,BYTE PTR es:319[bx]
	cbw
	cmp	ax,OFFSET 1
	jne	L03149
; Line 123
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	add	BYTE PTR es:[bx],OFFSET 1
; Line 125
L03149:
	add	WORD PTR ?pNextCellMap@@3PEDE,OFFSET 1
; Line 126
	add	WORD PTR ?pNextNeighborCount@@3PEDE,OFFSET 1
; Line 127
L03139:
; Line 127
	sub	WORD PTR -6[bp],OFFSET 1
L03141:
	cmp	WORD PTR -6[bp],OFFSET 0
	jg	L03138
L03140:
; Line 128
L03134:
; Line 128
	sub	WORD PTR -4[bp],OFFSET 1
L03136:
	cmp	WORD PTR -4[bp],OFFSET 0
	jg	L03133
L03135:
; Line 129
	mov	WORD PTR ?pNextCellMap@@3PEDE,OFFSET ?NextCellMap@@3QEDE
	mov	WORD PTR ?pNextCellMap@@3PEDE+2,SEG ?NextCellMap@@3QEDE
; Line 130
	mov	WORD PTR ?pNextNeighborCount@@3PEDE,OFFSET ?NextNeighborCount@@3QEDE
	mov	WORD PTR ?pNextNeighborCount@@3PEDE+2,SEG ?NextNeighborCount@@3QEDE
; Line 131
	mov	WORD PTR ?pCurrentCellMap@@3PEDE,OFFSET ?CurrentCellMap@@3QEDE
	mov	WORD PTR ?pCurrentCellMap@@3PEDE+2,SEG ?CurrentCellMap@@3QEDE
; Line 132
	mov	WORD PTR ?pNeighborCount@@3PEDE,OFFSET ?NeighborCount@@3QEDE
	mov	WORD PTR ?pNeighborCount@@3PEDE+2,SEG ?NeighborCount@@3QEDE
; Line 135
	push	OFFSET -4736
	push	WORD PTR ?pNextCellMap@@3PEDE+2
	push	WORD PTR ?pNextCellMap@@3PEDE
	push	WORD PTR ?pVgaBuffer@@3PEXE+2
	push	WORD PTR ?pVgaBuffer@@3PEXE
	call	FAR PTR __fmemcpy
	add	sp,OFFSET 10
; Line 136
	push	OFFSET -4736
	push	WORD PTR ?pNextCellMap@@3PEDE+2
	push	WORD PTR ?pNextCellMap@@3PEDE
	push	WORD PTR ?pCurrentCellMap@@3PEDE+2
	push	WORD PTR ?pCurrentCellMap@@3PEDE
	call	FAR PTR __fmemcpy
	add	sp,OFFSET 10
; Line 137
	push	OFFSET -4736
	push	WORD PTR ?pNextNeighborCount@@3PEDE+2
	push	WORD PTR ?pNextNeighborCount@@3PEDE
	push	WORD PTR ?pNeighborCount@@3PEDE+2
	push	WORD PTR ?pNeighborCount@@3PEDE
	call	FAR PTR __fmemcpy
	add	sp,OFFSET 10
; Line 140
	push	OFFSET 1
	call	FAR PTR __settextcolor
	add	sp,OFFSET 2
; Line 141
	push	OFFSET 0
	push	OFFSET 0
	call	FAR PTR __settextposition
	add	sp,OFFSET 4
	mov	WORD PTR -8[bp],ax
	mov	WORD PTR -6[bp],dx
	mov	ax,WORD PTR -8[bp]
	mov	dx,WORD PTR -6[bp]
; Line 142
	mov	ax,OFFSET L03151
	mov	dx,ds
	push	dx
	push	ax
	call	FAR PTR __outtext
	add	sp,OFFSET 4
; Line 144
	sub	WORD PTR __iob+4,OFFSET 1
	mov	ax,WORD PTR __iob+4
	cmp	ax,OFFSET 0
	jl	L03170
	mov	bx,WORD PTR __iob
	mov	es,WORD PTR __iob+2
	add	WORD PTR __iob,OFFSET 1
	mov	al,BYTE PTR es:[bx]
	cbw
	and	ax,OFFSET 255
	jmp	L03169
L03170:
	mov	ax,OFFSET __iob
	mov	dx,ds
	push	dx
	push	ax
	call	FAR PTR __filbuf
	add	sp,OFFSET 4
L03169:
; Line 146
L03153:
	call	FAR PTR _kbhit
	cmp	ax,OFFSET 0
	jne	L03154
; Line 147
; y = fffa
; Line 150
	mov	WORD PTR -6[bp],OFFSET 0
	jmp	L03157
L03158:
	add	WORD PTR -6[bp],OFFSET 1
L03157:
	mov	ax,WORD PTR -6[bp]
	mov	dx,OFFSET 0
	cmp	dx,OFFSET 0
	jg	L03159
	jl	L03171
	cmp	ax,OFFSET -4736
	jae	L03159
L03171:
; Line 151
; Line 152
	les	bx,WORD PTR ?pCurrentCellMap@@3PEDE
	mov	al,BYTE PTR es:[bx]
	mov	BYTE PTR ?pixel@@3DE,al
; Line 153
	les	bx,WORD PTR ?pNeighborCount@@3PEDE
	mov	al,BYTE PTR es:[bx]
	mov	BYTE PTR ?neighbor_count@@3DE,al
; Line 156
	mov	al,BYTE PTR ?pixel@@3DE
	cbw
	cmp	ax,OFFSET 1
	jne	L03161
; Line 157
; Line 158
	mov	al,BYTE PTR ?neighbor_count@@3DE
	cbw
	cmp	ax,OFFSET 2
	jl	L03163
	mov	al,BYTE PTR ?neighbor_count@@3DE
	cbw
	cmp	ax,OFFSET 3
	jle	L03162
L03163:
; Line 159
; Line 160
	les	bx,WORD PTR ?pNextCellMap@@3PEDE
	mov	BYTE PTR es:[bx],OFFSET 0
; Line 161
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	sub	BYTE PTR es:-1[bx],OFFSET 1
; Line 162
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	sub	BYTE PTR es:-321[bx],OFFSET 1
; Line 163
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	sub	BYTE PTR es:-320[bx],OFFSET 1
; Line 164
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	sub	BYTE PTR es:-319[bx],OFFSET 1
; Line 165
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	sub	BYTE PTR es:1[bx],OFFSET 1
; Line 166
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	sub	BYTE PTR es:321[bx],OFFSET 1
; Line 167
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	sub	BYTE PTR es:320[bx],OFFSET 1
; Line 168
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	sub	BYTE PTR es:319[bx],OFFSET 1
; Line 169
	add	WORD PTR ?pCurrentCellMap@@3PEDE,OFFSET 1
; Line 170
	add	WORD PTR ?pNextCellMap@@3PEDE,OFFSET 1
; Line 171
	add	WORD PTR ?pNeighborCount@@3PEDE,OFFSET 1
; Line 172
	add	WORD PTR ?pNextNeighborCount@@3PEDE,OFFSET 1
; Line 173
	jmp	L03158
; Line 174
; Line 175
L03162:
; Line 178
L03161:
	mov	al,BYTE PTR ?pixel@@3DE
	cbw
	cmp	ax,OFFSET 0
	jne	L03164
; Line 179
; Line 180
	mov	al,BYTE PTR ?neighbor_count@@3DE
	cbw
	cmp	ax,OFFSET 3
	jne	L03165
; Line 181
; Line 182
	les	bx,WORD PTR ?pNextCellMap@@3PEDE
	mov	BYTE PTR es:[bx],OFFSET 1
; Line 183
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	add	BYTE PTR es:-1[bx],OFFSET 1
; Line 184
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	add	BYTE PTR es:-321[bx],OFFSET 1
; Line 185
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	add	BYTE PTR es:-320[bx],OFFSET 1
; Line 186
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	add	BYTE PTR es:-319[bx],OFFSET 1
; Line 187
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	add	BYTE PTR es:1[bx],OFFSET 1
; Line 188
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	add	BYTE PTR es:321[bx],OFFSET 1
; Line 189
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	add	BYTE PTR es:320[bx],OFFSET 1
; Line 190
	les	bx,WORD PTR ?pNextNeighborCount@@3PEDE
	add	BYTE PTR es:319[bx],OFFSET 1
; Line 191
	add	WORD PTR ?pCurrentCellMap@@3PEDE,OFFSET 1
; Line 192
	add	WORD PTR ?pNextCellMap@@3PEDE,OFFSET 1
; Line 193
	add	WORD PTR ?pNeighborCount@@3PEDE,OFFSET 1
; Line 194
	add	WORD PTR ?pNextNeighborCount@@3PEDE,OFFSET 1
; Line 195
	jmp	L03158
; Line 196
; Line 197
L03165:
; Line 198
L03164:
	add	WORD PTR ?pCurrentCellMap@@3PEDE,OFFSET 1
; Line 199
	add	WORD PTR ?pNextCellMap@@3PEDE,OFFSET 1
; Line 200
	add	WORD PTR ?pNeighborCount@@3PEDE,OFFSET 1
; Line 201
	add	WORD PTR ?pNextNeighborCount@@3PEDE,OFFSET 1
; Line 202
; Line 202
	jmp	L03158
L03159:
; Line 203
	mov	WORD PTR ?pNextCellMap@@3PEDE,OFFSET ?NextCellMap@@3QEDE
	mov	WORD PTR ?pNextCellMap@@3PEDE+2,SEG ?NextCellMap@@3QEDE
; Line 204
	mov	WORD PTR ?pCurrentCellMap@@3PEDE,OFFSET ?CurrentCellMap@@3QEDE
	mov	WORD PTR ?pCurrentCellMap@@3PEDE+2,SEG ?CurrentCellMap@@3QEDE
; Line 205
	mov	WORD PTR ?pNeighborCount@@3PEDE,OFFSET ?NeighborCount@@3QEDE
	mov	WORD PTR ?pNeighborCount@@3PEDE+2,SEG ?NeighborCount@@3QEDE
; Line 206
	mov	WORD PTR ?pNextNeighborCount@@3PEDE,OFFSET ?NextNeighborCount@@3QEDE
	mov	WORD PTR ?pNextNeighborCount@@3PEDE+2,SEG ?NextNeighborCount@@3QEDE
; Line 207
	push	OFFSET -4736
	push	WORD PTR ?pNextCellMap@@3PEDE+2
	push	WORD PTR ?pNextCellMap@@3PEDE
	push	WORD PTR ?pVgaBuffer@@3PEXE+2
	push	WORD PTR ?pVgaBuffer@@3PEXE
	call	FAR PTR __fmemcpy
	add	sp,OFFSET 10
; Line 208
	push	OFFSET -4736
	push	WORD PTR ?pNextCellMap@@3PEDE+2
	push	WORD PTR ?pNextCellMap@@3PEDE
	push	WORD PTR ?pCurrentCellMap@@3PEDE+2
	push	WORD PTR ?pCurrentCellMap@@3PEDE
	call	FAR PTR __fmemcpy
	add	sp,OFFSET 10
; Line 209
	push	OFFSET -4736
	push	WORD PTR ?pNextNeighborCount@@3PEDE+2
	push	WORD PTR ?pNextNeighborCount@@3PEDE
	push	WORD PTR ?pNeighborCount@@3PEDE+2
	push	WORD PTR ?pNeighborCount@@3PEDE
	call	FAR PTR __fmemcpy
	add	sp,OFFSET 10
; Line 212
	add	WORD PTR ?generation@@3JE,OFFSET 1
	adc	WORD PTR ?generation@@3JE+2,OFFSET 0
; Line 213
	push	OFFSET 10
	push	WORD PTR ?pgeneration@@3PEDE+2
	push	WORD PTR ?pgeneration@@3PEDE
	push	WORD PTR ?generation@@3JE+2
	push	WORD PTR ?generation@@3JE
	call	FAR PTR __ltoa
	add	sp,OFFSET 10
; Line 214
	push	OFFSET 13
	push	OFFSET 0
	call	FAR PTR __settextposition
	add	sp,OFFSET 4
	mov	WORD PTR -10[bp],ax
	mov	WORD PTR -8[bp],dx
	mov	ax,WORD PTR -10[bp]
	mov	dx,WORD PTR -8[bp]
; Line 215
	push	WORD PTR ?pgeneration@@3PEDE+2
	push	WORD PTR ?pgeneration@@3PEDE
	call	FAR PTR __outtext
	add	sp,OFFSET 4
; Line 216
; Line 216
	jmp	L03153
L03154:
; Line 219
	push	OFFSET 3
	call	FAR PTR __setvideomode
	add	sp,OFFSET 2
; Line 220
	mov	ax,OFFSET 0
	jmp	L03113
; Line 221
; Line 221
L03113:
	pop	di
	pop	si
	leave
	ret	OFFSET 0
