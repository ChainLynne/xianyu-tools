@echo off
title 闲鱼项目启动器
chcp 936 >nul

:: 强制切换到你的项目目录
cd /d "%~dp0"

:: 检查虚拟环境
if not exist "venv" (
    echo [首次运行] 正在安装依赖环境...
    python -m venv venv
    call venv\Scripts\activate.bat
    python -m pip install --upgrade pip
    pip install -r requirements.txt
    playwright install chromium
) else (
    echo [常规运行] 直接启动...
    call venv\Scripts\activate.bat
)

:: 启动服务
echo 正在启动服务...
start /b python Start.py

echo 正在连接服务...
:wait_loop
python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080', timeout=1)" >nul 2>&1
if %errorlevel% == 0 (
    echo 启动成功！正在打开浏览器...
    start http://127.0.0.1:8080
    exit
)
timeout /t 1 /nobreak >nul
goto wait_loop