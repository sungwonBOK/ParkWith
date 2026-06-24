# location_engine

## 역할

- 위치 수집을 추상화한다.
- Flutter 패키지 또는 Native 위치 엔진을 교체 가능하게 만든다.
- 배터리 정책을 한곳에서 계산한다.

## 금지

- 화면 코드에서 직접 위치 패키지를 호출하지 않는다.
- 5초 이하 고정 주기 업로드를 기본값으로 만들지 않는다.
- 위치 좌표를 로그로 출력하지 않는다.
- 방문 종료 후 위치 스트림을 유지하지 않는다.

## 관련 문서

- `docs/policies/LOCATION_BATTERY_POLICY.md`
- `docs/policies/DATA_PRIVACY_POLICY.md`

