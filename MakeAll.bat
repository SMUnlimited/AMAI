@ECHO OFF
@call MakeRoC
if "%RESULTMAKEVER%"=="1" (
  pause
)
@call MakeTFT
if "%RESULTMAKEVER%"=="1" (
  pause
)
@call MakeREFORGED
if "%RESULTMAKEVER%"=="1" (
  pause
)
@call MakeOptROC
if "%RESULTOPTVER%"=="1" (
  pause
)
@call MakeOptTFT
if "%RESULTOPTVER%"=="1" (
  pause
)
@call MakeOptREFORGED
if "%RESULTOPTVER%"=="1" (
  pause
)
