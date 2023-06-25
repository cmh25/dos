Using 8253 timer chip to make music on the pc speaker.
freqs.txt has a listing that maps musical notes to frequencies.

# 20230124
Built in dosbox 0.74-3 with masm 6.11 and borland turbo c++ 3.00.

# build library
ml /c 8253.asm
lib 8253.lib +8253.obj

main.c is an example of using the library with c.
_main.asm is an example of using the library from another asm file.

# build c version, main.exe
tcc -ml 8253.lib main.c

# build asm version, _main.exe
ml _main.asm
