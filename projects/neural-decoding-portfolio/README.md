# Neural Decoding Portfolio

A beginner-friendly computational neuroscience project demonstrating a complete neural-decoding workflow using **synthetic neural population activity**.

The goal is to predict movement direction from simulated neural firing-rate features using a transparent, reproducible baseline in Python and scikit-learn.

## Why this project

Neural decoding asks whether patterns of neural population activity contain enough information to infer behaviour, intention or movement. This project explores that idea with a compact synthetic population model and a supervised classifier.

## What it does

1. Generates a synthetic population of direction-tuned neurons.
2. Simulates trial-by-trial spike-count-like features for four movement directions.
3. Splits the dataset into train/test sets.
4. Standardizes the features.
5. Trains a multinomial logistic-regression decoder.
6. Reports accuracy, cross-validation scores, a classification report and a confusion matrix.
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

## Model

Each simulated neuron has a preferred movement direction. Expected activity varies with the angular difference between the neuron's preferred direction and the movement direction of a trial. Shared trial-to-trial gain variability is added before spike-count-like observations are sampled from a Poisson distribution.

### Reproduced results

- Test accuracy: **84.5%**
- 5-fold cross-validation mean: **89.6%**
- Population: **40 synthetic neurons**
- Movement directions: **4 classes**

## Next milestones

- Apply the workflow to a public motor-control dataset.
- Add dimensionality reduction such as PCA / demixed PCA where appropriate.
- Compare linear decoding with nonlinear baselines.
- Add temporal decoding and latent-state models.
- Reproduce a baseline from the Neural Latents Benchmark or another public neural-population dataset.

## Skills demonstrated

Python · NumPy · pandas · scikit-learn · Matplotlib · statistics · reproducible experiments · introductory neural population modelling · classification

## Author

Diana Alves — Biomedical Technology student building toward computational neuroscience, neural decoding and neurotechnology.
