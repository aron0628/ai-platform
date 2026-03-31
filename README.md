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
- [git-crypt](https://github.com/AGWA/git-crypt) (`.env` 복호화용)

### macOS / Linux

```bash
git clone https://github.com/aron0628/ai-platform.git
cd ai-platform

# .env 복호화 (키 파일은 팀 vault에서 받기)
git-crypt unlock ./git-crypt-key

# 자동 세팅 (프로젝트 clone + envs/ → 각 프로젝트/.env 복사)
chmod +x setup.sh
./setup.sh

# 실행
docker compose up -d --build
```

### Windows

```cmd
git clone https://github.com/aron0628/ai-platform.git
cd ai-platform

# .env 복호화 (키 파일은 팀 vault에서 받기)
git-crypt unlock ./git-crypt-key

# 자동 세팅 (프로젝트 clone + envs/ → 각 프로젝트/.env 복사)
setup.bat

# 실행
docker compose up -d --build
```

> Windows는 [Docker Desktop](https://www.docker.com/products/docker-desktop/) 설치 시 WSL2가 자동 활성화됩니다.
> git-crypt는 WSL2 또는 [Git Bash](https://gitforwindows.org/) 환경에서 사용하세요.

## .env 관리 (git-crypt)

환경변수는 `envs/` 폴더에서 git-crypt로 암호화하여 관리합니다.

```
envs/
├── react-agent.env
├── document-parser-server.env
├── file-manager-admin.env
└── agent-chat-ui.env
```

- `setup.sh` / `setup.bat` 실행 시 `envs/*.env` → 각 프로젝트의 `.env`로 자동 복사
- GitHub에는 암호화된 바이너리로 저장 (키 없이 열람 불가)
- 키 파일(`git-crypt-key`)은 1Password 등 안전한 경로로 팀 공유

### 키 내보내기 (최초 세팅자)

```bash
git-crypt export-key ./git-crypt-key
# → 이 파일을 팀원에게 안전하게 전달
# → git-crypt-key는 절대 git에 올리지 않음
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
