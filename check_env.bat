@echo off
chcp 65001 >nul
REM ============================================
REM  GIS 全栈开发环境 — 一键自检脚本
REM  验证 Node.js / pnpm / Python / Java / Git / Docker
REM  输出格式：统一表格样式，版本 + 状态
REM ============================================

setlocal enabledelayedexpansion

set "PASS=0"
set "FAIL=0"

echo.
echo ╔══════════════════════════════════════════╗
echo ║    GIS 全栈开发环境 — 版本自检          ║
echo ╚══════════════════════════════════════════╝
echo.

REM ========== Node.js ==========
set "VER="
for /f "tokens=*" %%i in ('node --version 2^>nul') do set "VER=%%i"
if defined VER (
    echo   [✓] Node.js       %VER%
    set /a PASS+=1
) else (
    echo   [✗] Node.js      未安装
    set /a FAIL+=1
)

REM ========== pnpm ==========
set "VER="
for /f "tokens=*" %%i in ('pnpm --version 2^>nul') do set "VER=%%i"
if defined VER (
    echo   [✓] pnpm          v%VER%
    set /a PASS+=1
) else (
    echo   [✗] pnpm         未安装
    set /a FAIL+=1
)

REM ========== Python ==========
set "VER="
for /f "tokens=*" %%i in ('python --version 2^>nul') do set "VER=%%i"
if defined VER (
    echo   [✓] Python        %VER%
    set /a PASS+=1
) else (
    echo   [✗] Python       未安装
    set /a FAIL+=1
)

REM ========== Java ==========
set "VER="
for /f "tokens=*" %%i in ('java -version 2^>^&1') do (
    if not defined VER set "VER=%%i"
)
if defined VER (
    echo   [✓] Java          %VER%
    set /a PASS+=1
) else (
    echo   [✗] Java         未安装
    set /a FAIL+=1
)

REM ========== Git ==========
set "VER="
for /f "tokens=*" %%i in ('git --version 2^>nul') do set "VER=%%i"
if defined VER (
    echo   [✓] Git           %VER%
    set /a PASS+=1
) else (
    echo   [✗] Git          未安装
    set /a FAIL+=1
)

REM ========== Docker ==========
set "VER="
for /f "tokens=*" %%i in ('docker --version 2^>nul') do set "VER=%%i"
if defined VER (
    echo   [✓] Docker        %VER%
    set /a PASS+=1
) else (
    echo   [-] Docker       未安装 ^(可选^)
)

echo.
echo ╔══════════════════════════════════════════╗
echo ║  检查完成: %PASS% 项通过, %FAIL% 项失败
echo ╚══════════════════════════════════════════╝
echo.

if %FAIL% gtr 0 (
    echo   ⚠ 请安装标记为 [✗] 的工具，确保路径配置正确
    echo.
)

pause
