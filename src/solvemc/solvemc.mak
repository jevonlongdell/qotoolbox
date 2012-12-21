# Microsoft Developer Studio Generated NMAKE File, Format Version 4.20
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

!IF "$(CFG)" == ""
CFG=solvemc - Win32 Debug
!MESSAGE No configuration specified.  Defaulting to solvemc - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "solvemc - Win32 Release" && "$(CFG)" !=\
 "solvemc - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "solvemc.mak" CFG="solvemc - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "solvemc - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "solvemc - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 
################################################################################
# Begin Project
# PROP Target_Last_Scanned "solvemc - Win32 Debug"
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "solvemc - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""
OUTDIR=.\Release
INTDIR=.\Release

ALL : "$(OUTDIR)\solvemc.exe"

CLEAN : 
	-@erase "$(INTDIR)\band.obj"
	-@erase "$(INTDIR)\com.obj"
	-@erase "$(INTDIR)\cvband.obj"
	-@erase "$(INTDIR)\cvdense.obj"
	-@erase "$(INTDIR)\cvdiag.obj"
	-@erase "$(INTDIR)\cvode1.obj"
	-@erase "$(INTDIR)\cvspgmr.obj"
	-@erase "$(INTDIR)\dense.obj"
	-@erase "$(INTDIR)\funcs.obj"
	-@erase "$(INTDIR)\iterativ.obj"
	-@erase "$(INTDIR)\linpack.obj"
	-@erase "$(INTDIR)\llnlmath.obj"
	-@erase "$(INTDIR)\ranlib.obj"
	-@erase "$(INTDIR)\solvemc.obj"
	-@erase "$(INTDIR)\spgmr.obj"
	-@erase "$(INTDIR)\vector.obj"
	-@erase "$(OUTDIR)\solvemc.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /YX /c
# ADD CPP /nologo /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /YX /c
CPP_PROJ=/nologo /ML /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE"\
 /Fp"$(INTDIR)/solvemc.pch" /YX /Fo"$(INTDIR)/" /c 
CPP_OBJS=.\Release/
CPP_SBRS=.\.
# ADD BASE RSC /l 0x1409 /d "NDEBUG"
# ADD RSC /l 0x1409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/solvemc.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib\
 odbccp32.lib /nologo /subsystem:console /incremental:no\
 /pdb:"$(OUTDIR)/solvemc.pdb" /machine:I386 /out:"$(OUTDIR)/solvemc.exe" 
LINK32_OBJS= \
	"$(INTDIR)\band.obj" \
	"$(INTDIR)\com.obj" \
	"$(INTDIR)\cvband.obj" \
	"$(INTDIR)\cvdense.obj" \
	"$(INTDIR)\cvdiag.obj" \
	"$(INTDIR)\cvode1.obj" \
	"$(INTDIR)\cvspgmr.obj" \
	"$(INTDIR)\dense.obj" \
	"$(INTDIR)\funcs.obj" \
	"$(INTDIR)\iterativ.obj" \
	"$(INTDIR)\linpack.obj" \
	"$(INTDIR)\llnlmath.obj" \
	"$(INTDIR)\ranlib.obj" \
	"$(INTDIR)\solvemc.obj" \
	"$(INTDIR)\spgmr.obj" \
	"$(INTDIR)\vector.obj"

"$(OUTDIR)\solvemc.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "solvemc - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
OUTDIR=.\Debug
INTDIR=.\Debug

ALL : "$(OUTDIR)\solvemc.exe"

CLEAN : 
	-@erase "$(INTDIR)\band.obj"
	-@erase "$(INTDIR)\com.obj"
	-@erase "$(INTDIR)\cvband.obj"
	-@erase "$(INTDIR)\cvdense.obj"
	-@erase "$(INTDIR)\cvdiag.obj"
	-@erase "$(INTDIR)\cvode1.obj"
	-@erase "$(INTDIR)\cvspgmr.obj"
	-@erase "$(INTDIR)\dense.obj"
	-@erase "$(INTDIR)\funcs.obj"
	-@erase "$(INTDIR)\iterativ.obj"
	-@erase "$(INTDIR)\linpack.obj"
	-@erase "$(INTDIR)\llnlmath.obj"
	-@erase "$(INTDIR)\ranlib.obj"
	-@erase "$(INTDIR)\solvemc.obj"
	-@erase "$(INTDIR)\spgmr.obj"
	-@erase "$(INTDIR)\vc40.idb"
	-@erase "$(INTDIR)\vc40.pdb"
	-@erase "$(INTDIR)\vector.obj"
	-@erase "$(OUTDIR)\solvemc.exe"
	-@erase "$(OUTDIR)\solvemc.ilk"
	-@erase "$(OUTDIR)\solvemc.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /YX /c
# ADD CPP /nologo /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /YX /c
CPP_PROJ=/nologo /MLd /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE"\
 /Fp"$(INTDIR)/solvemc.pch" /YX /Fo"$(INTDIR)/" /Fd"$(INTDIR)/" /c 
CPP_OBJS=.\Debug/
CPP_SBRS=.\.
# ADD BASE RSC /l 0x1409 /d "_DEBUG"
# ADD RSC /l 0x1409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/solvemc.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib\
 odbccp32.lib /nologo /subsystem:console /incremental:yes\
 /pdb:"$(OUTDIR)/solvemc.pdb" /debug /machine:I386 /out:"$(OUTDIR)/solvemc.exe" 
