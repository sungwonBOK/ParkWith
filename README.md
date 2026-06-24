# ParkWith

ParkWith는 놀이공원과 워터파크처럼 넓은 여가 공간에서 방문 전 준비, 방문 중 일행 찾기, 방문 후 기록 정리를 돕는 모바일 앱입니다.

MVP의 핵심은 실시간 대기시간 예측이 아니라, 사용자가 실제 방문 흐름에서 바로 쓸 이유를 만드는 것입니다.

## Tech Stack

```text
Mobile App: Flutter
Backend API: NestJS
Database: PostgreSQL
Object Storage: S3-compatible storage
Auth: Kakao Login, Apple Login, Google Login
Map SDK: Kakao Map or Naver Map, choose the more stable Flutter integration; prefer Kakao if similar
```

## Repository Structure

```text
parkwith/
├─ apps/
│  ├─ mobile/          # Flutter app
│  └─ api/             # NestJS API server
├─ packages/
│  └─ contracts/       # API schema and shared contracts
├─ docs/
│  ├─ requirements/    # Product requirements and MVP scope
│  ├─ architecture/    # Architecture and module responsibility
│  ├─ policies/        # Location, battery, privacy policies
│  ├─ ai-rules/        # Rules for AI-assisted coding
│  ├─ testing/         # Test checklist
│  └─ roadmap/         # Post-MVP direction
└─ infra/              # Deployment and database infrastructure
```

## MVP Rule

Do not add real-time wait time prediction, automatic congestion analysis, in-app payment, official reservation integration, or unrestricted background location tracking during MVP.

## Start Here

1. Read `docs/requirements/MVP_SCOPE.md`.
2. Read `docs/architecture/ARCHITECTURE_GUIDE.md`.
3. For location work, read `docs/policies/LOCATION_BATTERY_POLICY.md` before coding.
4. For AI-assisted coding, follow `docs/ai-rules/AI_CODING_RULES.md`.
