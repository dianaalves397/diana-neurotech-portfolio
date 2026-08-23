# GaitGuard - Gait & Fall-Risk Monitoring SaMD Project

**Academic portfolio project · Medical software · QA/RA · Verification & Validation**

GaitGuard is a structured medical-software portfolio project built around one question: how would a gait-monitoring software product be defined, developed, risk-managed, verified and documented in a regulated medical-device workflow?

The project will take movement data as input, calculate gait-related metrics and present a clear result to the user. The emphasis is not only the code: it is the complete product-development trail from intended purpose to requirements, risks, implementation, verification and post-market planning.

## Project map

```text
gaitguard-samd/
├── product/
│   ├── intended-use.md
│   ├── user-needs.md
│   └── system-requirements.md
├── regulatory/
│   ├── classification-assessment.md
│   └── regulatory-strategy.md
├── risk-management/
│   ├── risk-management-plan.md
│   ├── fmea.csv
│   └── risk-control-matrix.csv
├── software/
│   ├── software-requirements.md
│   └── architecture.md
├── src/
│   └── README.md
├── tests/
│   └── README.md
├── verification-validation/
│   ├── verification-plan.md
│   ├── test-cases.csv
│   └── traceability-matrix.csv
├── quality/
│   ├── document-control.md
│   ├── change-control.md
│   └── capa-example.md
├── post-market/
│   ├── pms-plan.md
│   └── pmcf-plan.md
├── data/
│   └── README.md
├── figures/
│   └── README.md
└── PROJECT_PLAN.md
```

## Core workflow

```text
Clinical/user problem
      ↓
Intended purpose
      ↓
User needs
      ↓
System requirements
      ↓
Software requirements
      ↓
Risk analysis + controls
      ↓
Architecture + implementation
      ↓
Verification tests
      ↓
Traceability
      ↓
Validation / usability evidence
      ↓
Post-market planning
```

## Standards and topics to study while completing the project

- EU MDR 2017/745 and software classification concepts
- ISO 13485 quality-management concepts
- ISO 14971 medical-device risk management
- IEC 62304 medical-device software lifecycle
- usability / human factors fundamentals
- verification, validation and design traceability

## Status

**Scaffold created.** Complete the files in the order given in `PROJECT_PLAN.md`.
