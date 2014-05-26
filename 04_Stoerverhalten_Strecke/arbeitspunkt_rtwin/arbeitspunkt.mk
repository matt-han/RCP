# Abstract:
#	Real-Time Workshop template makefile for building Real-Time Windows
#	Target compatible real-time version of Simulink model using generated
#       C code and the built-in Open Watcom C/C++ Compiler.
#
#       The following defines (macro names) can be used to modify the behavior
#       of the build:
#	  OPT_OPTS       - Optimization option.
#	  OPTS           - User specific options.
#         CPP_OPTS       - C++ Compiler Options
#	  USER_OBJS      - Additional user objects, such as files needed by
#			   S-functions.
#         USER_PATH      - The directory path to the source (.c) files which
#                          are used to create any .obj files specified in
#                          USER_OBJS. Multiple paths must be separated
#                          with a semicolon. For example:
#                          "USER_PATH=path1;path2"
#	  USER_INCLUDES  - Additional include paths (i.e.
#			   "USER_INCLUDES=-Iinclude-path1 -Iinclude-path2")
#
#       Consider using "Real-Time Windows Target build options" page in RTW
#       options dialog instead of trying to change OPT_OPTS here.
#
#       In particular, note how the quotes are before the name of the macro
#       name.
#
#       This template makefile is designed to be used with a system target
#       file that contains 'rtwgensettings.ProjectDirSuffix' see grt.tlc
#
# $Revision: 1.1.6.14 $  $Date: 2007/06/04 21:15:08 $  $Author: batserve $
# Copyright 1994-2007 The MathWorks, Inc.
#



#------------------------ Macros read by make_rtw -----------------------------
#
# The following macros are read by the Real-Time Workshop build procedure:
#  MAKECMD         - This is the command used to invoke the make utility
#  HOST            - What platform this template makefile is targeted for
#                    (i.e. PC or UNIX)
#  BUILD           - Invoke make from the Real-Time Workshop build procedure
#                    (yes/no)?
#  SYS_TARGET_FILE - Name of system target file.
#
MAKECMD         = "%RTWIN%\openwat\binnt\wmake"
HOST            = PC
BUILD           = yes
SYS_TARGET_FILE = rtwin.tlc


#---------------------- Tokens expanded by make_rtw ---------------------------
#
# The following tokens, when wrapped with "|>" and "<|" are expanded by the
# Real-Time Workshop build procedure.
#
#  MODEL_NAME        - Name of the Simulink block diagram
#  MODEL_MODULES_OBJ - Object file name for any additional generated source
#                      modules
#  MAKEFILE_NAME     - Name of makefile created from template makefile
#                      <model>.mk
#  MATLAB_ROOT       - Path to were MATLAB is installed.
#  MATLAB_BIN        - Path to MATLAB executable.
#  S_FUNCTIONS_LIB   - List of S-functions libraries to link.
#  S_FUNCTIONS_OBJ   - List of S-functions .obj sources
#  SOLVER_OBJ        - Solver object file name
#  NUMST             - Number of sample times
#  TID01EQ           - yes (1) or no (0): Are sampling rates of continuous
#                      task (tid=0) and 1st discrete task equal.
#  NCSTATES          - Number of continuous states
#  BUILDARGS         - Options passed in at the command line.
#  MULTITASKING      - yes (1) or no (0): Is solver mode multitasking
#  EXT_MODE          - yes (1) or no (0): Build for external mode
#  EXTMODE_TRANSPORT - Name of transport mechanism (e.g. tcpip, serial) for extmode
#  EXTMODE_STATIC      - yes (1) or no (0): Use static instead of dynamic mem alloc.
#  EXTMODE_STATIC_SIZE - Size of static memory allocation buffer.
#  CC_OPTIMIZE       - yes (1) or no (0): Generate optimized code
#  CC_LISTING        - yes (1) or no (0): Generate assembly listings
#  REBUILD_ALL       - yes (1) or no (0): Rebuild all files

