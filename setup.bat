@echo off
chcp 65001 >nul 2>&1
REM AI-Platform 초기 세팅 스크립트 (Windows)
REM 사용법: setup.bat

setlocal enabledelayedexpansion

set GITHUB_ORG=aron0628

echo === AI-Platform 초기 세팅 ===
echo.

REM 하위 프로젝트 clone
for %%R in (react-agent document-parser-server document-parser-client file-manager-admin agent-chat-ui) do (
    if exist "%%R\" (
        echo [SKIP] %%R/ 이미 존재
    ) else (
        echo [CLONE] %%R ...
        git clone "https://github.com/%GITHUB_ORG%/%%R.git"
        if errorlevel 1 (
            echo [ERROR] %%R clone 실패
            exit /b 1
        )
    )
)

echo.
echo === 세팅 완료 ===
echo.
echo 다음 단계:
echo   1. docker compose up -d --build
echo.

endlocal
