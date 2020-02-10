-- Inject DLLs that can run as soon as warcraft starts here
-- things that need to run right after game.dll loads should be added to
-- ongameload.lua with ongameload.dll injected

 grim.injectdll(proc,"bin\\ongameload.dll")
-- grim.injectdll(proc,"bin\\listfile.dll")
-- grim.injectdll(proc,"bin\\nreplace.dll")
-- grim.injectdll(proc,"bin\\loadmpq.dll")
