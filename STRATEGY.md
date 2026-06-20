# Portfolio Strategy — Platform Engineer (docs-only)

> 이 문서는 "source repo 없이 markdown 문서만으로 증명하는 Platform Engineer 포트폴리오"의 설계 전략이다.
> 실제 포트폴리오 작성은 이 전략을 기준선으로 진행한다.

---

## 0. 확정된 의사결정

| 항목 | 결정 | 비고 |
|---|---|---|
| 언어 | **케이스는 한국어(KR-only)** | 케이스 TL;DR·본문 모두 한국어. README 랜딩만 필요 시 KR/EN 허용 |
| 결과물 형태 | **순수 markdown 파일** | GitHub 네이티브 렌더링, 외부 빌드 의존 없음 |
| 다이어그램 | **Mermaid 우선** | md 안에서 바로 렌더링. 복잡한 것만 PNG 첨부 |
| 정체성 | **Platform Engineer를 척추로** | backend/frontend는 보조 증거 |

---

## 1. 핵심 진단 (Diagnosis)

이력서의 강점과 리스크:

- **강점**: 정량 지표가 살아있음 — 60,000s→3,600s(16배), OOM 해결, cost optimization 다수. on-prem ↔ cloud 양쪽 경험. 플랫폼 구축(멀티테넌시·관측·자동대응·IaC·CI/CD) 전 영역을 직접 운영.
- **강점 보강(최신 resume)**: ① 모놀리식 분해 → GKE 마이크로서비스 이관 + **Istio service mesh(canary/traffic split)** = "아키텍처 분해 + 점진적 배포"라는 Platform Engineer 핵심 서사. ② CI/CD에 **이미지 취약점 scan·base 이미지 재빌드 + Nexus 의존성 관리** = DevSecOps/공급망 보안.
- **리스크 1 — 범위가 너무 넓다**: infra + cloud + backend + CUDA/HPC + frontend까지 → "주력이 뭐지?"가 흐려짐.
- **리스크 2 — CUDA가 과대표집된다**: CUDA 행렬곱셈(3000²→100,000²)은 정량 지표가 가장 화려해서 방치하면 헤드라인을 차지하고 "CUDA 개발자"로 오인되게 만든다. **나는 CUDA 모듈 개발자가 아니라, 워크로드 병목을 진단하고 HPC 전략을 수립·조율하는 Platform Engineer다.**

**전략적 결론**: Platform Engineer(인프라·클라우드·SRE·플랫폼 구축)를 **척추**로 세운다. backend/frontend는 "플랫폼을 만드는 사람이 애플리케이션 레이어까지 이해한다"는 **보조 증거**로, CUDA/HPC는 "성능 병목을 진단하고 기술 선택을 주도한다"는 **의사결정 사례**로 배치한다. — 화려한 지표가 정체성을 가리지 않도록 의도적으로 비중을 조절한다.

---

## 2. source repo 부재를 메우는 4종 대체 증거

코드 저장소 대신 "사고의 산출물"로 신뢰를 만든다.

| 대체물 | 증명하는 것 | 이력서 내 소재 |
|---|---|---|
| **Before/After 아키텍처 다이어그램** | 시스템 설계 능력 | 이미 draw.io/plantuml 사용 → 강점 |
| **대표 설정/IaC 발췌** | "직접 손댔다"의 증거 | terraform, k8s yaml, alertmanager rule (sanitized) |
| **Postmortem / Runbook** | 운영 성숙도 (SRE 색채) | 온도 이상 graceful shutdown, OOM 대응, UPS/BMC |
| **공급망 보안 산출물** | DevSecOps 의식 | 이미지 취약점 scan stage, base 이미지 재빌드 정책, Nexus 의존성 관리 |

---

## 3. 깊이(case study) + 넓이(matrix) 분리

- **Flagship 4~5개**: 깊게 (STAR + 다이어그램 + 정량 결과)
- 나머지 역량: **competency matrix** 한 장으로 넓게 커버

### Flagship 후보 (Platform 정체성 우선 순)

> 정렬 기준을 "지표 화려함"이 아니라 **"Platform Engineer 역량을 얼마나 직접적으로 증명하는가"**로 둔다.

1. **연구용 GPU 플랫폼 멀티테넌시 구축** — user/group/권한 표준화, anaconda·컨테이너 jupyter GPU 배분, 용도별 RAID/스토리지(NFS·SAMBA) 설계. ← **"Platform" 정체성의 1순위 헤드라인.**
2. **모놀리식 → 마이크로서비스 (GKE) + Istio 점진적 배포** — websocket 모놀리스를 역할별·서비스별로 분해 → GKE 이관 → Istio(VirtualService/DestinationRule) canary·traffic split·retry/timeout/circuit breaking. ← **아키텍처 분해 + 무중단 점진적 배포, Platform 정체성을 가장 직접 증명.**
3. **관측·자동대응 체계 (SRE)** — prometheus 중앙화 + alertmanager webhook graceful shutdown(온도), EFK 로그·알람, BMC/UPS 원격관리. 운영 성숙도.
4. **안전한 CI/CD 배포 플랫폼 (DevSecOps)** — gitlab runner 파이프라인, MR별 디버깅 구조, **이미지 취약점 scan·base 이미지 재빌드, Nexus(npm/pip) 의존성 관리**, gitlab→YouTrack 연계 자동 State 전환, Claude token 최적화. 셀프서비스 + 공급망 보안.
5. **Cloud 마이그레이션 & 비용 최적화** — on-prem → Cloud Run(serverless)·Cloud SQL·ES 이관 + **Ray cluster 분산(60,000s→3,600s)·KEDA/pub-sub cost optimization**, terraform IaC. **"개발"이 아니라 "워크로드를 플랫폼으로 분산·확장하고 비용을 최적화"한 관점**으로 서술.

