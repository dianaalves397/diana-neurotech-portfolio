# Neural Decoding Portfolio

A beginner-friendly computational neuroscience project that demonstrates a complete neural decoding workflow using **synthetic neural population activity**.

The goal is to predict movement direction from simulated neural firing-rate features. This repository is designed as a transparent learning project: it does **not** claim experimental neural data or laboratory results.

## Why this project

Neural decoding asks whether patterns of neural population activity contain enough information to infer behaviour, intention, or movement. This project builds a small, reproducible baseline around that idea using Python and scikit-learn.

## What it does

1. Generates a synthetic population of direction-tuned neurons.
2. Simulates trial-by-trial spike-count-like features for four movement directions.
3. Splits the dataset into train/test sets.
4. Standardizes the features.
5. Trains a multinomial logistic-regression decoder.
6. Reports accuracy, cross-validation scores, a classification report, and a confusion matrix.
7. Saves reproducible outputs to `results/`.

## Repository structure

```text
.
├── src/neural_decoding/
│   ├── __init__.py
│   ├── data.py
│   └── model.py
├── tests/
│   └── test_pipeline.py
├── notebooks/
│   └── README.md
├── results/
├── run_experiment.py
├── requirements.txt
├── pyproject.toml
└── README.md
```

## Quick start

```bash
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\\Scripts\\activate
pip install -r requirements.txt
python run_experiment.py
pytest
```

## Scientific framing

Each simulated neuron has a preferred movement direction. Its expected activity is modulated by the angular difference between the neuron's preferred direction and the movement direction of a trial. The simulation also includes shared trial-to-trial gain variability before spike-count-like observations are sampled from a Poisson distribution, so the classes are informative but not perfectly separable.

This is deliberately simplified. Real neural decoding projects require careful treatment of recording modality, preprocessing, trial alignment, population structure, leakage, temporal dependence, behavioural covariates, and model validation.

## Next milestones

- Replace the synthetic dataset with a public motor-control dataset.
- Add dimensionality reduction (PCA / demixed PCA where appropriate).
- Compare linear decoding with nonlinear baselines.
- Add temporal decoding and latent-state models.
- Reproduce a baseline from the Neural Latents Benchmark or another public neural-population dataset.

## Skills demonstrated

Python · NumPy · pandas · scikit-learn · matplotlib · statistics · reproducible experiments · neural population modelling · classification

## Author

Diana Alves — Biomedical Technology student building skills in computational neuroscience, neural decoding, and neurotechnology.
