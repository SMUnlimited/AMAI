nopause = true			-- no pausing in single player
profiling = false		-- when on, call LogJASSCalls

-- bytecodetrace: enables either bytecode tracer
bytecodetrace = false 
-- bytecodetracefast:  mmap'd log/oldlog each 64kB long
-- if off, then writes forever to one file
bytecodetracefast = true
-- for bytecodetracefast=false, specifies whether to flush.  use this to pick up crashes.
-- if bytecodetrace=true, does nothing
bytecodeflush = false

btonerr = true			-- include back trace on errors
btonerrlen = 5			-- number of functions to trace back

debugger = true			-- enable debugging engine