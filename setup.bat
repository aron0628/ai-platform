@echo off
chcp 65001 >nul 2>&1
REM AI-Platform 초기 세팅 스크립트 (Windows)
REM 사용법: setup.bat

setlocal enabledelayedexpansion

set GITHUB_ORG=aron0628

echo === AI-Platform 초기 세팅 ===
echo.

REM 1. 하위 프로젝트 clone
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

REM 2. .env 파일 생성
for %%P in (react-agent document-parser-server file-manager-admin agent-chat-ui) do (
    if exist "%%P\.env" (
        echo [SKIP] %%P/.env 이미 존재
    ) else if exist "%%P\.env.example" (
        copy "%%P\.env.example" "%%P\.env" >nul
        echo [CREATE] %%P/.env (← .env.example 복사됨, API 키 입력 필요^)
    ) else (
        echo [WARN] %%P/.env.example 없음
    )
)

echo.
echo === 세팅 완료 ===
echo.
echo 다음 단계:
echo   1. 각 프로젝트의 .env 파일에 API 키를 입력하세요
echo   2. docker compose up -d --build
echo.

endlocal