LINK32_OBJS= \
	"$(INTDIR)\band.obj" \
	"$(INTDIR)\com.obj" \
	"$(INTDIR)\cvband.obj" \
	"$(INTDIR)\cvdense.obj" \
	"$(INTDIR)\cvdiag.obj" \
	"$(INTDIR)\cvode1.obj" \
	"$(INTDIR)\cvspgmr.obj" \
	"$(INTDIR)\dense.obj" \
	"$(INTDIR)\funcs.obj" \
	"$(INTDIR)\iterativ.obj" \
	"$(INTDIR)\linpack.obj" \
	"$(INTDIR)\llnlmath.obj" \
	"$(INTDIR)\ranlib.obj" \
	"$(INTDIR)\solvemc.obj" \
	"$(INTDIR)\spgmr.obj" \
	"$(INTDIR)\vector.obj"

"$(OUTDIR)\solvemc.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 

.c{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.cpp{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.cxx{$(CPP_OBJS)}.obj:
   $(CPP) $(CPP_PROJ) $<  

.c{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

.cpp{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

.cxx{$(CPP_SBRS)}.sbr:
   $(CPP) $(CPP_PROJ) $<  

################################################################################
# Begin Target

# Name "solvemc - Win32 Release"
# Name "solvemc - Win32 Debug"

!IF  "$(CFG)" == "solvemc - Win32 Release"

!ELSEIF  "$(CFG)" == "solvemc - Win32 Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE=.\vector.c
DEP_CPP_VECTO=\
	".\llnlmath.h"\
	".\llnltyps.h"\
	".\vector.h"\
	

"$(INTDIR)\vector.obj" : $(SOURCE) $(DEP_CPP_VECTO) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\com.c
DEP_CPP_COM_C=\
	".\ranlib.h"\
	

"$(INTDIR)\com.obj" : $(SOURCE) $(DEP_CPP_COM_C) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\cvband.c
DEP_CPP_CVBAN=\
	".\band.h"\
	".\cvband.h"\
	".\cvode.h"\
	".\llnlmath.h"\
	".\llnltyps.h"\
	".\vector.h"\
	

"$(INTDIR)\cvband.obj" : $(SOURCE) $(DEP_CPP_CVBAN) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\cvdense.c
DEP_CPP_CVDEN=\
	".\cvdense.h"\
	".\cvode.h"\
	".\dense.h"\
	".\llnlmath.h"\
	".\llnltyps.h"\
	".\vector.h"\
	

"$(INTDIR)\cvdense.obj" : $(SOURCE) $(DEP_CPP_CVDEN) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\cvdiag.c
DEP_CPP_CVDIA=\
	".\cvdiag.h"\
	".\cvode.h"\
	".\llnltyps.h"\
	".\vector.h"\
	

"$(INTDIR)\cvdiag.obj" : $(SOURCE) $(DEP_CPP_CVDIA) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\cvode1.c
DEP_CPP_CVODE=\
	".\cvode.h"\
	".\llnlmath.h"\
	".\llnltyps.h"\
	".\vector.h"\
	

"$(INTDIR)\cvode1.obj" : $(SOURCE) $(DEP_CPP_CVODE) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\cvspgmr.c
DEP_CPP_CVSPG=\
	".\cvode.h"\
	".\cvspgmr.h"\
	".\iterativ.h"\
	".\llnlmath.h"\
	".\llnltyps.h"\
	".\spgmr.h"\
	".\vector.h"\
	

"$(INTDIR)\cvspgmr.obj" : $(SOURCE) $(DEP_CPP_CVSPG) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\dense.c
DEP_CPP_DENSE=\
	".\dense.h"\
	".\llnlmath.h"\
	".\llnltyps.h"\
	".\vector.h"\
	

"$(INTDIR)\dense.obj" : $(SOURCE) $(DEP_CPP_DENSE) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\iterativ.c
DEP_CPP_ITERA=\
	".\iterativ.h"\
	".\llnlmath.h"\
	".\llnltyps.h"\
	".\vector.h"\
	

"$(INTDIR)\iterativ.obj" : $(SOURCE) $(DEP_CPP_ITERA) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\linpack.c

"$(INTDIR)\linpack.obj" : $(SOURCE) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\llnlmath.c
DEP_CPP_LLNLM=\
	".\llnlmath.h"\
	".\llnltyps.h"\
	

"$(INTDIR)\llnlmath.obj" : $(SOURCE) $(DEP_CPP_LLNLM) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\ranlib.c
DEP_CPP_RANLI=\
	".\ranlib.h"\
	

"$(INTDIR)\ranlib.obj" : $(SOURCE) $(DEP_CPP_RANLI) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\solvemc.c
DEP_CPP_SOLVE=\
	".\cvdiag.h"\
	".\cvode.h"\
	".\llnltyps.h"\
	".\ranlib.h"\
	".\vector.h"\
	

"$(INTDIR)\solvemc.obj" : $(SOURCE) $(DEP_CPP_SOLVE) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\spgmr.c
DEP_CPP_SPGMR=\
	".\iterativ.h"\
	".\llnlmath.h"\
	".\llnltyps.h"\
	".\spgmr.h"\
	".\vector.h"\
	

"$(INTDIR)\spgmr.obj" : $(SOURCE) $(DEP_CPP_SPGMR) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\band.c
DEP_CPP_BAND_=\
	".\band.h"\
	".\llnlmath.h"\
	".\llnltyps.h"\
	".\vector.h"\
	

"$(INTDIR)\band.obj" : $(SOURCE) $(DEP_CPP_BAND_) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\funcs.c
DEP_CPP_FUNCS=\
	".\llnltyps.h"\
	

"$(INTDIR)\funcs.obj" : $(SOURCE) $(DEP_CPP_FUNCS) "$(INTDIR)"


# End Source File
# End Target
# End Project
################################################################################
