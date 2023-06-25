# Microsoft Visual C++ generated build script - Do not modify

PROJ = SCREEN2
DEBUG = 1
PROGTYPE = 6
CALLER = 
ARGS = 
DLLS = 
D_RCDEFINES = -d_DEBUG
R_RCDEFINES = -dNDEBUG
ORIGIN = MSVC
ORIGIN_VER = 1.00
PROJPATH = Z:\OLDPROG\PROG~A5A\DOSPROG\SCREEN2\
USEMFC = 0
CC = cl
CPP = cl
CXX = cl
CCREATEPCHFLAG = 
CPPCREATEPCHFLAG = 
CUSEPCHFLAG = 
CPPUSEPCHFLAG = 
FIRSTC =             
FIRSTCPP = TEST.CPP    
RC = rc
CFLAGS_D_DEXE = /nologo /G2 /FPi87 /W3 /Zi /ALw /Od /D "_DEBUG" /D "_DOS" /Fd"SCREEN2.PDB"
CFLAGS_R_DEXE = /nologo /f- /Gs /G3 /FPi87 /W3 /ALw /Ox /Ob2 /D "NDEBUG" /D "_DOS" 
LFLAGS_D_DEXE = /NOLOGO /NOI /STACK:5120 /ONERROR:NOEXE /CO 
LFLAGS_R_DEXE = /NOLOGO /NOI /STACK:5120 /ONERROR:NOEXE 
LIBS_D_DEXE = oldnames llibc7 cmhgrfx.lib 
LIBS_R_DEXE = oldnames llibc7 cmhgrfx.lib 
RCFLAGS = /nologo
RESFLAGS = /nologo
RUNFLAGS = 
OBJS_EXT = 
LIBS_EXT = 
!if "$(DEBUG)" == "1"
CFLAGS = $(CFLAGS_D_DEXE)
LFLAGS = $(LFLAGS_D_DEXE)
LIBS = $(LIBS_D_DEXE)
MAPFILE = nul
RCDEFINES = $(D_RCDEFINES)
!else
CFLAGS = $(CFLAGS_R_DEXE)
LFLAGS = $(LFLAGS_R_DEXE)
LIBS = $(LIBS_R_DEXE)
MAPFILE = nul
RCDEFINES = $(R_RCDEFINES)
!endif
!if [if exist MSVC.BND del MSVC.BND]
!endif
SBRS = SCREEN.SBR \
		TEST.SBR \
		TRIANGLE.SBR


SCREEN_DEP = z:\oldprog\prog~a5a\dosprog\screen2\screen.h \
	z:\oldprog\prog~a5a\dosprog\screen2\cmhgrfx.h


TEST_DEP = z:\oldprog\prog~a5a\dosprog\screen2\triangle.h \
	z:\oldprog\prog~a5a\dosprog\screen2\screen.h \
	z:\oldprog\prog~a5a\dosprog\screen2\cmhgrfx.h


TRIANGLE_DEP = z:\oldprog\prog~a5a\dosprog\screen2\triangle.h \
	z:\oldprog\prog~a5a\dosprog\screen2\screen.h \
	z:\oldprog\prog~a5a\dosprog\screen2\cmhgrfx.h


all:	$(PROJ).EXE

SCREEN.OBJ:	SCREEN.CPP $(SCREEN_DEP)
	$(CPP) $(CFLAGS) $(CPPUSEPCHFLAG) /c SCREEN.CPP

TEST.OBJ:	TEST.CPP $(TEST_DEP)
	$(CPP) $(CFLAGS) $(CPPCREATEPCHFLAG) /c TEST.CPP

TRIANGLE.OBJ:	TRIANGLE.CPP $(TRIANGLE_DEP)
	$(CPP) $(CFLAGS) $(CPPUSEPCHFLAG) /c TRIANGLE.CPP

$(PROJ).EXE::	SCREEN.OBJ TEST.OBJ TRIANGLE.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
SCREEN.OBJ +
TEST.OBJ +
TRIANGLE.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
c:\msvc\lib\+
c:\msvc\mfc\lib\+
$(LIBS)
$(DEFFILE);
<<
	link $(LFLAGS) @$(PROJ).CRF

run: $(PROJ).EXE
	$(PROJ) $(RUNFLAGS)


$(PROJ).BSC: $(SBRS)
	bscmake @<<
/o$@ $(SBRS)
<<
