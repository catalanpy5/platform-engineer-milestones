---
title: "Portfolio"
toc: true
toc_label: "목차"
toc_icon: "bars"
---

# Platform Engineer Portfolio

> **온프레미스부터 클라우드까지, 연구·제품 워크로드를 받쳐주는 플랫폼을 설계·구축·운영합니다.**

> ⚠️ 모든 사례는 고객사명·시크릿·내부 식별자를 제거하고 일반화했습니다.

이 포트폴리오는 **설계 의사결정 · 아키텍처 · 정량 결과**로 역량을 증명하는 문서 모음입니다.

> 📧 : woojungwoo34@gmail.com 🥇 : https://www.credly.com/users/jungwoo-woo/edit/badges/credly

---

## 핵심 지표 (Highlights)

| 지표 | 내용 | 근거 |
|---|---|---|
| **대형 워크로드 처리시간 ≈16배 단축** | 단일 머신 순차 처리 ≈60,000s → KubeRay pod 분산 ≈3,600s | [#05](case-studies/05-cloud-migration-cost-optimization.md) |
| **처리 규모 45k→80k dim, OOM 제거** | 단일 pod 메모리 천장을 여러 pod로 분산 돌파 | [#05](case-studies/05-cloud-migration-cost-optimization.md) |
| **월 비용 ≈50%↓ (700→350만)** | Cloud Run scale-to-zero + KEDA 큐 기반 0↔N | [#05](case-studies/05-cloud-migration-cost-optimization.md) |
| **동시 수용 고객사 3→10** | KEDA 노드 격리로 cross-tenant OOM kill 제거 | [#05](case-studies/05-cloud-migration-cost-optimization.md) |
| **무중단 점진적 배포** | WebSocket 모놀리스 분해 + Istio 카나리/트래픽 분할 | [#02](case-studies/02-monolith-to-microservices-gke-istio.md) |
| **온도 이상 무인 자동대응** | 임계 초과 시 학습 잡 graceful shutdown → 노드 격리 → 통보 | [#03](case-studies/03-observability-autoremediation.md) |
| **공급망 보안 내장 CI/CD** | 이미지 취약점 스캔 게이트 + Nexus 의존성 일원화 | [#04](case-studies/04-secure-cicd-delivery-platform.md) |
| **검색 300s → 200ms 미만** | 2.2억 문서 ES 12샤드 분할 + 캐시 워밍 | [matrix §2](competency/matrix.md) |

---

## 무엇을 하는 사람인가 (What I do)

- **플랫폼 구축**: 멀티테넌트 GPU 환경, 사용자·그룹·권한 표준화, 스토리지(NFS·SAMBA·RAID)/네트워크 설계 — [#01](case-studies/01-gpu-platform-multitenancy.md)
- **클라우드 & IaC**: on-prem → GCP 마이그레이션, Terraform 기반 재현 가능한 인프라 — [#05](case-studies/05-cloud-migration-cost-optimization.md)
- **컨테이너 & 오케스트레이션**: GKE, Istio service mesh, KubeRay·KEDA 기반 분산/스케일링 — [#02](case-studies/02-monolith-to-microservices-gke-istio.md) · [#05](case-studies/05-cloud-migration-cost-optimization.md)
- **관측성 & SRE**: Prometheus/EFK, Alertmanager 기반 자동 대응, BMC/IPMI/UPS 운영 — [#03](case-studies/03-observability-autoremediation.md)
- **DevSecOps**: GitLab CI/CD 파이프라인, 이미지 취약점 스캔, 아티팩트(Nexus) 의존성 관리 — [#04](case-studies/04-secure-cicd-delivery-platform.md)

> backend(MySQL/ES/Mongo/qdrant/Node.js)·HPC(CUDA/Ray)·frontend는 "플랫폼을 만드는 사람이 애플리케이션 레이어까지 이해한다"는 **보조 증거**로 다룹니다. → [역량 매트릭스](competency/matrix.md)

---

## 사례 인덱스 (Case Studies)

| # | 사례 | 핵심 역량 | 대표 결과 |
|---|---|---|---|
| 01 | [연구용 GPU 플랫폼 멀티테넌시 구축](case-studies/01-gpu-platform-multitenancy.md) | 플랫폼 구축 · 멀티테넌시 | 공용 PC → user/group 표준화·GPU 배분·공유 스토리지를 갖춘 셀프서비스 연구 플랫폼 |
| 02 | [모놀리식 → 마이크로서비스(GKE) + Istio 점진적 배포](case-studies/02-monolith-to-microservices-gke-istio.md) | 아키텍처 분해 · 점진적 배포 | 전체 재시작 배포 → 서비스 단위 카나리 무중단 배포, blast radius 축소 |
| 03 | [관측·자동대응 체계 (SRE)](case-studies/03-observability-autoremediation.md) | 관측성 · self-remediation | 사후 수동 발견 → 온도 임계 시 graceful shutdown 무인 1차 대응 |
| 04 | [안전한 CI/CD 배포 플랫폼 (DevSecOps)](case-studies/04-secure-cicd-delivery-platform.md) | CI/CD · 공급망 보안 | 수작업 배포 → 셀프서비스 파이프라인 + 취약점 스캔·의존성 일원화 |
| 05 | [Cloud 마이그레이션 & 비용 최적화](case-studies/05-cloud-migration-cost-optimization.md) | 마이그레이션 · cost opt | 처리시간 ≈16배↓ · 처리규모 45k→80k dim · 비용 ≈50%↓ · 고객사 3→10 |

> 케이스 간 연결: [#01]에서 "규모 커지면 동적 분산이 다음 단계"로 남긴 과제를 [#05]에서 KubeRay·KEDA로 실제 구현 → [#01]의 관측 공백을 [#03]에서 보완.

---

## 역량 매트릭스 (Competency Matrix)

전체 역량 지도와 정량 미니사례는 → **[competency/matrix.md](competency/matrix.md)**

| 영역 | 핵심 역량 | 증거 |
|---|---|---|
| 플랫폼 / 인프라 | 멀티테넌시·GPU 배분·NFS/SAMBA/RAID 스토리지 | [#01](case-studies/01-gpu-platform-multitenancy.md) |
| 컨테이너 / 오케스트레이션 | Docker, GKE, KubeRay, KEDA, Istio | [#02](case-studies/02-monolith-to-microservices-gke-istio.md) · [#05](case-studies/05-cloud-migration-cost-optimization.md) |
| 클라우드 / 비용 최적화 | on-prem↔cloud 이관, Cloud Run, scale-to-zero, FinOps | [#05](case-studies/05-cloud-migration-cost-optimization.md) |
| 관측 / SRE | Prometheus·Alertmanager, 자동대응, EFK, BMC/IPMI·UPS | [#03](case-studies/03-observability-autoremediation.md) |
| CI/CD / DevSecOps | GitLab CI/CD, 취약점 스캔 게이트, Nexus 의존성 일원화 | [#04](case-studies/04-secure-cicd-delivery-platform.md) |
| IaC | Terraform(프로비저닝·상태관리·재현성) | [#05](case-studies/05-cloud-migration-cost-optimization.md) |
| 데이터 스토어 / 튜닝 | Elasticsearch 샤딩·캐싱, MySQL explain·GTID, MongoDB, redis, qdrant | [matrix §2](competency/matrix.md) |
| HPC / 성능 | profiler 병목 진단 → 분산(CUDA cublasXt / Ray) | [matrix §2](competency/matrix.md) · [#05](case-studies/05-cloud-migration-cost-optimization.md) |

**정량 미니사례 발췌** (→ [상세](competency/matrix.md))
- **Elasticsearch**: 2.2억 문서 검색 ≈300s → 12샤드 분할 ≈40s → 캐시 워밍 후 **200ms 미만**
- **CUDA / HPC**: cublasXt 멀티 GPU 분산으로 처리 행렬 차원 **약 3,000² → 100,000² (≈30배)**
- **MySQL**: `EXPLAIN` 기반 index-merge 경로 고정 + tmp table 튜닝으로 디스크 스필 감소

---

## 문서 구조 (Repository Map)

```
case-studies/   # 심층 사례 (#01~#05)
competency/     # 역량 매트릭스 + 정량 미니사례
architecture/   # 대표 시스템 다이어그램
snippets/       # 대표 IaC / config 발췌
```
