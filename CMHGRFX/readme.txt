vga graphics library

# 20230124
Built in dosbox 0.74-3 with masm 6.11.

ml /c *.asm
lib cmhgrfx.lib +circle.obj +ellipse.obj +fill.obj +fpoly.obj
lib cmhgrfx.lib +line.obj +pixel.obj +poly.obj +putchar.obj
lib cmhgrfx.lib +setmode.obj +splitscr.obj +ststradr.obj