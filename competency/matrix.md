<!-- Sanitized — 고객사명·시크릿·내부 식별자 제거. 일반화한 부분은 "(일반화함)"으로 표기. 미확정 수치는 TODO. -->

# Competency Matrix — 역량 지도

> 각 역량은 **심층 케이스 링크** 또는 **정량 미니사례**로 증거 링크.

---

## 1. 역량 매트릭스

| 영역 | 핵심 역량 | 증거 |
|---|---|---|
| **플랫폼 / 인프라** | 멀티테넌시(user·group·권한 표준화), GPU 배분, NFS·SAMBA·RAID 스토리지 설계 | [#01 GPU 플랫폼](../case-studies/01-gpu-platform-multitenancy.md) |
| **컨테이너 / 오케스트레이션** | Docker, Kubernetes(GKE), KubeRay, KEDA, Istio service mesh | [#02 마이크로서비스+Istio](../case-studies/02-monolith-to-microservices-gke-istio.md) · [#05 클라우드 이관](../case-studies/05-cloud-migration-cost-optimization.md) |
| **클라우드 / 비용 최적화** | on-prem↔cloud 이관, Cloud Run(serverless), Cloud SQL, scale-to-zero, FinOps 관점 | [#05 클라우드 이관](../case-studies/05-cloud-migration-cost-optimization.md) |
| **관측 / SRE** | Prometheus·Alertmanager, 자동대응(webhook), EFK, BMC/IPMI·UPS, graceful shutdown | [#03 관측·자동대응](../case-studies/03-observability-autoremediation.md) |
| **CI/CD / DevSecOps** | GitLab CI/CD, 이미지 취약점 스캔 게이트, base 재빌드, Nexus 의존성 일원화, 이슈-배포 연계 | [#04 안전한 CI/CD](../case-studies/04-secure-cicd-delivery-platform.md) |
| **IaC** | Terraform(프로비저닝·상태관리·재현성) | [#05 클라우드 이관](../case-studies/05-cloud-migration-cost-optimization.md) |
| **데이터 스토어 / 튜닝** | Elasticsearch 샤딩·캐싱, MySQL explain 튜닝·GTID replication, MongoDB, redis-edge , qdrant | [#2 정량 미니사례](#2-정량-미니사례-quantified-mini-cases) |
| **HPC / 성능** | 병목 진단(profiler) → 기술 선택 → 분산(CUDA cublasXt 멀티 GPU / Ray) | [#2 정량 미니사례](#2-정량-미니사례-quantified-mini-cases) · [#05](../case-studies/05-cloud-migration-cost-optimization.md) |
| **백엔드 (보조 증거)** | Node.js cluster/stream 성능, Express→NestJS 고도화, gRPC middleware | [#3 그 외 보조 역량](#3-그-외-보조-역량) |
| **프론트엔드 (보조 증거)** | MuiTheme 기반의 공통 component들(Input,Table,Tree,FileAttatchDialog) 개발 , React class component → hook 전환 | [#3 그 외 보조 역량](#3-그-외-보조-역량) |

---

## 2. 정량 미니사례 (Quantified Mini-Cases)

> 심층 케이스로 빼진 않았지만 정량 지표가 분명한 작업들. 각 항목은 **진단 → 조치 → 결과** 순.

### (a) Elasticsearch — 2.2억 문서 검색 300s → 200ms 미만

- **진단**: 약 2억 2천만 건 문서에 대한 검색이 기본 구성에서 약 300초 → 사실상 사용 불가.
- **조치**: 인덱스를 **12개 샤드로 분할**해 검색을 병렬화(→ 약 40초). 추가로 **파일시스템 캐시 활용 + 주기적 배치 쿼리로 캐시 워밍**해 실사용 경로를 가속.
- **결과**: 튜닝 검색 **≈300s → 40s**, 캐시 워밍 후 실사용자 검색 **40s → 200ms 미만**.

### (b) MySQL — explain 기반 쿼리 튜닝 + 도메인 협업

- **진단**: `EXPLAIN`으로 동일 구조 쿼리에서도 **index-merge 적용 유무**가 갈리는 지점을 잡아냄.
- **조치**: 데이터를 다루는 바이오 도메인 연구원과 **데이터 보강 포인트를 조율**(인덱스가 타도록 데이터/쿼리 형태 정리). `my.cnf`의 tmp table 크기를 조절해 **InnoDB가 임시 결과를 디스크가 아닌 메모리에서 처리**하도록 유도.
- **결과**: 동일 쿼리의 실행계획을 인덱스 경로로 고정, 임시테이블 디스크 스필 감소. TODO: 전후 응답시간 수치.

### (c) CUDA / HPC — 병목 "진단·기술선택"으로서의 GPU 분산

- **진단**: Python profiler로 대형 **행렬곱이 병목**임을 특정 → CPU 단일 처리로는 한계 판단.
- **조치**: **cublasXt 기반 멀티 GPU 분산**으로 기술 선택(행렬을 GPU들에 타일 분할).
- **결과**: 처리 가능한 행렬 차원 **약 3,000² → 100,000² (차원 기준 약 30배↑)**.

---

## 3. 그 외 보조 역량

- **Node.js**: cluster/stream으로 처리량·메모리 개선
- **NestJS**: Express 앱을 NestJS 구조로 고도화(모듈·DI·테스트 용이성)
- **MySQL 가용성**: GTID 기반 replication 구성
- **redis-edge**: 10GB 정도의 large json caching 을 달성
- **데이터 미들웨어**: MongoDB, qdrant 연동 gRPC middleware
- **Frontend**: MuiTheme 기반의 공통 component들(Input,Table,Tree,FileAttatchDialog) 개발 , React class component → hook 전환