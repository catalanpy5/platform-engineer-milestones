[인프라구축]
- 연구용 GPU Workstation 환경을 구축하고 사용자·그룹·권한 체계를 표준화하여 연구 목적별 플랫폼 운영 환경을 구성
- 관리자로서 유저및 그룹관리 , 유저별 그룹 설정하고 유저별 용도에 맞춘 platform 구축하고 관리함 : ex) 연구용 anaconda , 컨테이너 기반 jupyter notebook 구축시 gpu 배분
- 방화벽 관리 : ex) ufw , firewall-cmd 로 rule 설정
- batch job 작성함 : ex) open SSL 인증서 갱신 , DR 용 백업 , cloud bucket 경로에 축적된 고객사 데이터들 백업
- 인스턴스별 용도에 맞춘 RAID 초기 구성함 : ex) mysql iowait 낮추기 위한 RAID10 구성 , NFS 서버용 RAID 
- prometheus 를 on-premise 별 설치 후 관리 중앙화
- prometheus alert manager 의 rule 별 조건 설정 후 webhook 방식으로 서버제어 구축/관리 ( 예: 설정 온도 이상 발생시 gracefully shutdown )
- EFK 스택 구축 후 서비스별 로그관리 알람 연동
- UPS 관리 체계 구축/관리
- on-premise 호스트 별 BMC 원격 관리체계 구축/관리
- 비정형 데이터 배치잡의 repository 용 SAMBA/NFS server 구축/관리
- NVIDIA Dynamo 적용한 Local LLM 구축 후 모니터링/Scaling by k8s
[documentation]
- 설계 시 Figma 또는 draw.io 로 시스템 디자인 , presentation 을 팀원에게 공유
- 개발 또는 도입해야하는 stack 의 feature 를 설명할 부분들을 plantuml 로 반영 후의 sequence 작성
[cloud gcp]
- 각 gcp 에서의 구축된 내역들을 terraform 으로 배포 코드 작성 ( IaC )
- 기존 on-premise 기반의 서비스들(nodejs 기반 서비스들)을 Cloud Run , Cloud App 들을 이용하여 serverless 로 migration 하고 구축함
- 기존 single on-premis 에서 out of memory 로 동작의 한계가 있던 workload 를 kubernetes Ray cluster 로 분산하는 프로젝트 담당하고 cost optimization 수행함 ( pub-sub 기반 keda 활용 )
- 기존 on-premise 에 구축했던 모놀리식 구조 중 websocket server 의 구성요소들을 역할별로 나누고 다시 서비스별로 나눈 다음 GKE 클러스터의 deploy 대상들로 이관함
- GKE 에 Istio service mesh 를 도입하여 서비스 간 트래픽 관리 및 배포 전략을 구축함 : VirtualService / DestinationRule 기반으로 canary 배포 및 traffic split 을 적용하고, retry·timeout·circuit breaking 으로 배포 중 장애 전파를 최소화함
- 기존 on-premis 의 mysql 을 Cloud SQL 로 이관하고 성능 및 cost optimization 수행함
- 기존 on-premis 의 elasticsearch 를 Cloud Compute Engine 로 이관하고 성능 및 cost optimization 수행함
- Cloud Pub-Sub 과 Cloud monitoring 을 조합하여 기준을 설정한 모니터링 및 알람 체계 구축함
- GCP deployment Manager 로 GCP 프로젝트 close 및 re-open 에 대응함
[aws]
- 기존 on-premise 의 source-replica 구조의 mysql 을 mysql serverless aurora 로 전환

