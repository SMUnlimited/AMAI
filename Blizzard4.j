    call DetectGameStarted()
endfunction



//***************************************************************************
//*
//*  Random distribution
//*
//*  Used to select a random object from a given distribution of chances
//*
//*  - RandomDistReset clears the distribution list
//*
//*  - RandomDistAddItem adds a new object to the distribution list
//*    with a given identifier and an integer chance to be chosen
//*
//*  - RandomDistChoose will use the current distribution list to choose
//*    one of the objects randomly based on the chance distribution
//*  
//*  Note that the chances are effectively normalized by their sum,
//*  so only the relative values of each chance are important
//*
//***************************************************************************

//===========================================================================
function RandomDistReset takes nothing returns nothing
    set bj_randDistCount = 0
endfunction

//===========================================================================
function RandomDistAddItem takes integer inID, integer inChance returns nothing
    set bj_randDistID[bj_randDistCount] = inID
    set bj_randDistChance[bj_randDistCount] = inChance
    set bj_randDistCount = bj_randDistCount + 1
endfunction

//===========================================================================
function RandomDistChoose takes nothing returns integer
    local integer sum = 0
    local integer chance = 0
    local integer index
    local integer foundID = -1
    local boolean done

    // No items?
    if (bj_randDistCount == 0) then
        return -1
    endif

    // Find sum of all chances
    set index = 0
    loop
        set sum = sum + bj_randDistChance[index]

        set index = index + 1
        exitwhen index == bj_randDistCount
    endloop

    // Choose random number within the total range
    set chance = GetRandomInt(1, sum)

    // Find ID which corresponds to this chance
    set index = 0
    set sum = 0
    set done = false
    loop
        set sum = sum + bj_randDistChance[index]

        if (chance <= sum) then
            set foundID = bj_randDistID[index]
            set done = true
        endif

        set index = index + 1
        if (index == bj_randDistCount) then
            set done = true
        endif

        exitwhen done == true
    endloop

    return foundID
endfunction



//***************************************************************************
//*
//*  Drop item
//*
//*  Makes the given unit drop the given item
//*
//*  Note: This could potentially cause problems if the unit is standing
//*        right on the edge of an unpathable area and happens to drop the
//*        item into the unpathable area where nobody can get it...
//*
//***************************************************************************

function UnitDropItem takes unit inUnit, integer inItemID returns item
    local real x
    local real y
    local real radius = 32
    local real unitX
    local real unitY
    local item droppedItem

    if (inItemID == -1) then
        return null
    endif

    set unitX = GetUnitX(inUnit)
    set unitY = GetUnitY(inUnit)

    set x = GetRandomReal(unitX - radius, unitX + radius)
    set y = GetRandomReal(unitY - radius, unitY + radius)

    set droppedItem = CreateItem(inItemID, x, y)

    call SetItemDropID(droppedItem, GetUnitTypeId(inUnit))
    call UpdateStockAvailability(droppedItem)

    return droppedItem
endfunction

//===========================================================================
function WidgetDropItem takes widget inWidget, integer inItemID returns item
    local real x
    local real y
    local real radius = 32
    local real widgetX
    local real widgetY

    if (inItemID == -1) then
        return null
    endif

    set widgetX = GetWidgetX(inWidget)
    set widgetY = GetWidgetY(inWidget)

    set x = GetRandomReal(widgetX - radius, widgetX + radius)
    set y = GetRandomReal(widgetY - radius, widgetY + radius)

    return CreateItem(inItemID, x, y)
endfunction


//***************************************************************************
//*
//*  Instanced Object Operation Functions
//*
//*  Get/Set specific fields for single unit/item/ability instance
//*
//***************************************************************************

//===========================================================================
function BlzIsLastInstanceObjectFunctionSuccessful takes nothing returns boolean
    return bj_lastInstObjFuncSuccessful
endfunction

// Ability
//===========================================================================
function BlzSetAbilityBooleanFieldBJ takes ability whichAbility, abilitybooleanfield whichField, boolean value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetAbilityBooleanField(whichAbility, whichField, value)
endfunction

