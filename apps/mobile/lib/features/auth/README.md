# auth

## 역할

- 카카오, Apple, Google 로그인 화면과 사용자 인증 흐름을 담당한다.
- 실제 provider 연동과 토큰 저장 추상화는 `core/auth`에 둔다.

## 금지

- access token, refresh token, provider token을 로그로 출력하지 않는다.
- 임시 인증 우회 로직을 남기지 않는다.

