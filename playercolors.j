//===========================================================================
// (AMAI)  ColorText (Converts the player color to a text version)
//===========================================================================
function ColorText takes player CPlayer returns string
  //Required Variables
  local playercolor PColor = GetPlayerColor(CPlayer)  //Gets the Player's color
    
  //Finds the Nicer Text Version of the Player's Color
  if (PColor == PLAYER_COLOR_RED) then
    return "Red"
  elseif (PColor == PLAYER_COLOR_BLUE) then
    return "Blue"
  elseif (PColor == PLAYER_COLOR_CYAN) then
    return "Cyan"
  elseif (PColor == PLAYER_COLOR_PURPLE) then
    return "Purple"
  elseif (PColor == PLAYER_COLOR_YELLOW) then
    return "Yellow"
  elseif (PColor == PLAYER_COLOR_ORANGE) then
    return "Orange"
  elseif (PColor == PLAYER_COLOR_GREEN) then
    return "Green"
  elseif (PColor == PLAYER_COLOR_PINK) then
    return "Pink"
  elseif (PColor == PLAYER_COLOR_LIGHT_GRAY) then
    return "Light Gray"
  elseif (PColor == PLAYER_COLOR_LIGHT_BLUE) then
    return "Light Blue"
  elseif (PColor == PLAYER_COLOR_AQUA) then
    return "Aqua"
  elseif (PColor == PLAYER_COLOR_BROWN) then
    return "Brown"
  elseif (PColor == PLAYER_COLOR_MAROON) then
    return "Maroon"
  elseif (PColor == PLAYER_COLOR_NAVY) then
    return "Navy"
  elseif (PColor == PLAYER_COLOR_TURQUOISE) then
    return "Turquoise"
  elseif (PColor == PLAYER_COLOR_VIOLET) then
    return "Violet"
  elseif (PColor == PLAYER_COLOR_WHEAT) then
    return "Wheat"
  elseif (PColor == PLAYER_COLOR_PEACH) then
    return "Peach"
  elseif (PColor == PLAYER_COLOR_MINT) then
    return "Mint"
  elseif (PColor == PLAYER_COLOR_LAVENDER) then
    return "Lavender"
  elseif (PColor == PLAYER_COLOR_COAL) then
    return "Coal"
  elseif (PColor == PLAYER_COLOR_SNOW) then
    return "Snow"
  elseif (PColor == PLAYER_COLOR_EMERALD) then
    return "Emerald"
  elseif (PColor == PLAYER_COLOR_PEANUT) then
    return "Peanut"
  endif
  
  //Returns text version
  return ""
endfunction

function cs2s takes string name, playercolor c returns string
  if c == PLAYER_COLOR_RED then
      return "|cffff0402"+name+"|r"
  elseif c == PLAYER_COLOR_BLUE then
      return "|cff0042ff"+name+"|r"
  elseif c == PLAYER_COLOR_CYAN then
      return "|cff1be6ba"+name+"|r"
  elseif c == PLAYER_COLOR_PURPLE then
      return "|cff550081"+name+"|r"
  elseif c == PLAYER_COLOR_YELLOW then
      return "|cfffffc00"+name+"|r"
  elseif c == PLAYER_COLOR_ORANGE then
      return "|cffff8a0d"+name+"|r"
  elseif c == PLAYER_COLOR_GREEN then
      return "|cff20bf00"+name+"|r"
  elseif c == PLAYER_COLOR_PINK then
      return "|cffe35baf"+name+"|r"
  elseif c == PLAYER_COLOR_LIGHT_GRAY then
      return "|cff949696"+name+"|r"
  elseif c == PLAYER_COLOR_LIGHT_BLUE then
      return "|cff81bff1"+name+"|r"
  elseif c == PLAYER_COLOR_AQUA then
      return "|cff106247"+name+"|r"
  elseif c == PLAYER_COLOR_MAROON then
      return "|cff9c0000"+name+"|r"
  elseif c == PLAYER_COLOR_NAVY then
      return "|cff0000c2"+name+"|r"
  elseif c == PLAYER_COLOR_TURQUOISE then
      return "|cff00ebff"+name+"|r"
  elseif c == PLAYER_COLOR_VIOLET then
      return "|cffbd00ff"+name+"|r"
  elseif c == PLAYER_COLOR_WHEAT then
      return "|cffeccc86"+name+"|r"
  elseif c == PLAYER_COLOR_PEACH then
      return "|cfff7a48b"+name+"|r"
  elseif c == PLAYER_COLOR_MINT then
      return "|cffbfff80"+name+"|r"
  elseif c == PLAYER_COLOR_LAVENDER then
      return "|cffdbb8ec"+name+"|r"
  elseif c == PLAYER_COLOR_COAL then
      return "|cff4f4f55"+name+"|r"
  elseif c == PLAYER_COLOR_SNOW then
      return "|cffecf0ff"+name+"|r"
  elseif c == PLAYER_COLOR_EMERALD then
      return "|cff00781e"+name+"|r"
  elseif c == PLAYER_COLOR_PEANUT then
      return "|cffa46f34"+name+"|r"
  else //Brown
      return "|cff4f2b05"+name+"|r"
  endif
endfunction