//===========================================================================
function BlzSetAbilityIntegerFieldBJ takes ability whichAbility, abilityintegerfield whichField, integer value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetAbilityIntegerField(whichAbility, whichField, value)
endfunction

//===========================================================================
function BlzSetAbilityRealFieldBJ takes ability whichAbility, abilityrealfield whichField, real value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetAbilityRealField(whichAbility, whichField, value)
endfunction

//===========================================================================
function BlzSetAbilityStringFieldBJ takes ability whichAbility, abilitystringfield whichField, string value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetAbilityStringField(whichAbility, whichField, value)
endfunction

//===========================================================================
function BlzSetAbilityBooleanLevelFieldBJ takes ability whichAbility, abilitybooleanlevelfield whichField, integer level, boolean value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetAbilityBooleanLevelField(whichAbility, whichField, level, value)
endfunction

//===========================================================================
function BlzSetAbilityIntegerLevelFieldBJ takes ability whichAbility, abilityintegerlevelfield whichField, integer level, integer value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetAbilityIntegerLevelField(whichAbility, whichField, level, value)
endfunction

//===========================================================================
function BlzSetAbilityRealLevelFieldBJ takes ability whichAbility, abilityreallevelfield whichField, integer level, real value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetAbilityRealLevelField(whichAbility, whichField, level, value)
endfunction

//===========================================================================
function BlzSetAbilityStringLevelFieldBJ takes ability whichAbility, abilitystringlevelfield whichField, integer level, string value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetAbilityStringLevelField(whichAbility, whichField, level, value)
endfunction

//===========================================================================
function BlzSetAbilityBooleanLevelArrayFieldBJ takes ability whichAbility, abilitybooleanlevelarrayfield whichField, integer level, integer index, boolean value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetAbilityBooleanLevelArrayField(whichAbility, whichField, level, index, value)
endfunction

//===========================================================================
function BlzSetAbilityIntegerLevelArrayFieldBJ takes ability whichAbility, abilityintegerlevelarrayfield whichField, integer level, integer index, integer value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetAbilityIntegerLevelArrayField(whichAbility, whichField, level, index, value)
endfunction

//===========================================================================
function BlzSetAbilityRealLevelArrayFieldBJ takes ability whichAbility, abilityreallevelarrayfield whichField, integer level, integer index, real value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetAbilityRealLevelArrayField(whichAbility, whichField, level, index, value)
endfunction

//===========================================================================
function BlzSetAbilityStringLevelArrayFieldBJ takes ability whichAbility, abilitystringlevelarrayfield whichField, integer level, integer index, string value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetAbilityStringLevelArrayField(whichAbility, whichField, level, index, value)
endfunction

//===========================================================================
function BlzAddAbilityBooleanLevelArrayFieldBJ takes ability whichAbility, abilitybooleanlevelarrayfield whichField, integer level, boolean value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzAddAbilityBooleanLevelArrayField(whichAbility, whichField, level, value)
endfunction

//===========================================================================
function BlzAddAbilityIntegerLevelArrayFieldBJ takes ability whichAbility, abilityintegerlevelarrayfield whichField, integer level, integer value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzAddAbilityIntegerLevelArrayField(whichAbility, whichField, level, value)
endfunction

//===========================================================================
function BlzAddAbilityRealLevelArrayFieldBJ takes ability whichAbility, abilityreallevelarrayfield whichField, integer level, real value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzAddAbilityRealLevelArrayField(whichAbility, whichField, level, value)
endfunction

//===========================================================================
function BlzAddAbilityStringLevelArrayFieldBJ takes ability whichAbility, abilitystringlevelarrayfield whichField, integer level, string value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzAddAbilityStringLevelArrayField(whichAbility, whichField, level, value)
endfunction

//===========================================================================
function BlzRemoveAbilityBooleanLevelArrayFieldBJ takes ability whichAbility, abilitybooleanlevelarrayfield whichField, integer level, boolean value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzRemoveAbilityBooleanLevelArrayField(whichAbility, whichField, level, value)
endfunction

