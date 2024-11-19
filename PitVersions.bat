@ECHO OFF
SET VER=%~1
SET TAG=%~2
SET MAP=%~3
SET FORCE=%~4
@rem git.exe instead of just git, because some git.cmd commands cause the entire batch script to exit.
where git.exe
if "%errorlevel%"=="1" (
  ECHO Tagging %VER% error
  ECHO Please install Git as a requirement. Download : https://gitforwindows.org/
  exit /b 1
)
git.exe rev-parse --verify --quiet %TAG%
if "%errorlevel%"=="1" (
  ECHO Reference %TAG% not found
  exit /b 1
)
git.exe diff --quiet %TAG% -- common.eai
if "%errorlevel%"=="1" (
  ECHO %TAG% is not compatible because common.eai does not match cross-versions.
  if "%FORCE%" neq "1" (
    ECHO Install can be forced with PitVersions "%VER%" "%TAG%" "%MAP%" 1
    ECHO Exiting
    exit /b 1
  )
)
if not exist Scripts\%VER%\a\NUL mkdir Scripts\%VER%\a
if not exist Scripts\%VER%\b\NUL mkdir Scripts\%VER%\b
for /f %%a in ('git.exe rev-parse --abbrev-ref HEAD') do set "HEAD_REFNAME=%%a"
for /f %%a in ('git.exe rev-parse HEAD') do set "COMMIT_HASH_A=%%a"
call MakeVERBase.bat %VER% 1
del Scripts\%VER%\a\* /Q
copy Scripts\%VER%\*.ai Scripts\%VER%\a
echo %HEAD_REFNAME%:%COMMIT_HASH_A% > Scripts\%VER%\a\amai_version.txt
echo Tagged HEAD %HEAD_REFNAME% (%COMMIT_HASH_A%) as Version A

git.exe checkout %TAG%
for /f %%a in ('git.exe rev-parse HEAD') do set "COMMIT_HASH_B=%%a"
call MakeVERBase.bat %VER% 1
del Scripts\%VER%\b\* /Q
copy Scripts\%VER%\*.ai Scripts\%VER%\b
ren Scripts\%VER%\b\elf.ai elf2.ai
ren Scripts\%VER%\b\human.ai human2.ai
ren Scripts\%VER%\b\orc.ai orc2.ai
ren Scripts\%VER%\b\undead.ai undead2.ai
echo %TAG%:%COMMIT_HASH_B% > Scripts\%VER%\b\amai_version2.txt
echo Tagged %TAG% (%COMMIT_HASH_B%) as Version B

git.exe checkout %HEAD_REFNAME%
call InstallVERToMap "%VER%" "%MAP%" 3