import sys
from pathlib import Path

import pandas as pd

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from preprocessing import build_numeric_dataset
from stats import class_balance, descriptive_summary
from utils import clean_data


def sample_data() -> pd.DataFrame:
    return pd.DataFrame(
        {
            "gender": ["Female", "Male", "Female", "Female"],
            "age": [25.0, 68.0, 25.0, 25.0],
            "hypertension": [0, 1, 0, 0],
            "heart_disease": [0, 0, 0, 0],
            "smoking_history": ["never", "former", "never", "never"],
            "bmi": [22.0, 31.0, 22.0, 22.0],
            "HbA1c_level": [4.8, 6.5, 4.8, 4.8],
            "blood_glucose_level": [100, 200, 100, 100],
            "diabetes": [0, 1, 0, 0],
        }
    )


def test_clean_data_removes_duplicate_rows():
    cleaned = clean_data(sample_data())
    assert len(cleaned) == 2


def test_descriptive_summary_contains_expected_variables():
    summary = descriptive_summary(clean_data(sample_data()))
    assert {"age", "bmi", "HbA1c_level", "blood_glucose_level"} <= set(summary.index)


def test_numeric_preprocessing_encodes_gender():
    numeric = build_numeric_dataset(clean_data(sample_data()))
    assert "gender_male" in numeric.columns
    assert set(numeric["gender_male"]) == {0, 1}


def test_class_balance_counts_both_classes():
    balance = class_balance(clean_data(sample_data()))
    assert balance.loc[0, "count"] == 1
    assert balance.loc[1, "count"] == 1