MODEL               = arbeitspunkt
MODULES_OBJ         = arbeitspunkt_data.obj 
MAKEFILE            = arbeitspunkt.mk
MATLAB_ROOT         = C:\PROGRA~1\MATLAB\R2007b
MATLAB_BIN          = C:\PROGRA~1\MATLAB\R2007b\bin
S_FUNCTIONS         = 
S_FUNCTIONS_LIB     = 
SOLVER              = 
NUMST               = 2
TID01EQ             = 1
NCSTATES            = 0
BUILDARGS           =  GENERATE_REPORT=0 TMW_EXTMODE_TESTING=0 MODELLIB=arbeitspunktlib.lib RELATIVE_PATH_TO_ANCHOR=.. MODELREF_TARGET_TYPE=NONE
MULTITASKING        = 0
EXT_MODE            = 1
EXTMODE_TRANSPORT   = 0
EXTMODE_STATIC      = 1
EXTMODE_STATIC_SIZE = 1000000
CC_OPTIMIZE         = 1
CC_LISTING          = 0
REBUILD_ALL         = 1


#--------------------------------- Tool Locations -----------------------------
#
RTWIN = $(MATLAB_ROOT)\toolbox\rtw\targets\rtwin
OPENWAT = $(RTWIN)\openwat
CC = wcc386
CPP = wpp386
AS = wasm
DISAS = wdis
LD = wlink
LIBCMD = wlib -q
PERL = $(MATLAB_ROOT)\sys\perl\win32\bin\perl


#------------------------ External mode ---------------------------------------
# To add a new transport layer, see the comments in
#   <matlabroot>/toolbox/simulink/simulink/extmode_transports.m
!ifeq EXT_MODE 1
EXT_CC_OPTS_GEN = -DEXT_MODE
!ifeq EXTMODE_STATIC 1
EXT_OBJ_MEM     = mem_mgr.obj
EXT_CC_OPTS_MEM = -DEXTMODE_STATIC -DEXTMODE_STATIC_SIZE=$(EXTMODE_STATIC_SIZE)
!else
EXT_OBJ_MEM     = 
EXT_CC_OPTS_MEM = 
!endif
EXTMODE_PATH    = $(MATLAB_ROOT)\rtw\c\src\ext_mode\common;$(MATLAB_ROOT)\rtw\c\src\ext_mode\custom;
EXT_OBJ         = $(EXT_OBJ_MEM)
EXT_CC_OPTS     = $(EXT_CC_OPTS_GEN) $(EXT_CC_OPTS_MEM)
!else
EXTMODE_PATH  =
EXT_OBJ       =
EXT_CC_OPTS   =
!endif


#------------------------------ Include Path -----------------------------

MATLAB_INCLUDES = &
$(MATLAB_ROOT)\simulink\include;&
$(MATLAB_ROOT)\extern\include;&
$(MATLAB_ROOT)\rtw\c\src;&
$(RTWIN)\src;&
$(MATLAB_ROOT)\rtw\c\src\ext_mode\common;

# Additional includes
ADD_INCLUDES = &
C:\DOKUME~1\Student\EIGENE~1\MATLAB\LABORG~2\04_STO~1\ARBEIT~1;&
C:\DOKUME~1\Student\EIGENE~1\MATLAB\LABORG~2\04_STO~1;&
$(MATLAB_ROOT)\rtw\c\libsrc;&


COMPILER_INCLUDES = $(OPENWAT)\include

INCLUDES = .;$(MATLAB_INCLUDES)$(ADD_INCLUDES)$(COMPILER_INCLUDES)

#-------------------------------- C Flags --------------------------------

# General Compiler Options
REQ_OPTS = -zq -ei -zp8 -6r -fpi87 -zl -wx
CC_REQ_OPTS = -wcd=302 -wcd=1180
CPP_REQ_OPTS = -wcd=139 -wcd=367 -wcd=389 -wcd=726

# Optimization Options.
# Change OPT_OPTS but never DEFAULT_OPT_OPTS !!!
!ifeq CC_OPTIMIZE 1
!ifeq CC_LISTING 1
DEFAULT_OPT_OPTS = -oneatxh -d1
!else
DEFAULT_OPT_OPTS = -oneatxh
!endif
!else
!ifeq CC_LISTING 1
DEFAULT_OPT_OPTS = -od -d2
!else
DEFAULT_OPT_OPTS = -od
!endif
!endif
OPT_OPTS = $(DEFAULT_OPT_OPTS)