[backends]
## mysql
- ERD 로 mysql rdb 스키마 설계 및 구축, 구축 후 실행 계획 기반 쿼리 튜닝 
InnoDB 관련 옵션 튜닝 , 쿼리구조 분석 후 쿼리 개선 , 데이터 분석용 테이블 설계를 위한 관계도 작성 , 관계도 작성은 연구과제 요청에 기반하여 작성
- REST API 개발에 맞춰 마스터 table , 참조 table 구조로 설계함
- docker swarm 기반 mysql source (production) , replica ( service dbms ) 사이의 replication by GTID 구조로 개선 후 CRUD에 의한 manipulation 발생 시 발생할 수 있는 risk 들을 application 의 DBMS 에 최소화 시킴 
- mysqlsh 유틸로 주기적 데이터백업 전략 수립
## non-sql 
- docker swarm 기반 elasticsearch cluster 및 replica 구조 구축
- 비정형 데이터들을 elasticsearch 에 구축하기 위한 정형화 담당함 ( python BeautifulSoap xml parsing )
- 구축된 mongodb 를 backend source 로 하는 middleware 를 grpc 인터페이스로 구축하여 제품의 API 서버에서 의학,생명공학 용어 검색기능에 활용할 수 있게 함
- 비정형 데이터들을 mongodb 에 구축하기 위한 정형화 담당함 ( 웹크롤러로 수집 후 parsing )
- 구축된 mongodb 를 backend source 로 하는 middleware 를 grpc 인터페이스로 구축하여 제품의 API 서버에서 키워드 검색기능에 활용할 수 있게 함
- 비정형 데이터들을 qdrant vectordb 에 구축하기 위한 정형화 담당함 ( python BeautifulSoap xml parsing )
- 구축된 qdrant vectordb 의 기존 컨테이너 이미지 중 Rust 코드를 수정한 custom 컨테이너 이미지로 빌드하는 파이프라인 구축
- 구축된 qdrant vectordb 를 backend source 로 하는 middleware 를 grpc 인터페이스로 구축하여 제품의 API 서버에서 vectordb 검색기능에 활용할 수 있게 함
- qdrant 를 기존 솔루션에 적용할 AI agent 의 RAG 구성 내 vector DB 로 설정하고 interface 구축하고 vector DB 의 담당자와 indexing , optimization 을 조율하면서 kubernetes cluster 로 전환함
## nodejs
- nodejs expressapp 기반의 REST API 서버 설계 및 구축
- 제품 관련 서비스의 REST API 개발 + 유저,권한,메뉴 관리 REST API 개발
- nodejs 성능 문제 파악 후 nodejs cluster 도입 후 nodejs 의 request 병목 (single thread에 의해 발생할 수 있는) 현상 해결
- nodejs 의 V8 에서 다룰 수 없는 큰 사이즈의 데이터를 response 내려주는 부분을 분석해낸 후 nodejs stream 에 기반한 처리로 큰 chunk 의 데이터를 안정적으로 서비스할 수 있도록 기여
- nodejs 기반 middleware 설계 및 개발,구축 ( jwt , redis , rabbitmq 연동하는 middleware )
 - 로그인 과정의 authenticator 역할을 위한 jwt 연동 middleware 구축
 - cache layer 역할의 redis 서버를 도커로 가상화 , nodejs 기반 middleware 로 연동 후 응답속도가 느린 response 를 cache 처리하여 개선실현
 - message driven 구조 도입을 위한 rabbitmq 서버 도커로 가상화 및 구축 , message driven 도입 후 서버의 성능 이슈를 감지하도록 하여 OOM 예방 및 서비스 처리시 message driven 방식으로 서버 장애 사전감지 및 대비
 - expressapp -> nest 고도화 프로젝트 수행
## python , cuda , 대규모 그래프 알고리즘 수행을 위한 HPC 전략수립 및 실행
- 그래프 알고리즘 python 모듈들을 cython 전환 모듈들로 개발 후 기존 python 모듈에 비해 확연한 속도 개선을 함
- ray multiprocessing 을 활용하여 직렬화된 기존 매우 느린 스크립트 흐름을 우선 python profiler 로 진단하고 병렬화하는 개발을 진행, 6만초 -> 3600초 의 큰 개선을 달성 하고 B2B 서비스 중 핵심인 tolerating large workload 를 실제 달성하여 런칭하는데 기여함
- python 방식의 행렬곱셈 모듈(only on cpu)방식 때문에 매우 느린 스크립트 흐름을 우선 python profiler 로 진단하고 행렬곱셈 모듈(only on GPU)방식으로 전환하기 위해 CUDA-C programming 으로 모듈 개발 후 기존 python 스크립트 흐름에 import 시킨 후 매우 큰 peformance 향상에 기여함 , 다룰 수 있는 매트릭스 dimension 이 기존 방식 ( 대략 3000 x 3000 ) 에서 개선 후 ( 대략 70000 x 70000 ~ 100000 x 100000 ) 가량 향상 시킴 , CUDA 의 cublas , cublasXt 를 활용했고 매트릭스를 여러 GPU 에 분산시키는 라이브러리를 이해하고 활용하였음

[frontend]
## react
- react 기반의 frontend 설계 및 구축, 공통 component 개발 , layout 설계 및 구축, D3, threejs를 활용한 visualization 화면 개발 및 구축
- react class component -> react hook 패턴 변경 프로젝트 리딩 및 개발
- threejs 로 개발한 팀개발자의 코드 분석 후 개선 점을 브라우저 profiler 로 heap 의 OOM 을 우선 진단하고 협업 하여 성능 개선에 기여함
- jest 로 테스트코드 작성 후 CI/CD pipe 내 job 등록

[ci/cd]
- gitlab 서버 구축 , gitlab runner 동작 기반의 CI/CD pipeline 설계 및 구축
- 팀내 개발자들과 협업 시 개발자별 merge request 를 merge 전 개발자별로 디버깅할 수 있는 CI/CD 구조 구축
- jest 연동한 test script 동작할 수 있는 CI/CD pipeline 내 job 구축
- 빌드 되는 이미지별 취약점 scan stage 를 도입하고 실제 취약점 발견된 base 이미지는 교체 또는 os base 이미지로부터 재빌드 하도록 함
- Nexus 로 backend 의 근간이 되는 npm , pip 쪽 패키지의 의존성 꼬임과 안정성 도모함
- GitLab Issue 기능만으로 작업을 추적하여 단순 이슈 목록 관리에 머물러 있었음. 이를 YouTrack으로 이관하고 GitLab CI/CD 파이프라인과 연계하여, Agile/Scrum 기반의 체계적인 이슈 관리와 파이프라인 결과에 따른 State 자동 전환이 가능하도록 개선함
- CI/CD 파이프라인 내 Claude token 최적화