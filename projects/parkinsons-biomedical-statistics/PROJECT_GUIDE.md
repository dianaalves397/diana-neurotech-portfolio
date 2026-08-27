# Project execution guide

Work through this project in order. Do not jump to the mixed-effects model before understanding the simpler analyses.

## Phase 0 — Reproducible R environment

Open `R/00_setup.R`.

Goals:
- create/open the R project locally;
- install `renv` if needed;
- run `renv::init()` once;
- install the required packages;
- create the real `renv.lock` from your environment.

Do **not** hand-write `renv.lock`.

Done when: another person can clone the project and restore the same package environment.

## Phase 1 — Data provenance and validation

Read `data/README.md`, download the official UCI file into `data/raw/`, then open `R/01_import_validate.R`.

Check:
- number of rows and columns;
- participant count;
- variable names and types;
- missing values;
- duplicated rows;
- impossible values;
- number of recordings per participant;
- range of `test_time`;
- ranges of `motor_UPDRS` and `total_UPDRS`.

Do not clean silently. Every transformation belongs in code.

## Phase 2 — Cleaning

Open `R/02_cleaning.R`.

Create a processed dataset without altering the raw file. Rename awkward columns only if the mapping is documented. Preserve participant ID and repeated-measure structure.

Done when: `data/processed/` can be recreated from raw data using code only.

## Phase 3 — Descriptive statistics

Open `R/03_descriptive_statistics.R`.

Answer first:
- who is in the dataset?
- how many observations does each participant contribute?
- what are the central tendency and dispersion of the clinical outcomes?
- how much variation is between participants vs within a participant over time?

Calculate appropriate quantities such as mean, median, SD, IQR, range and CV. Do not report every possible statistic just because R can calculate it.

## Phase 4 — Visualisation and distributions

Open `R/04_visualisation.R`.

Produce figures that answer questions, for example:
- UPDRS distribution;
- participant trajectories over `test_time`;
- selected voice feature vs UPDRS;
- within-participant trajectories;
- correlation overview for selected variables.

Keep only 2–4 strongest figures for the public README.

## Phase 5 — Confidence intervals

Open `R/05_confidence_intervals.R`.

For each CI, state:
1. parameter being estimated;
2. estimator;
3. assumptions;
4. 95% CI;
5. interpretation in words.

Avoid calculating an apparently precise CI from all 5,875 rows if the method assumes independent observations and participant clustering is ignored.

## Phase 6 — Hypothesis tests

Open `R/06_hypothesis_tests.R`.

For every test write before running it:
- research question;
- H0;
- H1;
- α;
- test selected;
- assumptions;
- effect estimate;
- p-value;
- conclusion.

Use parametric or non-parametric methods because they fit the question/data, not because one gives a smaller p-value.

## Phase 7 — Correlation

Open `R/07_correlation.R`.

Compare Pearson and Spearman where useful. Inspect scatterplots first. Discuss direction, magnitude, uncertainty and the difference between association and causation.

## Phase 8 — Baseline regression

Open `R/08_regression.R`.

Build a transparent conventional regression as a baseline. This is useful pedagogically, but explicitly identify the independence problem created by repeated measurements.

Record coefficients, confidence intervals, R² and residual diagnostics.

## Phase 9 — Longitudinal mixed-effects model

Open `R/09_mixed_effects.R`.

Start simple:

```text
motor_UPDRS ~ test_time + (1 | subject)
```

Then add one justified voice feature at a time. Compare models rather than creating a large model automatically.

Understand:
- fixed effects;
- random intercept;
- within-subject dependence;
- between-subject variability;
- why this model differs from ordinary linear regression.

Only add random slopes if the data and diagnostics justify them.

## Phase 10 — Diagnostics

Open `R/10_model_diagnostics.R`.

Check residual behaviour, influential observations, heteroscedasticity, collinearity and model fit. Treat diagnostics as part of the analysis, not decoration after the result.

## Phase 11 — Scientific report

Open `report/report.qmd`.

Write it like a short biomedical paper:
- Abstract
- Introduction
- Research questions
- Dataset
- Statistical methods
- Results
- Model diagnostics
- Discussion
- Limitations
- Conclusion
- References

The report should be rendered from code; tables and figures should not be manually copied.

## Phase 12 — Portfolio pass

Update `README.md` only after the analysis exists.

The first screen should eventually show:
- one-sentence question;
- dataset size and repeated-measure design;
- statistical approach;
- 2–4 best figures;
- one concise results table;
- main conclusion;
- link to report and code.

## Commit sequence

Suggested commits:

```text
data: document Parkinson telemonitoring source
analysis: validate raw Parkinson data
analysis: clean and prepare repeated-measure dataset
stats: add descriptive analysis
viz: add Parkinson longitudinal figures
stats: add confidence interval analysis
stats: add hypothesis tests and correlation
model: add baseline regression
model: add longitudinal mixed-effects analysis
model: add diagnostics
report: render biomedical statistics report
docs: publish final project results
```
