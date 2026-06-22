<!-- Sanitized — 프로젝트 ID·시크릿·실명 리전/네트워크 식별자는 변수로 외부화. 예시 값은 *.tfvars.example 참고. -->

# Terraform — GCP 인프라 (포트폴리오 대표 구성)

[`architecture/gke-istio-4.drawio`](../architecture/gke-istio-4.drawio) (#02) 와
[`architecture/gke-kuberay-keda-1.drawio`](../architecture/gke-kuberay-keda-1.drawio) (#05)
다이어그램에 등장하는 **GCP 리소스**를 코드화한 모듈형 Terraform입니다.
실제 운영 코드를 일반화/sanitize 한 **대표 예시**이며, 그대로 `apply` 하기 전에
`*.tfvars` 의 `project_id` 등 식별자를 채워야 합니다.

## 구조

```
terraform/
├── modules/                  # 재사용 가능한 단위 모듈 (provider-agnostic 입력)
│   ├── project-services/     # 필요한 GCP API 활성화
│   ├── network/              # VPC · subnet(secondary range) · Cloud NAT · PSA
│   ├── gke/                  # GKE(VPC-native, WI, private) + 노드풀(map, NAP)
│   ├── artifact-registry/    # 컨테이너 이미지 레지스트리
│   ├── cloud-run/            # serverless 백엔드 (scale-to-zero)
│   ├── app-engine/           # 프론트엔드(react) 호스팅 부트스트랩
│   ├── pubsub/               # 이벤트 큐 (topic + subscription)  [#05]
│   ├── cloud-sql/            # MySQL (private IP, PSA)            [#02]
│   ├── secret-manager/       # DB/ES 자격증명 등 시크릿
│   ├── filestore/            # 공유 파일시스템 (CSI)              [#02]
│   ├── cloud-deploy/         # 점진 배포 파이프라인               [#02]
│   └── k8s-addons/           # helm: istio / keda / kuberay
└── stacks/                   # 모듈을 조립한 환경별 루트(=composition)
    ├── istio-microservices/  # #02 (gke-istio-4)
    └── kuberay-keda/         # #05 (gke-kuberay-keda-1)
```

## 다이어그램 → 모듈 매핑

| GCP 리소스 | 모듈 | #02 | #05 |
|---|---|:--:|:--:|
| GKE 클러스터 + 노드풀(NAP) | `gke` | ✅ | ✅ |
| Artifact Registry | `artifact-registry` | ✅ | ✅ |
| Cloud Run (nestjs) | `cloud-run` | ✅ | ✅ (min=0) |
| App Engine (react) | `app-engine` | ✅ | ✅ |
| Secret Manager | `secret-manager` | ✅ | ✅ |
| Cloud Deploy | `cloud-deploy` | ✅ | — |
| Cloud SQL (MySQL) | `cloud-sql` | ✅ | — |
| Filestore | `filestore` | ✅ | — |
| Pub/Sub | `pubsub` | — | ✅ |
| VPC / NAT / PSA | `network` | ✅ | ✅ |
| API 활성화 | `project-services` | ✅ | ✅ |
| Istio (mesh) | `k8s-addons` | ✅ | — |
| KEDA + KubeRay | `k8s-addons` | — | ✅ |

> **#05 데이터 계층(Cloud SQL/Mongo/ES/Redis)** 은 해당 다이어그램에서 의도적으로
> 제거됐으므로 `kuberay-keda` 스택에도 포함하지 않습니다.
>
> **Elasticsearch** ("Elastic on GCP", #02) 는 Elastic Cloud(`ec` provider)/마켓플레이스로
> 프로비저닝되며 `google` provider 리소스가 아니라 본 코드 범위 밖입니다.
>
> **HTTP(S) LB** 는 #02 의 경우 GKE Gateway/Ingress(Service `type=LoadBalancer`)가
> 자동 생성하고, App Engine/Cloud Run 은 자체 엔드포인트를 가지므로 별도 `compute_*`
> 리소스로 만들지 않았습니다.

## 사용

```bash
cd stacks/kuberay-keda          # 또는 stacks/istio-microservices
cp terraform.tfvars.example terraform.tfvars   # project_id 등 채우기
# (선택) 원격 상태: backend.tf 의 gcs 블록 주석 해제 후
terraform init
terraform plan
terraform apply
```

## 메모

- provider: `google`/`google-beta` ~> 6.0, `kubernetes` ~> 2.30, `helm` ~> 2.12, `random` ~> 3.6
- 테넌트 격리(#05): 노드풀 label/taint + 런타임의 pod anti-affinity 로 강제 (격리 주체 = KEDA batch-worker).
- 모든 시크릿 값은 Terraform 으로 만들지 않고 Secret Manager **컨테이너만** 생성 후 값은 외부 주입을 권장.
