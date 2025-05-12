@echo off
setlocal EnableDelayedExpansion

:: RunWIMUtil.cmd
:: Author: ZeroDot1 (https://github.com/ZeroDot1)
:: Purpose: Runs WIMUtil PowerShell script from https://github.com/memstechtips/WIMUtil
:: Created: May 12, 2025

:: Check if running as Administrator
echo Checking for administrator privileges...
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script must be run as Administrator.
    echo Right-click the script and select "Run as administrator".
    pause
    exit /b 1
)

:: Verify PowerShell is available
echo Checking for PowerShell...
powershell -Command "Get-Host" >nul 2>&1
if %errorLevel% neq 0 (
    echo Error: PowerShell is not installed or not accessible.
    pause
    exit /b 1
)

:: Set PowerShell execution policy to Unrestricted
echo Setting PowerShell execution policy to Unrestricted...
powershell -Command "Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Unrestricted -Force" >nul 2>&1
if %errorLevel% neq 0 (
    echo Error: Failed to set PowerShell execution policy.
    pause
    exit /b 1
)

:: Display WIMUtil version (latest release from GitHub)
echo Retrieving WIMUtil version...
for /f "tokens=2 delims=:" %%a in ('curl -s https://api.github.com/repos/memstechtips/WIMUtil/releases/latest ^| find "tag_name"') do (
    set "WIMUTIL_VERSION=%%a"
    set "WIMUTIL_VERSION=!WIMUTIL_VERSION:~2,-2!"
)
if "!WIMUTIL_VERSION!"=="" (
    echo Warning: Could not retrieve WIMUtil version. Check internet connection or GitHub API access.
) else (
    echo WIMUtil Version: !WIMUTIL_VERSION!
)

:: Run WIMUtil PowerShell script
echo Launching WIMUtil...
powershell -NoProfile -Command "irm 'https://github.com/memstechtips/WIMUtil/raw/main/src/WIMUtil.ps1' | iex"
if %errorLevel% neq 0 (
    echo Error: Failed to run WIMUtil. Check internet connection or GitHub repository.
    pause
    exit /b 1
)

echo WIMUtil execution completed. Follow the wizard instructions in the PowerShell window.
pause
exit /b 0
