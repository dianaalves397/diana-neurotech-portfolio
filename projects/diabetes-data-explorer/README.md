# Diabetes Data Explorer

**Programming / data-analysis coursework · refactored for reproducibility**

An exploratory biomedical-data project built around a diabetes-prediction dataset containing demographic and clinical variables including age, BMI, hypertension, heart disease, smoking history, HbA1c and blood glucose.

The original coursework implemented an interactive Python menu for loading, cleaning, preprocessing and visualising the dataset. This portfolio version keeps the same analytical scope while simplifying the code into a reproducible script.

## Demonstrated work

- CSV ingestion with pandas
- Duplicate / missing-value inspection
- Categorical preprocessing
- Descriptive summaries
- Univariate, bivariate and multivariate exploratory analysis
- Histograms, boxplots, scatter plots and correlation matrices
- Comparison of BMI, age, HbA1c and glucose across diabetes status

## Tools

`Python` · `pandas` · `NumPy` · `Matplotlib` · `Seaborn`

## Run

Place the dataset at `data/diabetes.csv`, then:

```bash
python -m pip install -r requirements.txt
python src/analysis.py
```

Outputs are written to `results/` and `figures/`.

## Data provenance

The CSV is **not bundled** because the local coursework copy did not contain a clear source/licence file. Add the dataset only after confirming the precise source and reuse terms.

## Portfolio framing

This is an **exploratory data-analysis coursework project**, not a clinical diagnostic system and not evidence of clinical model validation.