> **CUDA/HPC는 flagship에서 제외하고 보조 사례로 배치.** 단, 버리지 않고 *의사결정 스토리*로 재프레이밍한다 → "python profiler로 행렬곱 병목을 진단 → CPU 한계 판단 → GPU(cublasXt 멀티 GPU 분산)로 기술 선택 → 처리 가능 차원 약 30배↑". **포인트는 모듈 코드가 아니라 진단·기술선택·조율.**

> **elasticsearch 2억2천만건 document 들을 12개의 샤드로 split 해서** 기본적인 search 속도를 300초 쯤에서 40초 근처로 튜닝하고 , 파일시스템캐쉬와 주기적인 배치 쿼리 실행으로 캐싱으로 실제 사용자의 검색 속도를 크게 개선함 40s-> 200ms 미만

> **mysql explain 으로 query 튜닝 데이터 보강필요 포인트** 를 data manipulation 하는 바이오 쪽 연구원과 의견 조율함 ex: 동일쿼리구조이더라도 index-merge 적용 유무를 explain 으로 잡아내고 데이터 보강 포인트 설명하는 등의 업무 **mysql conf 쪽 tmp 사이즈 조절**로 innodb 엔진에서 쿼리 캐싱을 최대한 메모리에서 할 수 있도록함

> 그 외 보조 케이스(넓이로 처리): nodejs cluster/stream 성능, expressapp→nest 고도화, mysql 튜닝/GTID replication, mongodb·qdrant gRPC middleware, react class→hook.

---

## 4. 케이스 스터디 공통 템플릿

일관된 틀 자체가 프로페셔널리즘의 신호다. 모든 flagship은 아래 순서를 따른다.

```
1. TL;DR (한 줄 + 핵심 지표) — KR-only
2. 문제 / 맥락 (Problem & Context)
3. 제약조건 (Constraints)
4. 검토한 대안 + 선택 근거 (Options considered)
5. 아키텍처 (Before / After, Mermaid)
6. 구현 핵심 (대표 스니펫: IaC / config / code excerpt)
7. 정량 결과 (Results, 숫자 우선)
8. 회고 / 다음 단계 (Retrospective)
```

**원칙**: 각 케이스는 무조건 **숫자로 시작**한다. ("16배 단축", "처리 가능 차원 약 30배↑")

---

## 5. 디렉토리 구조 (제안)

```
README.md          # 랜딩: 한 줄 포지셔닝 + 핵심지표 3개 + 케이스 인덱스 (KR/EN)
STRATEGY.md        # (이 문서) 설계 기준선
case-studies/      # 심층 flagship 4~5개 (Platform 정체성 우선 순)
  01-gpu-platform-multitenancy.md
  02-monolith-to-microservices-gke-istio.md
  03-observability-autoremediation.md
  04-secure-cicd-delivery-platform.md
  05-cloud-migration-cost-optimization.md
  # CUDA/HPC는 보조 사례로 → competency/matrix.md 에서 의사결정 스토리로 다룸
competency/        # 역량 매트릭스 (넓이)
  matrix.md
architecture/      # 대표 시스템 다이어그램 모음
ops/               # SLO·alert rule 샘플·runbook·postmortem
snippets/          # 대표 IaC/config 발췌 (source repo 대체)
assets/            # 복잡한 다이어그램 PNG (Mermaid로 안 되는 경우만)
```

---

## 6. 작성 원칙 (Writing Principles)

1. **숫자 우선 (Metric-first)**: 모든 섹션 제목·요약에 정량 지표를 넣는다.
2. **의사결정 가시화**: "무엇을 했다"보다 "왜 그렇게 결정했나"를 강조.
3. **Mermaid 우선**: 외부 이미지 의존 최소화, 버전관리 가능하게.
4. **Sanitization 명시**: 고객사명·시크릿 제거하고 "기밀상 일반화함"을 표기 → 보안 의식 자체가 가산점.
5. **일관 템플릿**: 모든 flagship은 §4 템플릿을 그대로 따른다.

---

## 7. 진행 로드맵 (Roadmap)

- [x] **Phase 0** — 전략 확정 = 이 문서
- [x] **Phase 1** — 골격 잡기: README + 디렉토리 + 케이스 템플릿(`case-studies/_TEMPLATE.md`) + flagship 1개([01 GPU 플랫폼 멀티테넌시](case-studies/01-gpu-platform-multitenancy.md)) 샘플 완성
- [x] **Phase 2** — flagship 나머지 4개 작성 완료
  - [02 마이크로서비스+Istio](case-studies/02-monolith-to-microservices-gke-istio.md) · [03 SRE 관측·자동대응](case-studies/03-observability-autoremediation.md) · [04 DevSecOps CI/CD](case-studies/04-secure-cicd-delivery-platform.md) · [05 클라우드 마이그레이션·비용최적화](case-studies/05-cloud-migration-cost-optimization.md)
- [ ] **Phase 3** — competency matrix + ops 샘플
- [ ] **Phase 4** — snippets(IaC/config 발췌) 보강, 전체 톤·일관성 패스
  - 미결: ① "Claude token 최적화"(§3-4) 배치 결정 ② 각 케이스 Scope TODO 수치 채우기
