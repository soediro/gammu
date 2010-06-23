# ---------------------------------------------------------------------------
!if !$d(BCB)
BCB = $(MAKEDIR)\..
!endif

# ---------------------------------------------------------------------------
# IDE SECTION
# ---------------------------------------------------------------------------
# The following section of the project makefile is managed by the BCB IDE.
# It is recommended to use the IDE to change any of the values in this
# section.
# ---------------------------------------------------------------------------

VERSION = BCB.05.03
# ---------------------------------------------------------------------------
PROJECT = Output\gammu.exe
OBJFILES = Output\gammu.obj Output\at.obj Output\atgen.obj Output\cfg.obj \
    Output\coding.obj Output\dct3.obj Output\dct4.obj Output\fbus2.obj \
    Output\alcabus.obj Output\fbusirda.obj Output\gsmback.obj \
    Output\gsmcal.obj Output\gsmcomon.obj Output\gsmlogo.obj Output\gsmnet.obj \
    Output\gsmpbk.obj Output\gsmring.obj Output\gsmsms.obj Output\gsmstate.obj \
    Output\gsmwap.obj Output\irda.obj Output\unixblue.obj Output\mbus2.obj \
    Output\misc.obj Output\n6110.obj Output\n6510.obj Output\n7110.obj \
    Output\n9110.obj Output\nauto.obj Output\alcatel.obj Output\dct3func.obj \
    Output\nfunc.obj Output\pfunc.obj Output\sniff.obj Output\win32.obj
RESFILES = 
MAINSOURCE = gammu.bpf
RESDEPEN = $(RESFILES)
LIBFILES = 
IDLFILES = 
IDLGENFILES = 
LIBRARIES = 
PACKAGES = Vcl50.bpi Vclx50.bpi bcbsmp50.bpi Vcldb50.bpi vclado50.bpi ibsmp50.bpi \
    VCLBDE50.bpi vcldbx50.bpi Qrpt50.bpi TeeUI50.bpi TeeDB50.bpi Tee50.bpi \
    Dss50.bpi TeeQR50.bpi VCLIB50.bpi Vclmid50.bpi vclie50.bpi Inetdb50.bpi \
    Inet50.bpi NMFast50.bpi webmid50.bpi bcbie50.bpi dclocx50.bpi \
    bcb2kaxserver50.bpi
SPARELIBS = 
DEFFILE = 
# ---------------------------------------------------------------------------
PATHCPP = .;..;..\..\common\protocol\at;..\..\common\phone\at;..\..\common\misc;..\..\common\protocol\nokia;..\..\common\protocol\alcatel;..\..\common\service;..\..\common;..\..\common\device\irda;..\..\common\device\bluetoth;..\..\common\phone\nokia\dct3;..\..\common\phone\nokia\dct4;..\..\common\phone\nokia;..\..\common\phone\alcatel;..\..\common\phone;..\..\common\device\serial
PATHASM = .;
PATHPAS = .;
PATHRC = .;
DEBUGLIBPATH = $(BCB)\lib\debug
RELEASELIBPATH = $(BCB)\lib\release
USERDEFINES = WIN32;NDEBUG;_CONSOLE
SYSDEFINES = _NO_VCL;_ASSERTE;NO_STRICT
INCLUDEPATH = ..\;..;..\..\common\device\serial;..\..\common\protocol\alcatel;..\..\common\phone\alcatel;..\..\common\phone;..\..\common\phone\nokia;..\..\common\phone\nokia\dct4;..\..\common\phone\nokia\dct3;..\..\common\device\irda;..\..\common\device\bluetoth;..\..\common;..\..\common\service;..\..\common\protocol\nokia;..\..\common\misc;..\..\common\phone\at;..\..\common\protocol\at;$(BCB)\include;$(BCB)\include\mfc;$(BCB)\include\atl
LIBPATH = ..\..\common\phone\alcatel;..\..\common\protocol\alcatel;..\;..;..\..\common\device\serial;..\..\common\device\bluetoth;..\..\common\phone;..\..\common\phone\nokia;..\..\common\phone\nokia\dct4;..\..\common\phone\nokia\dct3;..\..\common\device\irda;..\..\common;..\..\common\service;..\..\common\protocol\nokia;..\..\common\misc;..\..\common\phone\at;..\..\common\protocol\at;$(BCB)\lib;$(RELEASELIBPATH);$(BCB)\lib\psdk
WARNINGS= -w-par -w-8027 -w-8026 -w-csu
# ---------------------------------------------------------------------------
CFLAG1 = -O2 -w- -VF -X- -a8 -b -k -vi -q -c
IDLCFLAGS = -src_suffix cpp -DWIN32 -DNDEBUG -D_CONSOLE -I..\. -I.. \
    -I..\..\common\device\serial -I..\..\common\phone \
    -I..\..\common\protocol\alcatel -I..\..\common\device\bluetoth \
    -I..\..\common\phone\nokia -I..\..\common\phone\alcatel \
    -I..\..\common\phone\nokia\dct4 -I..\..\common\phone\nokia\dct3 \
    -I..\..\common\device\irda -I..\..\common -I..\..\common\service \
    -I..\..\common\protocol\nokia -I..\..\common\misc -I..\..\common\phone\at \
    -I..\..\common\protocol\at -I$(BCB)\include -I$(BCB)\include\mfc \
    -I$(BCB)\include\atl
