@echo off
fltmc >nul 2>&1 || (powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs" & exit /b)
setlocal
set "U_TEMP=%TEMP%"
set "U_TMP=%TMP%"
set "U_LTEMP=%LocalAppData%\Temp"
set "W_TEMP=%SystemRoot%\Temp"
set "W_PREFETCH=%SystemRoot%\Prefetch"
call :clean "%U_TEMP%"
call :clean "%U_TMP%"
call :clean "%U_LTEMP%"
call :clean "%W_TEMP%"
call :clean "%W_PREFETCH%"
endlocal
exit /b
:clean
set "DIR=%~1"
if not exist "%DIR%" exit /b
pushd "%DIR%" 2>nul || exit /b
del /f /q *.* 2>nul
for /d %%D in (*) do rd /s /q "%%D"
popd
exit /b
