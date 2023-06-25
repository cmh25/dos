Graphic library for svga modes

# build instructions
(I last built this in dosbox 0.74-3, with masm 6.11 and borland turbo c++ 3.0)
ml /c *.asm
tcc -c -ml triangle.cpp screen.cpp
lib scmhgrfx.lib +fill.obj +line.obj +pixel.obj +setmode.obj +startadr.obj +triangle.obj +screen.obj

# There are some test programs as examples to exercise the library. 
# They can be built like this:
tcc -ml scmhgrfx.lib test.cpp
tcc -ml scmhgrfx.lib test1.cpp
tcc -ml scmhgrfx.lib test2.cpp
tcc -ml scmhgrfx.lib test3.cpp
tcc -ml scmhgrfx.lib test4.cpp

# svga modes listing
Mode    Resolution  BPP #Colors BitReserv   MemoryReq
Palette Indexing Modes
0x100	640x400	    8	256	    (N/A)       250k
0x101	640x480	    8	256	    (N/A)	    300k
0x102	800x600	    4	16	    (N/A)	    235k
0x103	800x600	    8	256	    (N/A)	    469k
0x104	1024x768	4	16	    (N/A)	    384k
0x105	1024x768	8	256	    (N/A)	    768k
0x106	1280x1024	4	16	    (N/A)	    640k
0x107	1280x1024	8	256	    (N/A)	    1,280k
Direct-Color Modes
0x10D	320x200	    15	32k	    1:5:5:5	    125k
0x10E	320x200	    16	64k	    5:6:5	    125k
0x10F	320x200	    24	16.8M	8:8:8	    188k
0x110	640x480	    15	32k	    1:5:5:5	    600k
0x111	640x480	    16	64k	    5:6:5	    600k
0x112	640x480	    24	16.8M	8:8:8	    900k
0x113	800x600	    15	32k	    1:5:5:5	    992k
0x114	800x600	    16	64k	    5:6:5	    992k
0x115	800x600	    24	16.8M	8:8:8	    1,488k
0x116	1024x768	15	32k	    1:5:5:5	    1,536k
0x117	1024x768	16	64k	    5:6:5	    1,536k
0x118	1024x768	24	16.8M	8:8:8	    2,304k
0x119	1280x1024	15	32k	    1:5:5:5	    2,560k
0x11A	1280x1024	16	64k	    5:6:5	    2,560k
0x11B	1280x1024	24	16.8M	8:8:8	    3,840k