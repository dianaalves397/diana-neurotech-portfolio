"""Decoder training and evaluation helpers."""

from __future__ import annotations

from dataclasses import dataclass

import numpy as np
import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
from sklearn.model_selection import StratifiedKFold, cross_val_score, train_test_split
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler


@dataclass(frozen=True)
class DecoderResult:
    accuracy: float
    cv_mean: float
    cv_std: float
    confusion_matrix: np.ndarray
    classification_report: dict
    classes: list[int]


def _build_pipeline() -> Pipeline:
    return Pipeline(
        [
            ("scale", StandardScaler()),
            (
                "decoder",
                LogisticRegression(
                    max_iter=2_000,
                    solver="lbfgs",
                ),
            ),
        ]
    )


def evaluate_decoder(
    X: pd.DataFrame,
    y: pd.Series,
    random_state: int = 42,
) -> DecoderResult:
    """Train and evaluate a linear movement-direction decoder."""
    X_train, X_test, y_train, y_test = train_test_split(
        X,
        y,
        test_size=0.25,
        random_state=random_state,
        stratify=y,
    )

    model = _build_pipeline()
    model.fit(X_train, y_train)
    pred = model.predict(X_test)

    classes = sorted(int(v) for v in np.unique(y))
    cm = confusion_matrix(y_test, pred, labels=classes)
    report = classification_report(
        y_test,
        pred,
        labels=classes,
        output_dict=True,
        zero_division=0,
    )

    cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=random_state)
    scores = cross_val_score(_build_pipeline(), X, y, cv=cv, scoring="accuracy")

    return DecoderResult(
        accuracy=float(accuracy_score(y_test, pred)),
        cv_mean=float(scores.mean()),
        cv_std=float(scores.std()),
        confusion_matrix=cm,
        classification_report=report,
        classes=classes,
    )