PFLAGS = -N2Output -N0Output -$YD
RFLAGS = /l 0x415 /d "NDEBUG" /i$(BCB)\include;$(BCB)\include\mfc
AFLAGS = /mx /w2 /zd
LFLAGS = -IOutput -D"" -ap -Tpe -x -Gn -v -q
# ---------------------------------------------------------------------------
ALLOBJ = c0x32.obj $(OBJFILES)
ALLRES = $(RESFILES)
ALLLIB = $(LIBFILES) $(LIBRARIES) import32.lib cw32.lib
# ---------------------------------------------------------------------------
!ifdef IDEOPTIONS

[Version Info]
IncludeVerInfo=0
AutoIncBuild=0
MajorVer=1
MinorVer=0
Release=0
Build=0
Debug=0
PreRelease=0
Special=0
Private=0
DLL=0

[Version Info Keys]
CompanyName=
FileDescription=
FileVersion=1.0.0.0
InternalName=
LegalCopyright=
LegalTrademarks=
OriginalFilename=
ProductName=
ProductVersion=1.0.0.0
Comments=

[Debugging]
DebugSourceDirs=$(BCB)\source\vcl

!endif





# ---------------------------------------------------------------------------
# MAKE SECTION
# ---------------------------------------------------------------------------
# This section of the project file is not used by the BCB IDE.  It is for
# the benefit of building from the command-line using the MAKE utility.
# ---------------------------------------------------------------------------

.autodepend
# ---------------------------------------------------------------------------
!if "$(USERDEFINES)" != ""
AUSERDEFINES = -d$(USERDEFINES:;= -d)
!else
AUSERDEFINES =
!endif

!if !$d(BCC32)
BCC32 = bcc32
!endif

!if !$d(CPP32)
CPP32 = cpp32
!endif

!if !$d(DCC32)
DCC32 = dcc32
!endif

!if !$d(TASM32)
TASM32 = tasm32
!endif

!if !$d(LINKER)
LINKER = ilink32
!endif

!if !$d(BRCC32)
BRCC32 = brcc32
!endif


# ---------------------------------------------------------------------------
!if $d(PATHCPP)
.PATH.CPP = $(PATHCPP)
.PATH.C   = $(PATHCPP)
!endif

!if $d(PATHPAS)
.PATH.PAS = $(PATHPAS)
!endif

!if $d(PATHASM)
.PATH.ASM = $(PATHASM)
!endif

!if $d(PATHRC)
.PATH.RC  = $(PATHRC)
!endif
# ---------------------------------------------------------------------------
$(PROJECT): $(IDLGENFILES) $(OBJFILES) $(RESDEPEN) $(DEFFILE)
    $(BCB)\BIN\$(LINKER) @&&!
    $(LFLAGS) -L$(LIBPATH) +
    $(ALLOBJ), +
    $(PROJECT),, +
    $(ALLLIB), +
    $(DEFFILE), +
    $(ALLRES)
!
# ---------------------------------------------------------------------------
.pas.hpp:
    $(BCB)\BIN\$(DCC32) $(PFLAGS) -U$(INCLUDEPATH) -D$(USERDEFINES);$(SYSDEFINES) -O$(INCLUDEPATH) --BCB {$< }

.pas.obj:
    $(BCB)\BIN\$(DCC32) $(PFLAGS) -U$(INCLUDEPATH) -D$(USERDEFINES);$(SYSDEFINES) -O$(INCLUDEPATH) --BCB {$< }

.cpp.obj:
    $(BCB)\BIN\$(BCC32) $(CFLAG1) $(WARNINGS) -I$(INCLUDEPATH) -D$(USERDEFINES);$(SYSDEFINES) -n$(@D) {$< }

.c.obj:
    $(BCB)\BIN\$(BCC32) $(CFLAG1) $(WARNINGS) -I$(INCLUDEPATH) -D$(USERDEFINES);$(SYSDEFINES) -n$(@D) {$< }

.c.i:
    $(BCB)\BIN\$(CPP32) $(CFLAG1) $(WARNINGS) -I$(INCLUDEPATH) -D$(USERDEFINES);$(SYSDEFINES) -n. {$< }

.cpp.i:
    $(BCB)\BIN\$(CPP32) $(CFLAG1) $(WARNINGS) -I$(INCLUDEPATH) -D$(USERDEFINES);$(SYSDEFINES) -n. {$< }

.asm.obj:
    $(BCB)\BIN\$(TASM32) $(AFLAGS) -i$(INCLUDEPATH:;= -i) $(AUSERDEFINES) -d$(SYSDEFINES:;= -d) $<, $@

.rc.res:
    $(BCB)\BIN\$(BRCC32) $(RFLAGS) -I$(INCLUDEPATH) -D$(USERDEFINES);$(SYSDEFINES) -fo$@ $<
# ---------------------------------------------------------------------------



