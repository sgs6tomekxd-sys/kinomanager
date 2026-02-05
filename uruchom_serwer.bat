@echo off
title KinoManager Server
color 0A

echo ==========================================
echo    KinoManager Pro - Uruchamianie...
echo ==========================================
echo.

:: Sprawdz czy Node.js jest zainstalowany
node -v >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo BLAD: Nie znaleziono Node.js!
    echo Prosze zainstalowac Node.js ze strony: https://nodejs.org/
    echo.
    pause
    exit
)

:: Sprawdz czy sa zainstalowane biblioteki
if not exist "node_modules" (
    echo [1/2] Wykryto pierwsze uruchomienie. Instalowanie bibliotek...
    call npm install
    echo Instalacja zakonczona.
    echo.
) else (
    echo [1/2] Biblioteki sa juz zainstalowane.
)

echo [2/2] Uruchamianie serwera...
echo.
echo Aby zatrzymac serwer, zamknij to okno.
echo.

:: Uruchom serwer
npm start
pause