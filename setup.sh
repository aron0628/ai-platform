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

# 하위 프로젝트 clone
for repo in "${REPOS[@]}"; do
  if [ -d "$repo" ]; then
    echo "[SKIP] $repo/ 이미 존재"
  else
    echo "[CLONE] $repo ..."
    git clone "https://github.com/${GITHUB_ORG}/${repo}.git"
  fi
done

echo ""
echo "=== 세팅 완료 ==="
echo ""
echo "다음 단계:"
echo "  1. docker compose up -d --build"
echo ""
