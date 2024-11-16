@echo off
setlocal enabledelayedexpansion
set /p computers=Enter computer names (separated by commas): 

for %%i in (%computers%) do (
    echo Computer Name: %%i
    
    for /f "tokens=2 delims=:" %%a in ('systeminfo /s %%i ^| findstr /C:"Total Physical Memory"') do (
        set "memory=%%a"
    )

    for /f "tokens=2 delims==" %%b in ('wmic /node:%%i os get version /value ^| find "Version"') do set "osVersion=%%b"
    for /f "tokens=*" %%c in ("!osVersion!") do set "osVersion=%%c"
    
    echo OS Version/Build: !osVersion!
    echo RAM: !memory:~1!
    
    echo -----------------------
)
pause
