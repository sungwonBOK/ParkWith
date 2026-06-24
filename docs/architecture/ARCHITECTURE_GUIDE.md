# Architecture Guide

## 기본 원칙

이 프로젝트의 구조는 사람과 AI가 쉽게 이어받을 수 있도록 기능 단위로 나눕니다.

핵심 원칙:

- 기능별 폴더를 기준으로 코드를 찾을 수 있어야 한다.
- 화면, 비즈니스 규칙, API 연결 코드를 섞지 않는다.
- 위치 공유처럼 위험도가 높은 기능은 정책과 엔진을 분리한다.
- 공통 코드는 실제 반복이 생긴 뒤 `shared` 또는 `core`로 이동한다.

## 전체 구조

```text
parkwith/
├─ apps/
│  ├─ mobile/
│  └─ api/
├─ packages/
│  └─ contracts/
├─ docs/
└─ infra/
```

## Flutter 앱 구조

```text
apps/mobile/lib/
├─ app/
│  ├─ router/
│  ├─ theme/
│  ├─ app.dart
│  └─ bootstrap.dart
├─ core/
│  ├─ api/
│  ├─ auth/
│  ├─ config/
│  ├─ errors/
│  ├─ permissions/
│  ├─ storage/
│  ├─ logging/
│  └─ location_engine/
├─ features/
│  ├─ auth/
│  ├─ venue/
│  ├─ deal/
│  ├─ cost_calculator/
│  ├─ checklist/
│  ├─ trip_room/
│  ├─ location_sharing/
│  ├─ venue_map/
│  ├─ saved_place/
│  ├─ lost_item/
│  └─ visit_record/
└─ shared/
   ├─ widgets/
   ├─ models/
   ├─ utils/
   └─ constants/
```

## Flutter Feature 규칙

각 feature는 다음 구조를 기본으로 합니다.

```text
feature_name/
├─ data/
│  ├─ *_api.dart
│  ├─ *_repository_impl.dart
│  └─ *_dto.dart
├─ domain/
│  ├─ *_model.dart
│  ├─ *_repository.dart
│  └─ use_cases/
├─ presentation/
│  ├─ *_screen.dart
│  ├─ *_controller.dart
│  └─ widgets/
└─ README.md
```

책임:

- `presentation`: 화면, 사용자 입력, 표시 상태
- `domain`: 비즈니스 규칙, 정책, use case, repository 인터페이스
- `data`: API, 로컬 저장소, DTO, repository 구현체

## 위치 공유 구조

위치 공유는 두 영역으로 나눕니다.

```text
core/location_engine/
```

역할:

- 실제 위치 수집 추상화
- 권한 확인
- 배터리 정책 계산
- Native 최적화 진입점

```text
features/location_sharing/
```

역할:

- 일행방 안에서 위치 공유를 켜고 끄는 기능
- 위치 공유 상태 표시
- 마지막 위치 조회/업로드 use case

이렇게 분리하면 나중에 Native 위치 엔진을 붙여도 화면과 도메인 구조가 흔들리지 않습니다.

MVP에서는 사용자의 이동 경로를 저장하지 않고, 각 사용자별 최신 위치 스냅샷만 저장합니다. 새 위치가 올라오면 이전 위치를 덮어쓰는 방식으로 시작합니다.

## 인증 구조

MVP 인증은 카카오, Apple, Google 로그인을 지원합니다.

```text
core/auth/
```

역할:

- 소셜 로그인 provider 추상화
- 인증 토큰 저장/갱신
- 현재 사용자 세션 관리

```text
features/auth/
```

역할:

- 로그인 화면
- 로그인 provider 선택 UI
- 로그아웃 흐름

서버에서는 사용자 식별을 `User` 모델로 관리하고, 일행방 권한과 작성자 권한은 `userId`를 기준으로 판단합니다.

## 초기 데이터 운영

MVP에서는 장소, 시설, 할인 정보를 수동 seed 데이터로 관리합니다.

권장 흐름:

1. JSON/CSV로 초기 장소와 시설 데이터를 관리한다.
2. 서버 seed 또는 migration 보조 스크립트로 DB에 입력한다.
3. 할인 정보에는 `lastUpdatedAt`과 가격 변동 가능성을 표시한다.
4. 관리자 페이지와 크롤링은 MVP 이후 운영 필요성이 검증되면 도입한다.

## 지도 SDK 선택

지도 SDK는 Flutter 연동 안정성을 최우선으로 선택합니다.

우선순위:

1. Flutter에서 안정적으로 동작하는 SDK 또는 WebView 연동 방식
2. 시설 마커, 커스텀 좌표, 지도 오버레이 구현 난도
3. 국내 장소 좌표 정확도
4. 상업 이용과 요금 정책

카카오맵과 네이버지도의 안정성이 비슷하면 카카오맵을 우선 검토합니다.

## NestJS API 구조

```text
apps/api/src/
├─ main.ts
├─ app.module.ts
├─ common/
├─ config/
├─ modules/
│  ├─ venues/
│  ├─ deals/
│  ├─ auth/
│  ├─ users/
│  ├─ trip-rooms/
│  ├─ location-sharing/
│  ├─ saved-places/
│  ├─ lost-items/
│  ├─ visit-records/
│  └─ visit-reports/
└─ database/
   ├─ migrations/
   └─ seeds/
```

각 API module은 다음 구조를 기본으로 합니다.

```text
module-name/
├─ module-name.module.ts
├─ module-name.controller.ts
├─ module-name.service.ts
├─ module-name.repository.ts
├─ dto/
├─ entities/
└─ policies/
```

## API 계약

API 응답 구조는 일관되게 유지합니다.

```json
{
  "success": true,
  "data": {},
  "error": null
}
```

```json
{
  "success": false,
  "data": null,
  "error": {
    "code": "LOCATION_PERMISSION_REQUIRED",
    "message": "위치 권한이 필요해요."
  }
}
```

공통 API 스키마는 `packages/contracts`에 둡니다.
