vga graphics library for dos

# 20230124
Built in dosbox 0.74-3 with masm 6.11
ml /c *.asm
lib vga.lib +bmp2mem.obj +bmp2vga.obj +splitscr.obj +ststradr.obj