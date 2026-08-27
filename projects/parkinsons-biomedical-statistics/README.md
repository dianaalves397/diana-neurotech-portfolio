# Parkinson's Telemonitoring — Longitudinal Biomedical Statistics in R

A reproducible biomedical statistics project using repeated telemonitoring measurements from people with early-stage Parkinson's disease.

> **Status:** analysis scaffold. Results will be added only after they are produced from the documented R workflow.

## Research question

**How are biomedical voice characteristics associated with Parkinson's disease severity over time, and how do those associations change when repeated measurements from the same participant are modelled correctly?**

## Dataset

The project uses the **Oxford Parkinson's Disease Telemonitoring Dataset** from the UCI Machine Learning Repository.

- 42 participants with early-stage Parkinson's disease
- 5,875 repeated voice recordings
- approximately six months of telemonitoring
- repeated measurements identified by participant (`subject#`)
- clinical outcomes: `motor_UPDRS` and `total_UPDRS`
- 16 biomedical voice measures including jitter, shimmer, NHR/HNR, RPDE, DFA and PPE
- UCI DOI: `10.24432/C5ZS3N`
- licence: CC BY 4.0

Raw data provenance and citation instructions are documented in [`data/README.md`](data/README.md).

## Planned statistical approach

The analysis progresses from core biomedical statistics to longitudinal modelling:

1. data validation and cleaning;
2. participant-level descriptive statistics;
3. distribution assessment and visualisation;
4. confidence intervals;
5. hypothesis tests chosen from the research question and assumptions;
6. Pearson/Spearman correlation;
7. conventional regression as a transparent baseline;
8. linear mixed-effects modelling to account for repeated observations within participants;
9. model diagnostics and sensitivity checks;
10. interpretation in biomedical rather than purely numerical terms.

## Why repeated measurements matter

The 5,875 rows are **not 5,875 independent participants**. Multiple recordings come from the same 42 people. The project therefore separates simple teaching/baseline analyses from the final longitudinal inference, which includes participant-level random effects.

A conceptual model is:

```text
UPDRS_ij = β0 + β1 time_ij + β2 voice_feature_ij + u_i + ε_ij
```

where `u_i` represents participant-specific baseline variation.

## Repository structure

```text
parkinsons-biomedical-statistics/
├── README.md
├── PROJECT_GUIDE.md
├── _quarto.yml
├── .gitignore
├── data/
│   ├── README.md
│   ├── raw/
│   └── processed/
├── R/
│   ├── 00_setup.R
│   ├── 01_import_validate.R
│   ├── 02_cleaning.R
│   ├── 03_descriptive_statistics.R
│   ├── 04_visualisation.R
│   ├── 05_confidence_intervals.R
│   ├── 06_hypothesis_tests.R
│   ├── 07_correlation.R
│   ├── 08_regression.R
│   ├── 09_mixed_effects.R
│   └── 10_model_diagnostics.R
├── results/
│   ├── figures/
│   ├── tables/
│   └── models/
└── report/
    ├── report.qmd
    └── references.bib
```

## Final portfolio output

When complete, this page should show the main scientific question, 2–4 high-value figures, one compact results table, the longitudinal model, the most important findings, model diagnostics, limitations and a link to the rendered Quarto report.

The project is intentionally structured so that the visible portfolio evidence is the **analysis and reasoning**, not a list of statistical techniques.
