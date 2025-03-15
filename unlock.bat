@echo off
REM Ensure ADB is available in PATH
SET PATH=%PATH%;%~dp0

REM Check if ADB is connected
adb devices
IF %ERRORLEVEL% NEQ 0 (
    echo ADB is not connected or not found. Please connect your device and try again.
    pause
    exit /b
)

REM Run ADB commands
adb shell settings put global setup_wizard_has_run 1
adb shell settings put secure user_setup_complete 1
adb shell content insert --uri content://settings/secure --bind name:s:DEVICE_PROVISIONED --bind value:i:1
adb shell content insert --uri content://settings/secure --bind name:s:user_setup_complete --bind value:i:1
adb shell content insert --uri content://settings/secure --bind name:s:INSTALL_NON_MARKET_APPS --bind value:i:1
adb shell am start -c android.intent.category.HOME -a android.intent.action.MAIN

REM Wait for 5 seconds
timeout /t 5 /nobreak

adb shell am start -n com.android.settings/com.android.settings.Settings

REM Wait for 5 seconds
timeout /t 5 /nobreak

REM Reboot the device
adb shell reboot

echo All done! The device is rebooting.
pause