CC_OPTS = -DUSE_RTMODEL $(REQ_OPTS) $(OPT_OPTS) $(OPTS) $(EXT_CC_OPTS)

CPP_REQ_DEFINES = -DMODEL=$(MODEL) -DRT -DNUMST=$(NUMST) &
                  -DTID01EQ=$(TID01EQ) -DNCSTATES=$(NCSTATES) &
                  -DMT=$(MULTITASKING)

CFLAGS = $(CC_REQ_OPTS) $(CC_OPTS) $(CPP_REQ_DEFINES) $(USER_INCLUDES)
CPPFLAGS = $(CPP_REQ_OPTS) $(CPP_OPTS) $(CC_OPTS) $(CPP_REQ_DEFINES) $(USER_INCLUDES)

#------------------------------- Source Files ---------------------------------

REQ_OBJS  = $(MODEL).obj $(MODULES_OBJ) rt_stub.obj rt_sim.obj rt_nonfinite.obj
USER_OBJS =

OBJS = $(REQ_OBJS) $(USER_OBJS) $(S_FUNCTIONS) $(SOLVER) $(EXT_OBJ)

#---------------------------- Additional Libraries ----------------------------

LIBS = 

!ifeq OPT_OPTS $(DEFAULT_OPT_OPTS)
LIBS += $(MATLAB_ROOT)\rtw\c\lib\win32\rtwlib_rtwin_openwat.lib
!else
LIBS += rtwlib.lib
!endif



RTWINTGTLIB = $(RTWIN)\lib\rtmodwat.lib

#-------------------------- Source Path ---------------------------------------

# User source path

!ifdef USER_PATH
EXTRA_PATH = ;$(USER_PATH)
!else
EXTRA_PATH =
!endif

# Additional sources

ADD_SOURCES = $(MATLAB_ROOT)\rtw\c\src;$(MATLAB_ROOT)\rtw\c\libsrc;

# Source Path

.c :   ..;$(RTWIN)\src;$(MATLAB_ROOT)\rtw\c\src;$(MATLAB_ROOT)\simulink\src;$(EXTMODE_PATH)$(ADD_SOURCES)$(EXTRA_PATH)
.cpp : ..;$$(RTWIN)\src;(MATLAB_ROOT)\rtw\c\src;$(MATLAB_ROOT)\simulink\src;$(EXTMODE_PATH)$(ADD_SOURCES)$(EXTRA_PATH)

#----------------------- Exported Environment Variables -----------------------
#
#  Setup path for tools.
#
PATH = $(OPENWAT)\binnt

#--------------------------------- Rules --------------------------------------

!loaddll wcc386 wccd386
!loaddll wpp386 wppd386
!loaddll wlink  wlink
!loaddll wlib   wlibd


.ERASE

.BEFORE
	@set path=$(PATH)
	@set INCLUDE=$(INCLUDES)
	@set WATCOM=$(OPENWAT)
	@set MATLAB=$(MATLAB_ROOT)
!ifeq REBUILD_ALL 1
	@echo $#$#$# Rebuilding all object files ...
        @if exist ..\$(MODEL).rwd @del ..\$(MODEL).rwd
        @if exist *.lnk @del *.lnk
        @if exist *.obj @del *.obj
        @if exist *.lst @del *.lst
        @if exist *.lib @del *.lib
!endif

..\$(MODEL).rwd : $(OBJS) $(LIBS) $(MODEL).lnk
	$(LD) NAME $@ $(LDFLAGS) @$(MODEL).lnk
	@echo $#$#$# Created Real-Time Windows Target module $(MODEL).rwd.
	@del $(MODEL).lnk

$(MODEL).lnk : $(MAKEFILE)
  @echo.
  @echo    Creating linker response file $@
  @%create $@
  @%append $@ FORMAT windows nt dll
  @%append $@ RUNTIME native=2.00
  @%append $@ EXPORT Header=_Header
  @%append $@ EXPORT Inquiry=_Inquiry
  @%append $@ EXPORT Disable=_Disable
  @%append $@ EXPORT Enable=_Enable
  @%append $@ EXPORT GetBoards=_GetBoards
  @%append $@ OPTION caseexact
  @%append $@ OPTION quiet
!ifeq CC_LISTING 1
  @%append $@ OPTION map
