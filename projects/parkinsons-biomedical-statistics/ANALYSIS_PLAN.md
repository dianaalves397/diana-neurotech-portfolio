# Statistical Analysis Plan

## Study objective

Evaluate how selected biomedical voice measurements and time are associated with Parkinson's disease severity in a longitudinal telemonitoring dataset while accounting for repeated measurements within participants.

## Primary outcome

`motor_UPDRS`

## Secondary outcome

`total_UPDRS`

## Experimental unit / clustering

The participant is the independent biological unit. Individual voice recordings are repeated observations nested within participant.

## Core research questions

### RQ1 — Time
How is motor UPDRS associated with time since recruitment?

### RQ2 — Voice measurements
Which selected voice measurements show meaningful association with motor UPDRS?

### RQ3 — Repeated measurements
Do selected associations remain after participant-level clustering is modelled using a mixed-effects model?

## Descriptive analysis

Report:
- number of participants;
- recordings per participant;
- age distribution;
- sex distribution using the dataset coding;
- follow-up duration;
- motor and total UPDRS distributions;
- participant-level means and within-participant variability;
- selected voice-feature distributions.

## Inferential principles

- Default two-sided alpha: 0.05.
- Report effect estimates and 95% confidence intervals alongside p-values.
- Check assumptions before selecting/ interpreting parametric procedures.
- Use non-parametric alternatives where justified.
- Do not treat all recordings as independent participants.
- Distinguish exploratory from pre-specified analyses.
- Avoid selecting variables solely because they achieve statistical significance.

## Baseline analyses

Participant-level summaries may be used to demonstrate standard confidence intervals, hypothesis tests and correlation methods taught in introductory statistics.

A conventional linear regression will be used as a transparent baseline and explicitly labelled as a model that does not fully account for repeated-measure dependence.

## Primary longitudinal model

Initial model:

```text
motor_UPDRS ~ test_time + (1 | subject_id)
```

Candidate extension:

```text
motor_UPDRS ~ test_time + selected_voice_feature + (1 | subject_id)
```

A voice feature must be selected using a documented combination of biomedical relevance, exploratory evidence and collinearity considerations.

Random slopes will be considered only if participant trajectories and diagnostics support the additional complexity.

## Model diagnostics

Assess:
- residual distribution/patterns;
- heteroscedasticity;
- collinearity;
- influential observations;
- ICC;
- marginal/conditional R² for mixed models where applicable;
- convergence warnings.

## Missing data

The UCI record reports no missing values in the source dataset. This will be verified programmatically. If missingness is introduced by transformations or discovered in the local copy, it must be documented before analysis.

## Multiple comparisons

The project will prioritise a small number of justified questions rather than mass-testing all voice variables. If many exploratory tests are added later, multiplicity will be addressed and clearly labelled.

## Reporting

The final report will separate:
1. descriptive findings;
2. introductory/baseline inferential analyses;
3. longitudinal mixed-effects inference;
4. diagnostics;
5. biomedical interpretation and limitations.
