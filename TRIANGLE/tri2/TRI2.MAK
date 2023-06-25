# Microsoft Visual C++ generated build script - Do not modify

PROJ = TRI2
DEBUG = 1
PROGTYPE = 6
CALLER = 
ARGS = 
DLLS = 
D_RCDEFINES = /d_DEBUG
R_RCDEFINES = /dNDEBUG
ORIGIN = MSVC
ORIGIN_VER = 1.00
PROJPATH = Z:\OLDPROG\PROG~A5A\DOSPROG\TRIANGLE\TRI2\
USEMFC = 0
CC = cl
CPP = cl
CXX = cl
CCREATEPCHFLAG = 
CPPCREATEPCHFLAG = 
CUSEPCHFLAG = 
CPPUSEPCHFLAG = 
FIRSTC =             
FIRSTCPP = SCREEN.CPP  
RC = rc
CFLAGS_D_DEXE = /nologo /G2 /FPi87 /W3 /Zi /AL /Od /D "_DEBUG" /D "_DOS" /FR /Fd"TRI2.PDB"
CFLAGS_R_DEXE = /nologo /Gs /G2 /W3 /AM /Ox /D "NDEBUG" /D "_DOS" /FR 
LFLAGS_D_DEXE = /NOLOGO /ONERROR:NOEXE /NOI /CO /STACK:5120
LFLAGS_R_DEXE = /NOLOGO /ONERROR:NOEXE /NOI /STACK:5120
LIBS_D_DEXE = oldnames llibc7
LIBS_R_DEXE = oldnames mlibce
RCFLAGS = /nologo
RESFLAGS = /nologo
RUNFLAGS = 
OBJS_EXT = 
LIBS_EXT = CMHGRFX.LIB 
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
		TRI2.SBR \
		TRIANGLE.SBR


SCREEN_DEP = z:\oldprog\prog~a5a\dosprog\triangle\tri2\screen.h \
	z:\oldprog\prog~a5a\dosprog\triangle\tri2\cmhgrfx.h


TRI2_DEP = z:\oldprog\prog~a5a\dosprog\triangle\tri2\triangle.h \
	z:\oldprog\prog~a5a\dosprog\triangle\tri2\screen.h \
	z:\oldprog\prog~a5a\dosprog\triangle\tri2\cmhgrfx.h


TRIANGLE_DEP = z:\oldprog\prog~a5a\dosprog\triangle\tri2\triangle.h \
	z:\oldprog\prog~a5a\dosprog\triangle\tri2\screen.h \
	z:\oldprog\prog~a5a\dosprog\triangle\tri2\cmhgrfx.h


CMHGRFX_DEP = 

all:	$(PROJ).EXE $(PROJ).BSC

SCREEN.OBJ:	SCREEN.CPP $(SCREEN_DEP)
	$(CPP) $(CFLAGS) $(CPPCREATEPCHFLAG) /c SCREEN.CPP

TRI2.OBJ:	TRI2.CPP $(TRI2_DEP)
	$(CPP) $(CFLAGS) $(CPPUSEPCHFLAG) /c TRI2.CPP

TRIANGLE.OBJ:	TRIANGLE.CPP $(TRIANGLE_DEP)
	$(CPP) $(CFLAGS) $(CPPUSEPCHFLAG) /c TRIANGLE.CPP

$(PROJ).EXE::	SCREEN.OBJ TRI2.OBJ TRIANGLE.OBJ $(OBJS_EXT) $(DEFFILE)
	echo >NUL @<<$(PROJ).CRF
SCREEN.OBJ +
TRI2.OBJ +
TRIANGLE.OBJ +
$(OBJS_EXT)
$(PROJ).EXE
$(MAPFILE)
c:\msvc\lib\+
c:\msvc\mfc\lib\+
CMHGRFX.LIB+
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
