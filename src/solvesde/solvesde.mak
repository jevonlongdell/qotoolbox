# Microsoft Developer Studio Generated NMAKE File, Format Version 4.20
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

!IF "$(CFG)" == ""
CFG=solvesde - Win32 Debug
!MESSAGE No configuration specified.  Defaulting to solvesde - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "solvesde - Win32 Release" && "$(CFG)" !=\
 "solvesde - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "solvesde.mak" CFG="solvesde - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "solvesde - Win32 Release" (based on\
 "Win32 (x86) Console Application")
!MESSAGE "solvesde - Win32 Debug" (based on "Win32 (x86) Console Application")
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
# PROP Target_Last_Scanned "solvesde - Win32 Debug"
RSC=rc.exe
CPP=cl.exe

!IF  "$(CFG)" == "solvesde - Win32 Release"

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

ALL : "$(OUTDIR)\solvesde.exe"

CLEAN : 
	-@erase "$(INTDIR)\com.obj"
	-@erase "$(INTDIR)\cvdiag.obj"
	-@erase "$(INTDIR)\cvodenew.obj"
	-@erase "$(INTDIR)\funcs.obj"
	-@erase "$(INTDIR)\linpack.obj"
	-@erase "$(INTDIR)\llnlmath.obj"
	-@erase "$(INTDIR)\ranlib.obj"
	-@erase "$(INTDIR)\solvesde.obj"
	-@erase "$(INTDIR)\vector.obj"
	-@erase "$(OUTDIR)\solvesde.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /YX /c
# ADD CPP /nologo /W1 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /YX /c
CPP_PROJ=/nologo /ML /W1 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE"\
 /Fp"$(INTDIR)/solvesde.pch" /YX /Fo"$(INTDIR)/" /c 
CPP_OBJS=.\Release/
CPP_SBRS=.\.
# ADD BASE RSC /l 0x1409 /d "NDEBUG"
# ADD RSC /l 0x1409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/solvesde.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib\
 odbccp32.lib /nologo /subsystem:console /incremental:no\
 /pdb:"$(OUTDIR)/solvesde.pdb" /machine:I386 /out:"$(OUTDIR)/solvesde.exe" 
LINK32_OBJS= \
	"$(INTDIR)\com.obj" \
	"$(INTDIR)\cvdiag.obj" \
	"$(INTDIR)\cvodenew.obj" \
	"$(INTDIR)\funcs.obj" \
	"$(INTDIR)\linpack.obj" \
	"$(INTDIR)\llnlmath.obj" \
	"$(INTDIR)\ranlib.obj" \
	"$(INTDIR)\solvesde.obj" \
	"$(INTDIR)\vector.obj"

"$(OUTDIR)\solvesde.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "solvesde - Win32 Debug"

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

ALL : "$(OUTDIR)\solvesde.exe"

CLEAN : 
	-@erase "$(INTDIR)\com.obj"
	-@erase "$(INTDIR)\cvdiag.obj"
	-@erase "$(INTDIR)\cvodenew.obj"
	-@erase "$(INTDIR)\funcs.obj"
	-@erase "$(INTDIR)\linpack.obj"
	-@erase "$(INTDIR)\llnlmath.obj"
	-@erase "$(INTDIR)\ranlib.obj"
	-@erase "$(INTDIR)\solvesde.obj"
	-@erase "$(INTDIR)\vc40.idb"
	-@erase "$(INTDIR)\vc40.pdb"
	-@erase "$(INTDIR)\vector.obj"
	-@erase "$(OUTDIR)\solvesde.exe"
	-@erase "$(OUTDIR)\solvesde.ilk"
	-@erase "$(OUTDIR)\solvesde.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

# ADD BASE CPP /nologo /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /YX /c
# ADD CPP /nologo /W1 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /YX /c
CPP_PROJ=/nologo /MLd /W1 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE"\
 /Fp"$(INTDIR)/solvesde.pch" /YX /Fo"$(INTDIR)/" /Fd"$(INTDIR)/" /c 
CPP_OBJS=.\Debug/
CPP_SBRS=.\.
# ADD BASE RSC /l 0x1409 /d "_DEBUG"
# ADD RSC /l 0x1409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/solvesde.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386
LINK32_FLAGS=kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib\
 advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib\
 odbccp32.lib /nologo /subsystem:console /incremental:yes\
 /pdb:"$(OUTDIR)/solvesde.pdb" /debug /machine:I386\
 /out:"$(OUTDIR)/solvesde.exe" 
LINK32_OBJS= \
	"$(INTDIR)\com.obj" \
	"$(INTDIR)\cvdiag.obj" \
	"$(INTDIR)\cvodenew.obj" \
	"$(INTDIR)\funcs.obj" \
	"$(INTDIR)\linpack.obj" \
	"$(INTDIR)\llnlmath.obj" \
	"$(INTDIR)\ranlib.obj" \
	"$(INTDIR)\solvesde.obj" \
	"$(INTDIR)\vector.obj"

"$(OUTDIR)\solvesde.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
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

# Name "solvesde - Win32 Release"
# Name "solvesde - Win32 Debug"

!IF  "$(CFG)" == "solvesde - Win32 Release"

!ELSEIF  "$(CFG)" == "solvesde - Win32 Debug"

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

SOURCE=.\cvdiag.c
DEP_CPP_CVDIA=\
	".\cvdiag.h"\
	".\cvodenew.h"\
	".\llnltyps.h"\
	".\vector.h"\
	

"$(INTDIR)\cvdiag.obj" : $(SOURCE) $(DEP_CPP_CVDIA) "$(INTDIR)"


# End Source File
################################################################################
# Begin Source File

SOURCE=.\cvodenew.c
DEP_CPP_CVODE=\
	".\cvodenew.h"\
	".\llnlmath.h"\
	".\llnltyps.h"\
	".\vector.h"\
	

"$(INTDIR)\cvodenew.obj" : $(SOURCE) $(DEP_CPP_CVODE) "$(INTDIR)"


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

SOURCE=.\solvesde.c
DEP_CPP_SOLVE=\
	".\cvdiag.h"\
	".\cvodenew.h"\
	".\llnltyps.h"\
	".\ranlib.h"\
	".\vector.h"\
	

"$(INTDIR)\solvesde.obj" : $(SOURCE) $(DEP_CPP_SOLVE) "$(INTDIR)"


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

SOURCE=.\funcs.c
DEP_CPP_FUNCS=\
	".\llnltyps.h"\
	

"$(INTDIR)\funcs.obj" : $(SOURCE) $(DEP_CPP_FUNCS) "$(INTDIR)"


# End Source File
# End Target
# End Project
################################################################################
