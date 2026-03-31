# AI-Platform

5개 프로젝트를 Docker Compose로 통합 실행하기 위한 인프라 레포.

## 서비스 구성

| 서비스 | 포트 | 역할 |
|--------|------|------|
| react-agent | 2024 | LangGraph AI 에이전트 백엔드 |
| document-parser-server | 9997 | 문서 파싱 API 서버 |
| file-manager-admin | 8000 | FastAPI 관리자 웹 서버 |
| agent-chat-ui | 3000 | Next.js 프론트엔드 |
| document-parser-client | - | Python 라이브러리 (Docker 서비스 아님) |

## 빠른 시작

### 사전 요구사항

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows/macOS)
- Git

### 초기 세팅

```bash
git clone https://github.com/aron0628/ai-platform.git
cd ai-platform

# 자동 세팅 (프로젝트 clone + .env 생성)
chmod +x setup.sh
./setup.sh

# 각 프로젝트 .env 파일에 API 키 입력 후 실행
docker compose up -d --build
```

### 수동 세팅

```bash
git clone https://github.com/aron0628/ai-platform.git
cd ai-platform

# 하위 프로젝트 clone
git clone https://github.com/aron0628/react-agent.git
git clone https://github.com/aron0628/document-parser-server.git
git clone https://github.com/aron0628/document-parser-client.git
git clone https://github.com/aron0628/file-manager-admin.git
git clone https://github.com/aron0628/agent-chat-ui.git

# .env 세팅
cp react-agent/.env.example react-agent/.env
cp document-parser-server/.env.example document-parser-server/.env
cp file-manager-admin/.env.example file-manager-admin/.env
cp agent-chat-ui/.env.example agent-chat-ui/.env
# → 각 .env에 API 키 입력

# 실행
docker compose up -d --build
```

## 필수 API 키

| 키 | 사용 서비스 | 필수 |
|----|-----------|:----:|
| OPENAI_API_KEY | react-agent, document-parser-server | O |
| TAVILY_API_KEY | react-agent | O |
| UPSTAGE_API_KEY | react-agent, document-parser-server | O |
| DB_HOST/PORT/NAME/USER/PASSWORD | react-agent, file-manager-admin | O |
| LANGSMITH_API_KEY | react-agent, agent-chat-ui | - |
| LANGGRAPH_AUTH_KEY | react-agent, agent-chat-ui | - |

## 환경별 실행

```bash
# 기본
docker compose up -d --build

# 개발 (소스 마운트 + 핫리로드)
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build

# 프로덕션 (restart: always + 로깅)
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
```

## 기동 순서

```
document-parser-server → file-manager-admin (healthy 후 시작)
react-agent → agent-chat-ui (healthy 후 시작)
```
