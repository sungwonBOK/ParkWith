# API Modules

각 도메인은 NestJS module 단위로 나눕니다.

```text
modules/
├─ venues/
├─ deals/
├─ trip-rooms/
├─ location-sharing/
├─ saved-places/
├─ lost-items/
└─ visit-records/
```

모듈 내부 기본 구조:

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

