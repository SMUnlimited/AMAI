-- Load libraries here that need to run after game.dll loads but after
-- native registration
-- e.g. war3err, japi, user created natives

--if getregpair("Software\\Grimoire\\","Enable war3err") == "on" then
	loaddll("bin\\war3err.dll")
	--loaddll("bin\\loadmpq.dll")
--end
--loaddll("bin\\japi.dll")
--loaddll("bin\\nativepack.dll") -- requires japi.dll
--loaddll("bin\\warsoc.dll")
--loaddll("bin\\war3lua.dll")
