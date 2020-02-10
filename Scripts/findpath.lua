print "AMAI 2.54"
print "Powered by Grimoire 1.5 2/21/2008 (1.24b err support)"

grimregpath = "Software\\Grimoire"
key = "HKEY_CURRENT_USER\\Software\\Blizzard Entertainment\\Warcraft III"
val = "InstallPath"
path = grim.getregpair(key,val)

-- uncomment to force path
--path = "C:\\Warcraft III"

if not grim.exists(path.."\\worldedit.exe") then
	val = "InstallPathX"
	path = grim.getregpair(key,val)
end
if not grim.exists(path.."\\worldedit.exe") then
	key = "HKEY_LOCAL_MACHINE\\Software\\Blizzard Entertainment\\Warcraft III"
	val = "InstallPath"
	path = grim.getregpair(key,val)
end
if not grim.exists(path.."\\worldedit.exe") then
	val = "InstallPathX"
	path = grim.getregpair(key,val)
end
if not grim.exists(path.."\\worldedit.exe") then
	key = grimregpath
	val = "War3InstallPath"
	path = grim.getregpair(key,val)
end
if not grim.exists(path.."\\worldedit.exe") then
	path = grim.browse("Select Directory Warcraft is Installed to")
	if not grim.exists(path.."\\worldedit.exe") then
		grim.messagebox("Could not locate warcraft","Exehack",false)
	else
		grim.setregstring(grimregpath,"War3InstallPath",path)
	end
end
