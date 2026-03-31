#!/bin/bash
# AI-Platform 초기 세팅 스크립트
# 사용법: chmod +x setup.sh && ./setup.sh

set -e

REPOS=(
  "react-agent"
  "document-parser-server"
  "document-parser-client"
  "file-manager-admin"
  "agent-chat-ui"
)

GITHUB_ORG="aron0628"

echo "=== AI-Platform 초기 세팅 ==="
echo ""

# 1. 하위 프로젝트 clone
for repo in "${REPOS[@]}"; do
  if [ -d "$repo" ]; then
    echo "[SKIP] $repo/ 이미 존재"
  else
    echo "[CLONE] $repo ..."
    git clone "https://github.com/${GITHUB_ORG}/${repo}.git"
  fi
done

echo ""

# 2. .env 파일 생성
ENV_PROJECTS=("react-agent" "document-parser-server" "file-manager-admin" "agent-chat-ui")

for project in "${ENV_PROJECTS[@]}"; do
  if [ -f "$project/.env" ]; then
    echo "[SKIP] $project/.env 이미 존재"
  elif [ -f "$project/.env.example" ]; then
    cp "$project/.env.example" "$project/.env"
    echo "[CREATE] $project/.env (← .env.example 복사됨, API 키 입력 필요)"
  else
    echo "[WARN] $project/.env.example 없음"
  fi
done

echo ""
echo "=== 세팅 완료 ==="
echo ""
echo "다음 단계:"
echo "  1. 각 프로젝트의 .env 파일에 API 키를 입력하세요"
echo "  2. docker compose up -d --build"
echo ""