//===========================================================================
function BlzRemoveAbilityIntegerLevelArrayFieldBJ takes ability whichAbility, abilityintegerlevelarrayfield whichField, integer level, integer value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzRemoveAbilityIntegerLevelArrayField(whichAbility, whichField, level, value)
endfunction

//===========================================================================
function BlzRemoveAbilityRealLevelArrayFieldBJ takes ability whichAbility, abilityreallevelarrayfield whichField, integer level, real value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzRemoveAbilityRealLevelArrayField(whichAbility, whichField, level, value)
endfunction

//===========================================================================
function BlzRemoveAbilityStringLevelArrayFieldBJ takes ability whichAbility, abilitystringlevelarrayfield whichField, integer level, string value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzRemoveAbilityStringLevelArrayField(whichAbility, whichField, level, value)
endfunction

// Item 
//=============================================================
function BlzItemAddAbilityBJ takes item whichItem, integer abilCode returns nothing
    set bj_lastInstObjFuncSuccessful = BlzItemAddAbility(whichItem, abilCode)
endfunction

//===========================================================================
function BlzItemRemoveAbilityBJ takes item whichItem, integer abilCode returns nothing
    set bj_lastInstObjFuncSuccessful = BlzItemRemoveAbility(whichItem, abilCode)
endfunction

//===========================================================================
function BlzSetItemBooleanFieldBJ takes item whichItem, itembooleanfield whichField, boolean value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetItemBooleanField(whichItem, whichField, value)
endfunction

//===========================================================================
function BlzSetItemIntegerFieldBJ takes item whichItem, itemintegerfield whichField, integer value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetItemIntegerField(whichItem, whichField, value)
endfunction

//===========================================================================
function BlzSetItemRealFieldBJ takes item whichItem, itemrealfield whichField, real value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetItemRealField(whichItem, whichField, value)
endfunction

//===========================================================================
function BlzSetItemStringFieldBJ takes item whichItem, itemstringfield whichField, string value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetItemStringField(whichItem, whichField, value)
endfunction


// Unit 
//===========================================================================
function BlzSetUnitBooleanFieldBJ takes unit whichUnit, unitbooleanfield whichField, boolean value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetUnitBooleanField(whichUnit, whichField, value)
endfunction

//===========================================================================
function BlzSetUnitIntegerFieldBJ takes unit whichUnit, unitintegerfield whichField, integer value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetUnitIntegerField(whichUnit, whichField, value)
endfunction

//===========================================================================
function BlzSetUnitRealFieldBJ takes unit whichUnit, unitrealfield whichField, real value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetUnitRealField(whichUnit, whichField, value)
endfunction

//===========================================================================
function BlzSetUnitStringFieldBJ takes unit whichUnit, unitstringfield whichField, string value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetUnitStringField(whichUnit, whichField, value)
endfunction

// Unit Weapon
//===========================================================================
function BlzSetUnitWeaponBooleanFieldBJ takes unit whichUnit, unitweaponbooleanfield whichField, integer index, boolean value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetUnitWeaponBooleanField(whichUnit, whichField, index, value)
endfunction

//===========================================================================
function BlzSetUnitWeaponIntegerFieldBJ takes unit whichUnit, unitweaponintegerfield whichField, integer index, integer value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetUnitWeaponIntegerField(whichUnit, whichField, index, value)
endfunction

//===========================================================================
function BlzSetUnitWeaponRealFieldBJ takes unit whichUnit, unitweaponrealfield whichField, integer index, real value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetUnitWeaponRealField(whichUnit, whichField, index, value)
endfunction

//===========================================================================
function BlzSetUnitWeaponStringFieldBJ takes unit whichUnit, unitweaponstringfield whichField, integer index, string value returns nothing
    set bj_lastInstObjFuncSuccessful = BlzSetUnitWeaponStringField(whichUnit, whichField, index, value)
endfunction
