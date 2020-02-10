-- Use loadmpq(priority,mappath) to load mpqs
-- e.g. loadmpq(10,"C:\\War3\\Maps\\hello\ bar.w3x")
--loadmpq(30,"AMAI.mpq")
if grim.getmodulehandle("worldedit.exe") ~= 0 then
  --  loadmpq(16,"windows.mpq")
    -- inject World Editor only mpqs :
    -- For example:
    --if grim.exists("WE Unlimited\\weu.exe") then
	--    loadmpq(15,"WE Unlimited\\weu.exe")
    --end
    -- Loads WEU if present in a WE Unlimited subfolder
end
