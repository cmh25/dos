;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				protest.asm
;				 12-25-99
;
; Copies a DOS .exe file into a 512 byte buffer.
; Then writes the buffer to the boot sector of a:
;
; ****All my labels and offsets are fucked up *******************
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.model small
.586p
.stack 100h
.data
	buffer01	db	512 dup(0)
	buffer02	db	2560 dup(0)
	error1		db	0ah,0dh,'Something went wrong!',0ah,0dh,'$'
	success 	db	0ah,0dh,'OK',0ah,0dh,'$'
	count		db	4
.code
	org 7bfdh
start:
	jmp skip
      sector_1:
	;
	; Instructions to be copied to boot disk
	; Execution will begin here at bootup
	;********************************************************************
	;********************************************************************
	mov ax,cs
	mov ds,ax
	mov es,ax

	;
	; 1 - Load GDT
	; 2 - Load IDT
	; 3 - Activate protected mode
	; 4 - Jmp to protected code segment
	; 5 - Load segment selectors
	;

	; 1
	;xor eax,eax
	;mov eax,cs
	;shl eax,4
	;add eax,offset Global_Descriptor_Table
	;mov Global_Descriptor_Table_Descriptor.Base,eax
	;mov ax,offset End_Global_Descriptor_Table
	;sub ax,offset Global_Descriptor_Table
	;mov Global_Descriptor_Table_Descriptor.Size1,ax
	db 66h
	lgdt Global_Descriptor_Table_Descriptor
	; 2
      again3:
	mov ah,0
	mov dl,0
	int 13h
	mov ax,02000h
	mov es,ax
	mov bx,0
	mov ax,0205h
	mov ch,0
	mov cl,2
	mov dh,0
	mov dl,0
	int 13h
	cmp ah,0
	jnz again3
	db 66h
	lidt Interrupt_Descriptor_Table_Descriptor
	; 3
	mov ax,2
	mov ds,ax
	mov fs,ax
	mov gs,ax
	mov ax,3
	mov ss,ax
	mov ax,4
	mov es,ax
	cli
	mov eax,1
	mov cr0,eax
	; 4
	db 66h
	db 0eah
	dd Entry_Point
	;dw Code_0_Selector
	dw 0000000000001000b
	; 5
      Entry_Point: ;*****************Now in protected mode*******************
	;mov ax,Data_0_Selector
	mov ax,0000000000010000b
	mov ds,ax
	mov fs,ax
	mov gs,ax
	;mov ax,Stack_0_Selector
	mov ax,0000000000011000b
	mov ss,ax
	;mov ax,Vga_Text_Selector
	mov ax,0000000000100000b
	mov es,ax
	;sti
	mov edi,0
	mov al,65
	mov ecx,0ffh
	rep stosb
      stay:
	;jmp stay
	db 0eah
	dw 0
	dw stay

	;--------------------------------------------------------------------
	; Data
	;--------------------------------------------------------------------
	Table_Descriptor struc
		Size1		dw 0
		Base		dd 0
	Table_Descriptor ends

	Segment_Descriptor struc
		Size_0_15	dw 0
		Base_0_15	dw 0
		Base_16_23	db 0
		Type_1		db 0
		Type_2		db 0
		Base_24_31	db 0
	Segment_Descriptor ends

	Global_Descriptor_Table:
		Entry_0 	Segment_Descriptor <>
		Code_0		Segment_Descriptor  \
			<0ffffh,,,10011110b,01010000b,>
		Data_0		Segment_Descriptor  \
			<0ffffh,,,10010010b,00010000b,>
		Stack_0 	Segment_Descriptor  \
			<0ffffh,,0eh,10010010b,01010000b,>
		Vga_Text	Segment_Descriptor  \
			<0ffffh,,0ah,10010010b,00010000b,>
		Vga_Graphic	Segment_Descriptor  \
			<0ffffh,8000h,0bh,10010010b,00010000b,>
	End_Global_Descriptor_Table:

	Segment_Selector struc
		Index		dw 0
	Segment_Selector ends

	Entry_0_Selector	Segment_Selector <>
	Code_0_Selector 	Segment_Selector <1>
	Data_0_Selector 	Segment_Selector <2>
	Stack_0_Selector	Segment_Selector <3>
	Vga_Text_Selector	Segment_Selector <4>
	Vga_Graphic_Selector	Segment_Selector <5>

	Interrupt_Gate_Descriptor struc
		Offset_0_15	dw	offset Interrupt_Handler
		Selectorx	dw	1
		Reserved	db	0
		Options 	db	10001110b
		Offset_16_31	dw	0
	Interrupt_Gate_Descriptor ends

	Global_Descriptor_Table_Descriptor	Table_Descriptor <48,7c81h>
	Interrupt_Descriptor_Table_Descriptor	Table_Descriptor <2048,020000h>
      Interrupt_Handler:
	iret
	;********************************************************************
	;********************************************************************
      endsector_1:
      sector_2_6:
	;********************************************************************
	;********************************************************************
	Start_Interrupt_Descriptor_Table:
		Int_0	Interrupt_Gate_Descriptor <>
		Int_1	Interrupt_Gate_Descriptor <>
		Int_2	Interrupt_Gate_Descriptor <>
		Int_3	Interrupt_Gate_Descriptor <>
		Int_4	Interrupt_Gate_Descriptor <>
		Int_5	Interrupt_Gate_Descriptor <>
		Int_6	Interrupt_Gate_Descriptor <>
		Int_7	Interrupt_Gate_Descriptor <>
		Int_8	Interrupt_Gate_Descriptor <>
		Int_9	Interrupt_Gate_Descriptor <>
		Int_10	Interrupt_Gate_Descriptor <>
		Int_11	Interrupt_Gate_Descriptor <>
		Int_12	Interrupt_Gate_Descriptor <>
		Int_13	Interrupt_Gate_Descriptor <>
		Int_14	Interrupt_Gate_Descriptor <>
		Int_15	Interrupt_Gate_Descriptor <>
		Int_16	Interrupt_Gate_Descriptor <>
		Int_17	Interrupt_Gate_Descriptor <>
		Int_18	Interrupt_Gate_Descriptor <>
		Int_19	Interrupt_Gate_Descriptor <>
		Int_20	Interrupt_Gate_Descriptor <>
		Int_21	Interrupt_Gate_Descriptor <>
		Int_22	Interrupt_Gate_Descriptor <>
		Int_23	Interrupt_Gate_Descriptor <>
		Int_24	Interrupt_Gate_Descriptor <>
		Int_25	Interrupt_Gate_Descriptor <>
		Int_26	Interrupt_Gate_Descriptor <>
		Int_27	Interrupt_Gate_Descriptor <>
		Int_28	Interrupt_Gate_Descriptor <>
		Int_29	Interrupt_Gate_Descriptor <>
		Int_30	Interrupt_Gate_Descriptor <>
		Int_31	Interrupt_Gate_Descriptor <>
		Int_32	Interrupt_Gate_Descriptor <>
		Int_33	Interrupt_Gate_Descriptor <>
		Int_34	Interrupt_Gate_Descriptor <>
		Int_35	Interrupt_Gate_Descriptor <>
		Int_36	Interrupt_Gate_Descriptor <>
		Int_37	Interrupt_Gate_Descriptor <>
		Int_38	Interrupt_Gate_Descriptor <>
		Int_39	Interrupt_Gate_Descriptor <>
		Int_40	Interrupt_Gate_Descriptor <>
		Int_41	Interrupt_Gate_Descriptor <>
		Int_42	Interrupt_Gate_Descriptor <>
		Int_43	Interrupt_Gate_Descriptor <>
		Int_44	Interrupt_Gate_Descriptor <>
		Int_45	Interrupt_Gate_Descriptor <>
		Int_46	Interrupt_Gate_Descriptor <>
		Int_47	Interrupt_Gate_Descriptor <>
		Int_48	Interrupt_Gate_Descriptor <>
		Int_49	Interrupt_Gate_Descriptor <>
		Int_50	Interrupt_Gate_Descriptor <>
		Int_51	Interrupt_Gate_Descriptor <>
		Int_52	Interrupt_Gate_Descriptor <>
		Int_53	Interrupt_Gate_Descriptor <>
		Int_54	Interrupt_Gate_Descriptor <>
		Int_55	Interrupt_Gate_Descriptor <>
		Int_56	Interrupt_Gate_Descriptor <>
		Int_57	Interrupt_Gate_Descriptor <>
		Int_58	Interrupt_Gate_Descriptor <>
		Int_59	Interrupt_Gate_Descriptor <>
		Int_60	Interrupt_Gate_Descriptor <>
		Int_61	Interrupt_Gate_Descriptor <>
		Int_62	Interrupt_Gate_Descriptor <>
		Int_63	Interrupt_Gate_Descriptor <>
		Int_64	Interrupt_Gate_Descriptor <>
		Int_65	Interrupt_Gate_Descriptor <>
		Int_66	Interrupt_Gate_Descriptor <>
		Int_67	Interrupt_Gate_Descriptor <>
		Int_68	Interrupt_Gate_Descriptor <>
		Int_69	Interrupt_Gate_Descriptor <>
		Int_70	Interrupt_Gate_Descriptor <>
		Int_71	Interrupt_Gate_Descriptor <>
		Int_72	Interrupt_Gate_Descriptor <>
		Int_73	Interrupt_Gate_Descriptor <>
		Int_74	Interrupt_Gate_Descriptor <>
		Int_75	Interrupt_Gate_Descriptor <>
		Int_76	Interrupt_Gate_Descriptor <>
		Int_77	Interrupt_Gate_Descriptor <>
		Int_78	Interrupt_Gate_Descriptor <>
		Int_79	Interrupt_Gate_Descriptor <>
		Int_80	Interrupt_Gate_Descriptor <>
		Int_81	Interrupt_Gate_Descriptor <>
		Int_82	Interrupt_Gate_Descriptor <>
		Int_83	Interrupt_Gate_Descriptor <>
		Int_84	Interrupt_Gate_Descriptor <>
		Int_85	Interrupt_Gate_Descriptor <>
		Int_86	Interrupt_Gate_Descriptor <>
		Int_87	Interrupt_Gate_Descriptor <>
		Int_88	Interrupt_Gate_Descriptor <>
		Int_89	Interrupt_Gate_Descriptor <>
		Int_90	Interrupt_Gate_Descriptor <>
		Int_91	Interrupt_Gate_Descriptor <>
		Int_92	Interrupt_Gate_Descriptor <>
		Int_93	Interrupt_Gate_Descriptor <>
		Int_94	Interrupt_Gate_Descriptor <>
		Int_95	Interrupt_Gate_Descriptor <>
		Int_96	Interrupt_Gate_Descriptor <>
		Int_97	Interrupt_Gate_Descriptor <>
		Int_98	Interrupt_Gate_Descriptor <>
		Int_99	Interrupt_Gate_Descriptor <>
		Int_100	Interrupt_Gate_Descriptor <>
		Int_101	Interrupt_Gate_Descriptor <>
		Int_102	Interrupt_Gate_Descriptor <>
		Int_103	Interrupt_Gate_Descriptor <>
		Int_104	Interrupt_Gate_Descriptor <>
		Int_105	Interrupt_Gate_Descriptor <>
		Int_106	Interrupt_Gate_Descriptor <>
		Int_107	Interrupt_Gate_Descriptor <>
		Int_108	Interrupt_Gate_Descriptor <>
		Int_109	Interrupt_Gate_Descriptor <>
		Int_110	Interrupt_Gate_Descriptor <>
		Int_111	Interrupt_Gate_Descriptor <>
		Int_112	Interrupt_Gate_Descriptor <>
		Int_113	Interrupt_Gate_Descriptor <>
		Int_114	Interrupt_Gate_Descriptor <>
		Int_115	Interrupt_Gate_Descriptor <>
		Int_116	Interrupt_Gate_Descriptor <>
		Int_117	Interrupt_Gate_Descriptor <>
		Int_118	Interrupt_Gate_Descriptor <>
		Int_119	Interrupt_Gate_Descriptor <>
		Int_120	Interrupt_Gate_Descriptor <>
		Int_121	Interrupt_Gate_Descriptor <>
		Int_122	Interrupt_Gate_Descriptor <>
		Int_123	Interrupt_Gate_Descriptor <>
		Int_124	Interrupt_Gate_Descriptor <>
		Int_125	Interrupt_Gate_Descriptor <>
		Int_126	Interrupt_Gate_Descriptor <>
		Int_127	Interrupt_Gate_Descriptor <>
		Int_128	Interrupt_Gate_Descriptor <>
		Int_129	Interrupt_Gate_Descriptor <>
		Int_130	Interrupt_Gate_Descriptor <>
		Int_131	Interrupt_Gate_Descriptor <>
		Int_132	Interrupt_Gate_Descriptor <>
		Int_133	Interrupt_Gate_Descriptor <>
		Int_134	Interrupt_Gate_Descriptor <>
		Int_135	Interrupt_Gate_Descriptor <>
		Int_136	Interrupt_Gate_Descriptor <>
		Int_137	Interrupt_Gate_Descriptor <>
		Int_138	Interrupt_Gate_Descriptor <>
		Int_139	Interrupt_Gate_Descriptor <>
		Int_140	Interrupt_Gate_Descriptor <>
		Int_141	Interrupt_Gate_Descriptor <>
		Int_142	Interrupt_Gate_Descriptor <>
		Int_143	Interrupt_Gate_Descriptor <>
		Int_144	Interrupt_Gate_Descriptor <>
		Int_145	Interrupt_Gate_Descriptor <>
		Int_146	Interrupt_Gate_Descriptor <>
		Int_147	Interrupt_Gate_Descriptor <>
		Int_148	Interrupt_Gate_Descriptor <>
		Int_149	Interrupt_Gate_Descriptor <>
		Int_150	Interrupt_Gate_Descriptor <>
		Int_151	Interrupt_Gate_Descriptor <>
		Int_152	Interrupt_Gate_Descriptor <>
		Int_153	Interrupt_Gate_Descriptor <>
		Int_154	Interrupt_Gate_Descriptor <>
		Int_155	Interrupt_Gate_Descriptor <>
		Int_156	Interrupt_Gate_Descriptor <>
		Int_157	Interrupt_Gate_Descriptor <>
		Int_158	Interrupt_Gate_Descriptor <>
		Int_159	Interrupt_Gate_Descriptor <>
		Int_160	Interrupt_Gate_Descriptor <>
		Int_161	Interrupt_Gate_Descriptor <>
		Int_162	Interrupt_Gate_Descriptor <>
		Int_163	Interrupt_Gate_Descriptor <>
		Int_164	Interrupt_Gate_Descriptor <>
		Int_165	Interrupt_Gate_Descriptor <>
		Int_166	Interrupt_Gate_Descriptor <>
		Int_167	Interrupt_Gate_Descriptor <>
		Int_168	Interrupt_Gate_Descriptor <>
		Int_169	Interrupt_Gate_Descriptor <>
		Int_170	Interrupt_Gate_Descriptor <>
		Int_171	Interrupt_Gate_Descriptor <>
		Int_172	Interrupt_Gate_Descriptor <>
		Int_173	Interrupt_Gate_Descriptor <>
		Int_174	Interrupt_Gate_Descriptor <>
		Int_175	Interrupt_Gate_Descriptor <>
		Int_176	Interrupt_Gate_Descriptor <>
		Int_177	Interrupt_Gate_Descriptor <>
		Int_178	Interrupt_Gate_Descriptor <>
		Int_179	Interrupt_Gate_Descriptor <>
		Int_180	Interrupt_Gate_Descriptor <>
		Int_181	Interrupt_Gate_Descriptor <>
		Int_182	Interrupt_Gate_Descriptor <>
		Int_183	Interrupt_Gate_Descriptor <>
		Int_184	Interrupt_Gate_Descriptor <>
		Int_185	Interrupt_Gate_Descriptor <>
		Int_186	Interrupt_Gate_Descriptor <>
		Int_187	Interrupt_Gate_Descriptor <>
		Int_188	Interrupt_Gate_Descriptor <>
		Int_189	Interrupt_Gate_Descriptor <>
		Int_190	Interrupt_Gate_Descriptor <>
		Int_191	Interrupt_Gate_Descriptor <>
		Int_192	Interrupt_Gate_Descriptor <>
		Int_193	Interrupt_Gate_Descriptor <>
		Int_194	Interrupt_Gate_Descriptor <>
		Int_195	Interrupt_Gate_Descriptor <>
		Int_196	Interrupt_Gate_Descriptor <>
		Int_197	Interrupt_Gate_Descriptor <>
		Int_198	Interrupt_Gate_Descriptor <>
		Int_199	Interrupt_Gate_Descriptor <>
		Int_200	Interrupt_Gate_Descriptor <>
		Int_201	Interrupt_Gate_Descriptor <>
		Int_202	Interrupt_Gate_Descriptor <>
		Int_203	Interrupt_Gate_Descriptor <>
		Int_204	Interrupt_Gate_Descriptor <>
		Int_205	Interrupt_Gate_Descriptor <>
		Int_206	Interrupt_Gate_Descriptor <>
		Int_207	Interrupt_Gate_Descriptor <>
		Int_208	Interrupt_Gate_Descriptor <>
		Int_209	Interrupt_Gate_Descriptor <>
		Int_210	Interrupt_Gate_Descriptor <>
		Int_211	Interrupt_Gate_Descriptor <>
		Int_212	Interrupt_Gate_Descriptor <>
		Int_213	Interrupt_Gate_Descriptor <>
		Int_214	Interrupt_Gate_Descriptor <>
		Int_215	Interrupt_Gate_Descriptor <>
		Int_216	Interrupt_Gate_Descriptor <>
		Int_217	Interrupt_Gate_Descriptor <>
		Int_218	Interrupt_Gate_Descriptor <>
		Int_219	Interrupt_Gate_Descriptor <>
		Int_220	Interrupt_Gate_Descriptor <>
		Int_221	Interrupt_Gate_Descriptor <>
		Int_222	Interrupt_Gate_Descriptor <>
		Int_223	Interrupt_Gate_Descriptor <>
		Int_224	Interrupt_Gate_Descriptor <>
		Int_225	Interrupt_Gate_Descriptor <>
		Int_226	Interrupt_Gate_Descriptor <>
		Int_227	Interrupt_Gate_Descriptor <>
		Int_228	Interrupt_Gate_Descriptor <>
		Int_229	Interrupt_Gate_Descriptor <>
		Int_230	Interrupt_Gate_Descriptor <>
		Int_231	Interrupt_Gate_Descriptor <>
		Int_232	Interrupt_Gate_Descriptor <>
		Int_233	Interrupt_Gate_Descriptor <>
		Int_234	Interrupt_Gate_Descriptor <>
		Int_235	Interrupt_Gate_Descriptor <>
		Int_236	Interrupt_Gate_Descriptor <>
		Int_237	Interrupt_Gate_Descriptor <>
		Int_238	Interrupt_Gate_Descriptor <>
		Int_239	Interrupt_Gate_Descriptor <>
		Int_240	Interrupt_Gate_Descriptor <>
		Int_241	Interrupt_Gate_Descriptor <>
		Int_242	Interrupt_Gate_Descriptor <>
		Int_243	Interrupt_Gate_Descriptor <>
		Int_244	Interrupt_Gate_Descriptor <>
		Int_245	Interrupt_Gate_Descriptor <>
		Int_246	Interrupt_Gate_Descriptor <>
		Int_247	Interrupt_Gate_Descriptor <>
		Int_248	Interrupt_Gate_Descriptor <>
		Int_249	Interrupt_Gate_Descriptor <>
		Int_250	Interrupt_Gate_Descriptor <>
		Int_251 Interrupt_Gate_Descriptor <>
		Int_252	Interrupt_Gate_Descriptor <>
		Int_253	Interrupt_Gate_Descriptor <>
		Int_254	Interrupt_Gate_Descriptor <>
		Int_255	Interrupt_Gate_Descriptor <>
	End_Interrupt_Descriptor_Table:
	;********************************************************************
	;********************************************************************
      endsector_2_6:
      skip:
	;
	; Copy CS:sector_1 to buffer01 (512 bytes)
	;
	mov ax,@data
	mov ds,ax
	push ds
	mov es,ax
	mov di,offset buffer01
	mov ax,cs
	mov ds,ax
	mov cx,endsector_1
	sub cx,sector_1
	mov si,sector_1
	rep movsb
	pop ds
	;
	; Write buffer to file
	;
      again:
	dec count
	cmp count,0
	jz error
	mov ah,0
	mov dl,0
	int 13h
	mov ax,0301h
	mov ch,0
	mov cl,1
	mov dh,0
	mov dl,0
	mov bx,offset buffer01
	int 13h
	cmp ah,0
	jnz again
	mov dx,offset success
	mov ah,9
	int 21h
	jmp nextsectors
      error:
	;
	; Error handling
	;
	mov dx,offset error1
	mov ah,9
	int 21h

      nextsectors:
	;
	; Copy CS:sector_2_6 to buffer (2048 bytes)
	;
	push ds
	mov ax,@data
	mov es,ax
	mov di,offset buffer02
	mov ax,cs
	mov ds,ax
	mov cx,endsector_2_6
	sub cx,sector_2_6
	mov si,sector_2_6
	rep movsb
	pop ds
	;
	; Write buffer to file
	;
	mov count,4
      again2:
	dec count
	cmp count,0
	jz error2
	mov ah,0
	mov dl,0
	int 13h
	mov ax,0305h
	mov ch,0
	mov cl,2
	mov dh,0
	mov dl,0
	mov bx,offset buffer02
	int 13h
	cmp ah,0
	jnz again2
	mov dx,offset success
	mov ah,9
	int 21h
	jmp done
      error2:
	;
	; Error handling
	;
	mov dx,offset error1
	mov ah,9
	int 21h

      done:
	;
	; Exit
	;
	mov ax,4c00h
	int 21h

end start
