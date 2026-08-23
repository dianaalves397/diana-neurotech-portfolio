# GaitGuard Project Plan

Work through the project in this order. Do not jump directly to coding.

## Phase 1 - Define the product

1. `product/intended-use.md`
2. `product/user-needs.md`
3. `product/system-requirements.md`

Deliverable: a clear description of who uses GaitGuard, what input it receives, what output it provides and what problem it addresses.

## Phase 2 - Regulatory reasoning

4. `regulatory/classification-assessment.md`
5. `regulatory/regulatory-strategy.md`

Deliverable: a documented reasoning path for medical-device software status, applicable regulatory concepts and evidence needed.

## Phase 3 - Risk management

6. `risk-management/risk-management-plan.md`
7. `risk-management/fmea.csv`
8. `risk-management/risk-control-matrix.csv`

Deliverable: hazards, hazardous situations, harms, initial risk, controls, residual risk and verification of each control.

## Phase 4 - Software design

9. `software/software-requirements.md`
10. `software/architecture.md`
11. implement code under `src/`

Deliverable: software requirements that can each be tested and an architecture showing data flow and modules.

## Phase 5 - Verification and validation

12. `verification-validation/verification-plan.md`
13. `verification-validation/test-cases.csv`
14. automated tests under `tests/`
15. `verification-validation/traceability-matrix.csv`

Deliverable: every important requirement and risk control mapped to objective evidence.

## Phase 6 - Quality-system examples

16. `quality/document-control.md`
17. `quality/change-control.md`
18. `quality/capa-example.md`

Deliverable: small, realistic examples of controlled documentation, change assessment and corrective/preventive action thinking.

## Phase 7 - Post-market thinking

19. `post-market/pms-plan.md`
20. `post-market/pmcf-plan.md`

Deliverable: define what performance, complaint, safety and user-feedback signals would be monitored after release.

## Final portfolio pass

- Replace TODOs with completed evidence.
- Add diagrams/screenshots to `figures/`.
- Add a results section to the project README.
- Link code, tests, risk file and traceability matrix from the README.
- Keep commits small and phase-specific.
