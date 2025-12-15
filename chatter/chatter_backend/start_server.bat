@echo off
REM Start Laravel development server on port 8888 accessible from LAN
REM This server can be reached at http://192.168.100.4:8888 from devices on the same network
cd /d "%~dp0"
php artisan serve --host=0.0.0.0 --port=8888
pause
