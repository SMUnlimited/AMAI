Grimoire 1.5 2/21/08
http://www.wc3campaigns.net/showthread.php?t=86652

Contributors:
Bryan "PipeDream" Steinbach - bsteinbach@berkeley.edu
Andy "xttocs" Scott
Mike "PitzerMike" Pitzer
Victor "Vexorian" Soliz
Nikolaj "MindWorX" Mariager


Collection of utilities for using warcraft hacks
see other text files in this directory for descriptions of utilities

Quickstart:
Run startwar3.bat or we.bat to begin

Source available via SVN at:
https://w3grimoire.svn.sourceforge.net/svnroot/w3grimoire

Changelog:
1.5:
 Reworked loader for 1.21b compatibility (xttocs)
  we DLLs now loaded by auxiliary "weload.dll", which runs we.conf.lua.
  old ongameload.dll used for same purpose for war3

1.4:
 findpath.lua bug fix for warcraft not found in registry
 Cheat("war3err_PauseTracer")/Cheat("war3err_ContinueTracer")
 PitzerMike:
  increase map size to 480x480 directly in the editor
  input custom object IDs when you create an object
  improved international support
  Customize test map settings
  


1.3:
nativepack: new native CallByName.
  To use it:
  call InitNatives()
  call CallByName("somefunction")
  call prototypefunction(string arg1, int arg2)
  This replaces the call to prototypefunction with somefunction dynamically.
  It replaces the next instance of a JASS call, so if you do:
  call foo(bar())
  it will replace the call to bar, not foo.
  the argument types don't have to be the same, but the number should be.
  the replacement is immediate, permanent.
  It scans downward, stopping at the end of the current function.
  It ignores native calls while scanning.
  You need to call InitNatives() once per map run before you use CallByName().

w3jdebug:
 debugger = true in war3err.lua
 Cheat("war3err_Break") to set a breakpoint
 Once warcraft reaches a breakpoint and freezes, start a debugging client
 two debugging clients:  w3jdebug (console) pyw3jdebug.py (GUI)
  pyw3jdebug requires python 2.5, wxPython 2.8, pythoncard 0.8.2
 current commands:
  run
  step
  disas
  getvarval <var>
  funcname
  opnum
  locals
  addbp
  delbp
  listbp
  backtrace
  stack

Cheat("DebugMsg: "+msg) prints to log\\war3erruser.txt

Added backtraces to the usual error messages.  Configure with btonerr and btonerrlen in war3err.lua.
btonerr = false restores the one function behavior.

Cheat("war3err_LocalHTSize") reports size of global hashtable
Cheat("war3err_GlobalHTSize") reports size of local hashtable
Cheat("war3err_DumpLocalHT") prints local hash table to war3err log
Cheat("war3err_DumpGlobalHT") prints global hash table to war3err log

lua upgraded to 5.1.2
wehack.mapmodified() reports if WE thinks the map has been modified
RemoveLocation(-1)/DestroyGroup(-1) report info instead of null, null spouts warning
nopause working again in single player
Removed max op count logging (thread death still detected)
Profiling (LogJASSCalls()/LogVariableUse()) a war3err.lua option

1.2:
Menus for Mike's grimext pack embedded
Saving map on longer necessary for test map
More control code farmed out to lua - add your own tools to the menus easily, see example for jasshelper or mike's tools.
ongameload.dll / ongameload.lua - war3err.dll, japi.dll should be loaded from ongameload.dll via ongameload.lua
split nativepack.dll out of japi.dll
war3err.lua replaces war3err.conf
war3err can be enabled/disabled from grimoire menu

function compilemap() in wehack.lua is executed when map compilation is enabled, before running mapcompiler.exe.  Soon mapcompiler execution will be shuffled into lua so you can do order yourself.
function testmap() in wehack.lua is run when testmap is clicked.


1.1d:
Configuration GUI actually included
wehack.lua added for adding custom menu entries
loadmpq.conf switched with loadmpq.lua - now supports paths with spaces
setregstring(key,value,str) and setregdword(key,value,dword) added to lua files

1.1c:
Configuration GUI - wxLua 2.8
NoLimits absorbed into wehack
common.j / native prototypes synced
DebugPrint fixed, must have been broken since 1.1a
exehack should now play nicely with rootkits like AV programs

