@ECHO OFF
set FAILURE=0
@call MakeRoC 1
if "%RESULTMAKEVER%"=="1" (
  set FAILURE=1
)else if "%RESULTFWCOMPAT%"=="1" (
  set FAILURE=1
)
@call MakeOptROC 1
if "%RESULTMAKEVER%"=="1" (
  set FAILURE=1
)
@call MakeTFT 1
if "%RESULTMAKEVER%"=="1" (
  set FAILURE=1
)else if "%RESULTFWCOMPAT%"=="1" (
  set FAILURE=1
)
@call MakeOptTFT 1
if "%RESULTMAKEVER%"=="1" (
  set FAILURE=1
)
@call MakeREFORGED 1
if "%RESULTMAKEVER%"=="1" (
  set FAILURE=1
)
@call MakeOptREFORGED 1
if "%RESULTMAKEVER%"=="1" (
  set FAILURE=1
)
if "%FAILURE%"=="1" (
  pause
)