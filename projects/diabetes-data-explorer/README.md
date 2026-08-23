# Diabetes Data Explorer

**Programming & biomedical data analysis coursework · Python**

A Python project for exploring demographic and clinical variables associated with diabetes status. The project analyses age, BMI, hypertension, heart disease, smoking history, HbA1c and blood-glucose measurements through reproducible data cleaning, descriptive statistics and visualisation.

The current version is a cleaned and expanded version of the coursework code, preserving the original analysis goals while making the project easier to run, inspect and reproduce.

## Source code

| File | Purpose |
| --- | --- |
| [`src/main.py`](src/main.py) | Runs the complete analysis and writes the outputs |
| [`src/utils.py`](src/utils.py) | Dataset loading, validation and cleaning |
| [`src/preprocessing.py`](src/preprocessing.py) | Numeric preparation for correlation analysis |
| [`src/stats.py`](src/stats.py) | Descriptive statistics, grouped analysis, correlations and figures |
| [`tests/test_analysis.py`](tests/test_analysis.py) | Automated checks for the core analysis functions |

## What the analysis does

- validates the expected biomedical-data columns;
- removes duplicated and incomplete observations;
- summarises age, BMI, HbA1c and blood glucose;
- compares these variables by diabetes status;
- measures class balance;
- calculates a Pearson correlation matrix for numeric features;
- explores gender and smoking-history distributions;
- generates univariate, bivariate and multivariate visualisations;
- saves tables and figures as reproducible outputs.

## Dataset used in the coursework

The supplied coursework CSV contains **18,500 observations and 9 variables**:

`gender` · `age` · `hypertension` · `heart_disease` · `smoking_history` · `bmi` · `HbA1c_level` · `blood_glucose_level` · `diabetes`

After duplicate removal and the gender comparison used in the coursework analysis, the reproducible run contains **18,418 observations**.

Reference dataset with the same schema: [Diabetes Prediction Dataset — Kaggle](https://www.kaggle.com/datasets/iammustafatz/diabetes-prediction-dataset).

## Selected results

| Variable | No diabetes — mean | Diabetes — mean |
| --- | ---: | ---: |
| Age | 40.31 | 60.93 |
| BMI | 26.88 | 32.00 |
| HbA1c | 5.40 | 6.93 |
| Blood glucose | 132.40 | 194.03 |

In this coursework dataset, the strongest Pearson correlations with diabetes status among the numeric variables are **HbA1c (r = 0.600)**, **blood glucose (r = 0.548)** and **age (r = 0.473)**.

## Visual analysis

<p align="center">
  <img src="figures/hba1c_by_diabetes.png" width="47%" alt="HbA1c by diabetes status" />
  <img src="figures/age_bmi_diabetes.png" width="47%" alt="Age and BMI by diabetes status" />
</p>

Additional figures are available in [`figures/`](figures), and the generated tables are in [`results/`](results).

## Run

```bash
python -m pip install -r requirements.txt
python src/main.py --data data/diabetes.csv
```

The analysis writes:

```text
results/
├── class_balance.csv
├── correlation_matrix.csv
├── descriptive_summary.csv
└── diabetes_group_summary.csv

figures/
├── age_distribution.png
├── bmi_distribution.png
├── smoking_history.png
├── bmi_by_diabetes.png
├── hba1c_by_diabetes.png
├── glucose_by_diabetes.png
├── gender_by_diabetes.png
├── age_bmi_diabetes.png
└── gender_bmi_diabetes.png
```

## Tests

```bash
pytest -q
```

Current test suite: **4 tests** covering duplicate removal, summary generation, numeric preprocessing and class-balance calculation.

## Skills demonstrated

`Python` · `pandas` · `NumPy` · `Matplotlib` · `data cleaning` · `descriptive statistics` · `exploratory data analysis` · `correlation analysis` · `biomedical data visualisation` · `reproducible analysis`