1.1b:
war3err.dll:  speed improvement of bytecode logging.  If I missed some possible crash causes it might not log the last few bytecodes.
we.lua:  Updated No-Limits to 1.21 (thanks PitzerMike)

1.1a:
war3err.dll: now logs via popen on logd.exe.  Sample logd.exe writes last 1000 lines to bytecode.txt when warcraft crashes/exits.

1.1:
all:  should give much better error messages now that exception handling works
wehack.dll:  --configure option added for mapcompiler
jAPI.dll:  added DebugPrint() native
war3err.dll:  new conf file war3err.conf
	currently has two options
	nopause = on and bytecodetrace = on
	nopause prevents warcraft from pausing, i.e. when alt tabbing
	helps when you want to walk away and let something run for awhile
	bytecodetrace fills bytecode.txt with each opcode warcraft executes.  This file will grow BIG!
	notes types and names of operations along with the function in which the op resides
	Good for getting a look under the hood into the VM or determining where warcraft stops executing on a crash.



1.0:
all: Improved patch independence & multiple map support
war3err.dll:  
  Uninitialized var use prints name of var in addition to function
  Player(Invalid number) Is replaced with Player(0) and an error message
  rudimentary leak tracing of groups/locations
    call DestroyGroup(null) to report function with most created and not destroyed groups
    call RemoveLocation(null) for same purpose
    reports attempted double frees
  ExecuteFunc("non void func") reports error instead of crashing
    distinguishes between functions that don't exist and those with args
wehack.dll: 
  --nopreprocessor menu option added for mapcompiler

0.7b:
mapcompiler exit codes interpreted correctly
Added option to test map by running startwar3.bat to allow you to use whichever hacks
Forced another case of triggers being un enable able when there are syntax errors in custom script

0.7:
war3err.dll:  prints red error messages in game
wehack.dll: configure hacks from WE menu
Extracts common.j / Blizzard.j from map / warcraft
Runs user supplied mapcompiler in grimoire folder with generated map as argument if option is enabled
Use mpqutils if you want to work with war3map.j
Return 0:  Allow test map
Return other:  Disallow test map 

0.6:
ListFile.dll:  Reports all files opened in .mpq by world editor or warcraft.  can use to build archive listfiles.
Loadmpq opens .conf from working directory at exehack startup

0.5c:
loadmpq finally works with gcc
errors now reported through dialog boxes

0.5b:
Fixed CPU thrashing
Added war3err.dll, which detects:
- Divide by zero
- Uninitialized var use
- Op limit overrun
If one of these occurs during JASS executing, the offending function is noted in war3err.txt

0.5:
DLL injection made more reliable
Warcraft found via registry-  now completely path free.  if you don't have warcraft installed, manually set path
Removed pjass integration
Added source for a JAPI implementation
loadmpq occasionally not working should be fixed
ported to mingw/GCC and nasm.

0.4b:
renamed lots of stuff
added some documentation
added loadmpq.dll for overriding war3patch.mpq

0.4a:
added utilities for adding/deleting mpq files

0.4:
embedded lua
added DLL injection
e.g. can use jAPI.dll from test map button (not included)
pjass 0.99 included

0.3a:
fixed command line argument problem
made a nicer tmap.bat that pops up notepad if there are script errors

0.3:
support for 1.20c - 1.20e
allows one to always enable disabled triggers
removes nag dialog when saving with default map description
get rid of prepend with war3mapImported on imported files
execute tmap.bat instead of war3.exe by default
disable syntax checking


Compiling:
I use mingw 5.0.2 (g++ 3.4.2), nasm 0.98.39 and scons 0.96.94.  New scons are broken for mingw.
You'll need python for scons.
copy nasmw.exe to mingw\bin\
Add mingw\bin\; to the path (Control panel -> System -> Advanced -> Environment Variables -> System Variables -> Path)
Add Python25\ to the path (version number irrelevant)
where python/mingw are the directories you installed each to
Type scons in the grimoire directory to compile


Known bugs:
war3mapImported prefix will return while you open the map without the loader

Includes Lua 5.1 http://www.lua.org/


Thanks to
PitzerMike / Vexorian for original windowwe concept and implementation
Zoxc and his WEHelper for keeping me on my toes with competition