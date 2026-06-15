@echo off
:: Auto-elevate
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ^> Requesting admin...
    powershell start -verb runas "%0"
    exit /b
)

set "key=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\GameDVR"
for /f "tokens=3" %%a in ('reg query "%key%" /v AppCaptureEnabled 2^>nul ^| find "0x"') do set c=%%a
if "%c%"=="0x1" (set v=0&set s=OFF) else (set v=1&set s=ON)

if "%s%"=="ON" (color 0A) else (color 0C)

reg add "%key%" /v AppCaptureEnabled /t REG_DWORD /d %v% /f >nul
taskkill /f /im GameBar.exe >nul 2>nul

:: Set spaces for alignment
if "%s%"=="ON" (
    set "left=       "
    set "right=       "
) else (
    set "left=       "
    set "right=      "
)

echo.
echo ¨X¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨[
echo ¨U%left%GameBar : %s%%right%¨U
echo ¨^¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨a
echo.
echo Exiting in 3 seconds...
timeout /t 3 >nul