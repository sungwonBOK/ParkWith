# ParkWith Mobile

Flutter 기반 모바일 앱입니다.

## 책임

- 방문 전 장소/할인/체크리스트 UI
- 방문 중 일행방, 위치 공유, 시설 지도 UI
- 위치 권한과 위치 공유 상태 제어
- 사진/방문 기록 UI

## 중요한 구조

```text
lib/
├─ app/
├─ core/
├─ features/
└─ shared/
```

위치 수집은 `core/location_engine`에 숨기고, 일행방 안에서 위치 공유를 켜고 끄는 기능은 `features/location_sharing`에서 구현합니다.
