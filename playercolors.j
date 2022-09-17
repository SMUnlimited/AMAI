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
      return "|CffFF0000"+name+"|r"
  elseif c == PLAYER_COLOR_BLUE then
      return "|Cff0064FF"+name+"|r"
  elseif c == PLAYER_COLOR_CYAN then
      return "|Cff1BE7BA"+name+"|r"
  elseif c == PLAYER_COLOR_PURPLE then
      return "|Cff550081"+name+"|r"
  elseif c == PLAYER_COLOR_YELLOW then
      return "|CffFFFC00"+name+"|r "
  elseif c == PLAYER_COLOR_ORANGE then
      return "|CffFF8A0D"+name+"|r"
  elseif c == PLAYER_COLOR_GREEN then
      return "|Cff21BF00"+name+"|r"
  elseif c == PLAYER_COLOR_PINK then
      return "|CffE45CAF"+name+"|r"
  elseif c == PLAYER_COLOR_LIGHT_GRAY then
      return "|Cff949696"+name+"|r"
  elseif c == PLAYER_COLOR_LIGHT_BLUE then
      return "|Cff7EBFF1"+name+"|r"
  elseif c == PLAYER_COLOR_AQUA then
      return "|Cff106247"+name+"|r"
  elseif c == PLAYER_COLOR_MAROON then
      return "|Cff9C0000"+name+"|r"
  elseif c == PLAYER_COLOR_NAVY then
      return "|Cff0000C3"+name+"|r"
  elseif c == PLAYER_COLOR_TURQUOISE then
      return "|Cff00EBFF"+name+"|r"
  elseif c == PLAYER_COLOR_VIOLET then
      return "|CffBD00FF"+name+"|r"
  elseif c == PLAYER_COLOR_WHEAT then
      return "|CffECCD87"+name+"|r"
  elseif c == PLAYER_COLOR_PEACH then
      return "|CffF7A58B"+name+"|r"
  elseif c == PLAYER_COLOR_MINT then
      return "|CffBFFF81"+name+"|r"
  elseif c == PLAYER_COLOR_LAVENDER then
      return "|CffDBB9EB"+name+"|r"
  elseif c == PLAYER_COLOR_COAL then
      return "|Cff4F5055"+name+"|r"
  elseif c == PLAYER_COLOR_SNOW then
      return "|CffECF0FF"+name+"|r"
  elseif c == PLAYER_COLOR_EMERALD then
      return "|Cff00781E"+name+"|r"
  elseif c == PLAYER_COLOR_PEANUT then
      return "|CffA57033"+name+"|r"
  else //Brown
      return "|Cff4F2B05"+name+"|r"
  endif
endfunction