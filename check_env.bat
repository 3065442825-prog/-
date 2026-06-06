@echo off
REM GIS environment check script

setlocal enabledelayedexpansion

set PASS=0
set FAIL=0

cls
echo ============================================
echo   GIS Environment Check
echo ============================================
echo.

REM --- Node.js ---
set VER=
for /f "tokens=*" %%i in ('node --version 2^>nul') do set VER=%%i
if defined VER (
    echo   [OK] Node.js    !VER!
    set /a PASS+=1
) else (
    echo   [!!] Node.js    not found
    set /a FAIL+=1
)

REM --- pnpm ---
set VER=
for /f "tokens=*" %%i in ('pnpm --version 2^>nul') do set VER=%%i
if defined VER (
    echo   [OK] pnpm       v!VER!
    set /a PASS+=1
) else (
    echo   [!!] pnpm       not found
    set /a FAIL+=1
)

REM --- Python ---
set VER=
for /f "tokens=*" %%i in ('python --version 2^>nul') do set VER=%%i
if defined VER (
    echo   [OK] Python     !VER!
    set /a PASS+=1
) else (
    echo   [!!] Python     not found
    set /a FAIL+=1
)

REM --- Java ---
set VER=
for /f "tokens=*" %%i in ('java -version 2^>^&1') do (
    if not defined VER set VER=%%i
)
if defined VER (
    echo   [OK] Java       !VER!
    set /a PASS+=1
) else (
    echo   [!!] Java       not found
    set /a FAIL+=1
)

REM --- Git ---
set VER=
for /f "tokens=*" %%i in ('git --version 2^>nul') do set VER=%%i
if defined VER (
    echo   [OK] Git        !VER!
    set /a PASS+=1
) else (
    echo   [!!] Git        not found
    set /a FAIL+=1
)

REM --- Docker ---
set VER=
for /f "tokens=*" %%i in ('docker --version 2^>nul') do set VER=%%i
if defined VER (
    echo   [OK] Docker     !VER!
    set /a PASS+=1
) else (
    echo   [--] Docker     not found (optional)
)

echo.
echo ============================================
echo   Result: %PASS% passed, %FAIL% failed
echo ============================================
echo.

if %FAIL% gtr 0 (
    echo   Please install tools marked [!!]
    echo.
)

pause
