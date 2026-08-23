"""Synthetic neural population generator.

The simulation uses a cosine tuning curve for each neuron and Poisson noise to
produce non-negative spike-count-like features.
"""

from __future__ import annotations

import numpy as np
import pandas as pd


def make_synthetic_population(
    n_trials: int = 800,
    n_neurons: int = 40,
    random_state: int = 42,
) -> tuple[pd.DataFrame, pd.Series]:
    """Generate synthetic direction-tuned neural population activity.

    Parameters
    ----------
    n_trials:
        Number of movement trials.
    n_neurons:
        Number of simulated neurons.
    random_state:
        Seed for reproducibility.

    Returns
    -------
    X:
        DataFrame of shape ``(n_trials, n_neurons)`` with spike-count-like
        features.
    y:
        Movement direction label in degrees: 0, 90, 180, or 270.
    """
    if n_trials < 8:
        raise ValueError("n_trials must be at least 8")
    if n_neurons < 2:
        raise ValueError("n_neurons must be at least 2")

    rng = np.random.default_rng(random_state)
    directions_deg = np.array([0, 90, 180, 270])
    trial_directions = rng.choice(directions_deg, size=n_trials, replace=True)

    preferred_deg = rng.uniform(0.0, 360.0, size=n_neurons)
    baseline = rng.uniform(3.0, 8.0, size=n_neurons)
    modulation = rng.uniform(2.0, 6.0, size=n_neurons)

    angle_diff = np.deg2rad(
        trial_directions[:, None] - preferred_deg[None, :]
    )
    rates = baseline[None, :] + modulation[None, :] * (1.0 + np.cos(angle_diff)) / 2.0

    # Shared trial-to-trial gain variability makes the toy problem less separable
    # and better illustrates why validation matters in neural population decoding.
    trial_gain = np.exp(rng.normal(0.0, 0.25, size=(n_trials, 1)))
    rates = rates * trial_gain + 2.0
    rates = np.clip(rates, 0.1, None)

    counts = rng.poisson(rates).astype(float)
    columns = [f"neuron_{i:02d}" for i in range(n_neurons)]
    X = pd.DataFrame(counts, columns=columns)
    y = pd.Series(trial_directions, name="movement_direction_deg")
    return X, y
