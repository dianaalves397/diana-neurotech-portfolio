# GaitGuard - Step-by-step execution guide

Use this file while working inside the repository. The downloadable PDF contains the expanded 20-page version.

## Rule 1: do not start with code

Build the project in this chain:

```text
intended purpose
→ user needs
→ system requirements
→ regulatory reasoning
→ risks and controls
→ software requirements
→ architecture
→ implementation
→ verification
→ traceability
→ quality examples
→ post-market planning
```

## 1. Define version 1

Open `product/intended-use.md`.

Decide:
- primary user;
- intended population/context;
- input data format;
- 3-5 gait metrics for v1;
- exact output/report;
- what is explicitly out of scope.

Commit: `product: define GaitGuard intended purpose`

## 2. User needs

Open `product/user-needs.md`.

Create 6-10 needs using IDs `UN-001`, `UN-002`, etc. Write needs in user language, not implementation language.

Commit: `product: add GaitGuard user needs`

## 3. System requirements

Open `product/system-requirements.md`.

Create `SYS-001...` requirements. Each must be measurable/testable and trace back to a user need.

Commit: `requirements: define GaitGuard system requirements`

## 4. Regulatory qualification/classification

Open `regulatory/classification-assessment.md`.

Start from the intended purpose. Study the current EU MDR Annex VIII software rules and current MDCG software guidance. Document the reasoning, uncertainties and working conclusion; do not choose a class first and justify it afterwards.

Commit: `regulatory: add EU software classification assessment`

## 5. Regulatory strategy

Open `regulatory/regulatory-strategy.md`.

Map qualification/classification, QMS concepts, risk management, software lifecycle, performance/clinical evidence and post-market evidence to the actual files in this project.

Commit: `regulatory: map GaitGuard technical documentation`

## 6. Risk management

Open in this order:
1. `risk-management/risk-management-plan.md`
2. `risk-management/fmea.csv`
3. `risk-management/risk-control-matrix.csv`

First define severity/probability scales. Then identify hazard → sequence of events → hazardous situation → possible harm. Add controls only after the risk chain is clear. Every important control must eventually map to a requirement and a verification test.

Commit: `risk: add initial GaitGuard hazard analysis`

## 7. Software requirements

Open `software/software-requirements.md`.

Create `SW-001...` requirements for input validation, preprocessing, gait metrics, reporting, errors and risk-control behaviour. Give each an acceptance criterion and test ID.

Commit: `software: define GaitGuard software requirements`

## 8. Architecture and data contract

Open:
- `software/architecture.md`
- `data/README.md`

Define modules, interfaces, units, input schema and errors. Choose the v1 data source before implementing an importer. Keep original raw data unchanged; document source/licence/units/sampling rate.

Commit: `software: define architecture and data contract`

## 9. Implement

Only now create the Python package under `src/`.

Recommended order:
1. input/schema validation;
2. units and missing-data checks;
3. one gait metric end-to-end;
4. plausibility/quality checks;
5. results object/export;
6. additional metrics;
7. simple interface last.

Commit incrementally, e.g. `feat: implement gait metric pipeline`.

## 10. Verification

Open:
- `verification-validation/verification-plan.md`
- `verification-validation/test-cases.csv`
- `tests/`

Write normal, boundary and invalid-input cases. Automate repeatable tests with pytest. Record actual results and evidence.

Commit: `test: add requirement-based GaitGuard tests`

## 11. Traceability

Open `verification-validation/traceability-matrix.csv`.

Build the chain:

`UN → SYS → SW → RC → TC → Result`

No high-priority need, requirement or risk control should remain orphaned.

Commit: `docs: complete GaitGuard design traceability`

## 12. Quality examples

Use:
- `quality/document-control.md` for version/status tracking;
- `quality/change-control.md` when you actually change the product/algorithm/input;
- `quality/capa-example.md` after a recurring or systemic test/problem example exists.

Do not invent a CAPA before there is a problem to investigate.

## 13. Post-market

Open:
- `post-market/pms-plan.md`
- `post-market/pmcf-plan.md`

Define what performance, complaint, error and user-feedback signals would be monitored after release, and what evidence would be collected to confirm ongoing performance assumptions.

## 14. Final portfolio pass

Create figures in `figures/`:
- architecture diagram;
- risk workflow;
- traceability overview;
- example movement input;
- gait metrics/results;
- verification summary;
- final interface screenshot.

Then update `README.md` to show the actual evidence, results and links.

## Final checklist

- intended purpose matches final product;
- requirements are measurable;
- classification reasoning uses current official sources;
- risk controls are traceable;
- architecture matches code;
- data source/units/licence are documented;
- automated tests cover invalid/boundary inputs;
- traceability is complete;
- change-control/CAPA examples are based on real project events;
- PMS/follow-up plans have measurable signals;
- README shows work, not just a skills list;
- CI passes.
