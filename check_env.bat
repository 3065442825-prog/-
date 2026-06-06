@echo off
REM ========================================
REM  GIS 全栈开发环境 — 一键自检脚本
REM  用于验证 Node/Python/Java/Git 版本
REM ========================================

echo ============================================
echo    GIS 全栈开发环境版本自检
echo ============================================
echo.

echo [Node.js]
call node --version 2>nul
if %errorlevel% neq 0 echo   ❌ Node.js 未安装
echo.

echo [pnpm]
call pnpm --version 2>nul
if %errorlevel% neq 0 echo   ❌ pnpm 未安装
echo.

echo [Python]
call python --version 2>nul
if %errorlevel% neq 0 echo   ❌ Python 未安装
echo.

echo [Java]
call java -version 2>nul
if %errorlevel% neq 0 echo   ❌ Java 未安装
echo.

echo [Git]
call git --version 2>nul
if %errorlevel% neq 0 echo   ❌ Git 未安装
echo.

echo ============================================
echo  环境检查完成！
echo ============================================

pause
