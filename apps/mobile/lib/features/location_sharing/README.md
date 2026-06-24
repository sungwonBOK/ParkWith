# location_sharing

## 역할

- 방문 세션 중 일행 위치 공유를 담당한다.
- 위치 공유 ON/OFF 상태를 관리한다.
- 일행의 마지막 위치를 표시한다.
- 위치 업로드와 조회 use case를 제공한다.

## 구조

```text
location_sharing/
├─ data/
├─ domain/
├─ presentation/
└─ README.md
```

## 금지

- 방문 시작 전 위치 공유 금지
- 방문 종료 후 위치 전송 금지
- 사용자 동의 없는 백그라운드 위치 추적 금지
- 위치 좌표 로그 출력 금지

