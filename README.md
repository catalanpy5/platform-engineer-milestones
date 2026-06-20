# Platform Engineer Portfolio

> **온프레미스부터 클라우드까지, 연구·제품 워크로드를 받쳐주는 플랫폼을 설계·구축·운영합니다.**
> Designing, building, and operating the platforms that carry research & product workloads — from bare metal to cloud.

이 포트폴리오는 source repository 대신 **설계 의사결정 · 아키텍처 · 정량 결과**로 역량을 증명하는 문서 모음입니다.
This portfolio proves competency through **design decisions, architecture, and measurable outcomes** rather than source repositories.

> ⚠️ 모든 사례는 고객사명·시크릿·내부 식별자를 제거하고 일반화했습니다. (Sanitized — no client names, secrets, or internal identifiers.)

---

## 핵심 지표 (Highlights)

| 지표 | 내용 |
|---|---|
| **16×** | 대규모 워크로드 처리 시간 단축 (60,000s → 3,600s, Ray 분산 + 비용 최적화) |
| **무중단 배포** | 모놀리스 → GKE 마이크로서비스 분해 + Istio canary/traffic split |
| **자동 대응** | 온도 임계 초과 시 graceful shutdown 등 webhook 기반 self-remediation |

> TODO: 위 표의 정량 지표는 실제 수치로 검증·보강 예정 (예: cost 절감 %, 마이그레이션 다운타임, MTTR).

---

## 무엇을 하는 사람인가 (What I do)

- **플랫폼 구축**: 멀티테넌트 GPU 환경, 사용자·권한 체계, 스토리지/네트워크 표준화
- **클라우드 & IaC**: on-prem → GCP/AWS 마이그레이션, terraform 기반 재현 가능한 인프라
- **컨테이너 & 오케스트레이션**: GKE, Istio service mesh, k8s 기반 분산/스케일링
- **관측성 & SRE**: prometheus/EFK, alertmanager 기반 자동 대응, BMC/UPS 운영
- **DevSecOps**: CI/CD 파이프라인, 이미지 취약점 scan, 아티팩트(Nexus) 의존성 관리

> backend(mysql/es/mongo/qdrant/nodejs)·HPC(CUDA/Ray)·frontend는 "플랫폼을 만드는 사람이 애플리케이션 레이어까지 이해한다"는 보조 증거로 다룹니다.

---

## 사례 인덱스 (Case Studies)

| # | 사례 | 핵심 역량 | 상태 |
|---|---|---|---|
| 01 | [연구용 GPU 플랫폼 멀티테넌시 구축](case-studies/01-gpu-platform-multitenancy.md) | 플랫폼 구축 · 멀티테넌시 | ✅ Draft |
| 02 | 모놀리식 → 마이크로서비스 (GKE) + Istio 점진적 배포 | 아키텍처 분해 · 점진적 배포 | ⏳ Planned |
| 03 | 관측·자동대응 체계 (SRE) | 관측성 · self-remediation | ⏳ Planned |
| 04 | 안전한 CI/CD 배포 플랫폼 (DevSecOps) | CI/CD · 공급망 보안 | ⏳ Planned |
| 05 | Cloud 마이그레이션 & 비용 최적화 | 마이그레이션 · cost opt | ⏳ Planned |

> 보조 사례(넓이): [역량 매트릭스](competency/matrix.md) · 의사결정 기록: [decisions/](decisions/)

---

## 문서 구조 (Repository Map)

```
case-studies/   # 심층 사례 (flagship)
competency/     # 역량 매트릭스 (넓이)
architecture/   # 대표 시스템 다이어그램
decisions/      # DECISION (Architecture Decision Records)
ops/            # SLO · alert rule · runbook · postmortem
snippets/       # 대표 IaC / config 발췌
STRATEGY.md     # 이 포트폴리오의 설계 전략
```
