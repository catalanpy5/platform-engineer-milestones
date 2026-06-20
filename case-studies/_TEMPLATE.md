<!--
케이스 스터디 공통 템플릿 (STRATEGY.md §4 기준)
- 각 케이스는 반드시 "숫자/핵심결과"로 시작한다.
- TL;DR은 KR/EN 병행, 본문 상세는 한국어.
- 고객사명·시크릿 제거. 일반화한 부분은 "(일반화함)"으로 표기.
- 사실이 아닌 수치는 절대 쓰지 않는다. 미확정 수치는 `TODO:` 로 남긴다.
-->

# <케이스 제목> — <핵심 결과 한 줄>

> **TL;DR (KR)**: <한 줄 요약 + 핵심 지표>
> **TL;DR (EN)**: <one-line summary + key metric>

| | |
|---|---|
| **역할 (Role)** | <예: 설계·구축·운영 단독 담당 / 리딩> |
| **기간·규모 (Scope)** | TODO: <기간, 노드/유저/트래픽 규모> |
| **스택 (Stack)** | <핵심 기술 나열> |
| **핵심 결과 (Impact)** | <정량 지표 우선> |

---

## 1. 문제 / 맥락 (Problem & Context)

<무엇이, 왜 문제였는가. 비즈니스/연구 맥락 포함.>

## 2. 제약조건 (Constraints)

- <예산 / 보안 / 가용성 / 레거시 / 인력 등 의사결정을 좁힌 제약>

## 3. 검토한 대안 + 선택 근거 (Options → Decision)

| 대안 | 장점 | 단점 | 채택 |
|---|---|---|---|
| A | | | |
| B | | | ✅ |

> 상세 의사결정은 [DECISION-XXXX](../decisions/) 참조.

## 4. 아키텍처 (Architecture)

**Before**
```mermaid
flowchart LR
  A --> B
```

**After**
```mermaid
flowchart LR
  A --> B
```

## 5. 구현 핵심 (Implementation Highlights)

<직접 손댄 증거가 되는 대표 설정/IaC/코드 발췌 — sanitized.>

```yaml
# 대표 설정 발췌 (일반화함)
```

## 6. 정량 결과 (Results)

| 지표 | Before | After | 개선 |
|---|---|---|---|
| | | | |

## 7. 회고 / 다음 단계 (Retrospective)

- **잘된 점**:
- **한계 / 트레이드오프**:
- **다음에 한다면**:
