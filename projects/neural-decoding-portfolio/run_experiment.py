"""Run the synthetic neural decoding experiment and save reproducible outputs."""

from __future__ import annotations

import json
from pathlib import Path

import matplotlib.pyplot as plt
import pandas as pd

from src.neural_decoding import evaluate_decoder, make_synthetic_population


def main() -> None:
    output_dir = Path("results")
    output_dir.mkdir(exist_ok=True)

    X, y = make_synthetic_population(n_trials=800, n_neurons=40, random_state=42)
    result = evaluate_decoder(X, y, random_state=42)

    metrics = {
        "dataset": "synthetic direction-tuned neural population",
        "n_trials": int(len(X)),
        "n_neurons": int(X.shape[1]),
        "test_accuracy": result.accuracy,
        "cv_accuracy_mean": result.cv_mean,
        "cv_accuracy_std": result.cv_std,
        "classes_degrees": result.classes,
    }

    (output_dir / "metrics.json").write_text(
        json.dumps(metrics, indent=2), encoding="utf-8"
    )

    pd.DataFrame(result.confusion_matrix, index=result.classes, columns=result.classes).to_csv(
        output_dir / "confusion_matrix.csv"
    )

    fig, ax = plt.subplots(figsize=(6, 5))
    image = ax.imshow(result.confusion_matrix)
    ax.set_xticks(range(len(result.classes)), result.classes)
    ax.set_yticks(range(len(result.classes)), result.classes)
    ax.set_xlabel("Predicted direction (degrees)")
    ax.set_ylabel("True direction (degrees)")
    ax.set_title("Movement-direction decoder confusion matrix")
    for i in range(len(result.classes)):
        for j in range(len(result.classes)):
            ax.text(j, i, str(result.confusion_matrix[i, j]), ha="center", va="center")
    fig.colorbar(image, ax=ax)
    fig.tight_layout()
    fig.savefig(output_dir / "confusion_matrix.png", dpi=160)
    plt.close(fig)

    print(json.dumps(metrics, indent=2))


if __name__ == "__main__":
    main()
