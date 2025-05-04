@echo off
cmd /c "flutter pub get"
set EXITCODE=%errorlevel%
echo ErrorLevel after flutter pub get: %EXITCODE%

if %EXITCODE% equ 0 (
    echo flutter pub get succeeded, running postinstall...
    dart tool\postinstall.dart
) else (
    echo flutter pub get failed. postinstall will not be executed.
)

pause