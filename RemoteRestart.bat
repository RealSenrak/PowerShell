@echo off
set /p computers=Enter computer names (separated by commas): 

:: Display message for 30 seconds
echo Starting restart process. This may take a moment...
timeout /t 30 >nul

:: Loop through each computer name
for %%i in (%computers%) do (
    echo Restarting %%i...
    
    :: Use shutdown command to restart the remote computer
    shutdown /r /m \\%%i /f /t 0
    
    echo Restart process initiated for %%i.
)

echo All restart processes initiated.

pause