!endif
  @%append $@ DISABLE 14
  @%append $@ DISABLE 1027
  @for %i in ($(OBJS)) do @%append $@ FILE %i
  @%append $@ LIBRARY $(RTWINTGTLIB)
  @%append $@ LIBRARY $(OPENWAT)\lib386\math387r
  @%append $@ LIBRARY $(OPENWAT)\lib386\clib3r
  @%append $@ LIBRARY $(OPENWAT)\lib386\plib3r
  @for %i in ($(LIBS)) do @%append $@ LIBRARY %i

.c.obj:
	@echo $#$#$# Compiling $[@
	$(CC) $(CFLAGS) $[@
!ifeq CC_LISTING 1
	$(DISAS) -l -s $^@
!endif

.cpp.obj:
	@echo $#$#$# Compiling $[@
	$(CPP) $(CPPFLAGS) $[@
!ifeq CC_LISTING 1
	$(DISAS) -l -s $^@
!endif

$(OBJS) : $(MAKEFILE) rtw_proj.tmw .AUTODEPEND

# Libraries:



MODULES_rtwlib = &
    rt_backsubcc_dbl.obj &
    rt_backsubcc_sgl.obj &
    rt_backsubrc_dbl.obj &
    rt_backsubrc_sgl.obj &
    rt_backsubrr_dbl.obj &
    rt_backsubrr_sgl.obj &
    rt_enab.obj &
    rt_forwardsubcc_dbl.obj &
    rt_forwardsubcc_sgl.obj &
    rt_forwardsubcr_dbl.obj &
    rt_forwardsubcr_sgl.obj &
    rt_forwardsubrc_dbl.obj &
    rt_forwardsubrc_sgl.obj &
    rt_forwardsubrr_dbl.obj &
    rt_forwardsubrr_sgl.obj &
    rt_look.obj &
    rt_look1d.obj &
    rt_look1d32.obj &
    rt_look2d32_general.obj &
    rt_look2d32_normal.obj &
    rt_look2d_general.obj &
    rt_look2d_normal.obj &
    rt_look32.obj &
    rt_lu_cplx.obj &
    rt_lu_cplx_sgl.obj &
    rt_lu_real.obj &
    rt_lu_real_sgl.obj &
    rt_matdivcc_dbl.obj &
    rt_matdivcc_sgl.obj &
    rt_matdivcr_dbl.obj &
    rt_matdivcr_sgl.obj &
    rt_matdivrc_dbl.obj &
    rt_matdivrc_sgl.obj &
    rt_matdivrr_dbl.obj &
    rt_matdivrr_sgl.obj &
    rt_matmultandinccc_dbl.obj &
    rt_matmultandinccc_sgl.obj &
    rt_matmultandinccr_dbl.obj &
    rt_matmultandinccr_sgl.obj &
    rt_matmultandincrc_dbl.obj &
    rt_matmultandincrc_sgl.obj &
    rt_matmultandincrr_dbl.obj &
    rt_matmultandincrr_sgl.obj &
    rt_matmultcc_dbl.obj &
    rt_matmultcc_sgl.obj &
    rt_matmultcr_dbl.obj &
    rt_matmultcr_sgl.obj &
    rt_matmultrc_dbl.obj &
    rt_matmultrc_sgl.obj &
    rt_matmultrr_dbl.obj &
    rt_matmultrr_sgl.obj &
    rt_sat_div_int16.obj &
    rt_sat_div_int32.obj &
    rt_sat_div_int8.obj &
    rt_sat_div_uint16.obj &
    rt_sat_div_uint32.obj &
    rt_sat_div_uint8.obj &
    rt_sat_prod_int16.obj &
    rt_sat_prod_int32.obj &
    rt_sat_prod_int8.obj &
    rt_sat_prod_uint16.obj &
    rt_sat_prod_uint32.obj &
    rt_sat_prod_uint8.obj &


rtwlib.lib : rtw_proj.tmw $(MAKEFILE) $(MODULES_rtwlib)
	@echo $#$#$# Creating $@
	@if exist $@ @del $@
	@for %i in ($(MODULES_rtwlib)) do $(LIBCMD) $@ +%i
	@echo $#$#$# Created $@


