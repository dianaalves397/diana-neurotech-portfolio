import pandas as pd


def build_numeric_dataset(data: pd.DataFrame) -> pd.DataFrame:
    """Create a numeric dataframe suitable for correlation analysis."""
    numeric = data[
        [
            "age",
            "hypertension",
            "heart_disease",
            "bmi",
            "HbA1c_level",
            "blood_glucose_level",
            "diabetes",
        ]
    ].copy()

    numeric["gender_male"] = data["gender"].map({"Female": 0, "Male": 1})
    return numeric
