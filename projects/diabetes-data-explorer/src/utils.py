from pathlib import Path

import pandas as pd


REQUIRED_COLUMNS = [
    "gender",
    "age",
    "hypertension",
    "heart_disease",
    "smoking_history",
    "bmi",
    "HbA1c_level",
    "blood_glucose_level",
    "diabetes",
]


def load_data(path: str | Path) -> pd.DataFrame:
    """Load the CSV and validate the expected coursework schema."""
    path = Path(path)
    if not path.exists():
        raise FileNotFoundError(
            f"Dataset not found at {path}. "
            "Place the CSV there or pass another path with --data."
        )

    data = pd.read_csv(path)
    missing = [column for column in REQUIRED_COLUMNS if column not in data.columns]
    if missing:
        raise ValueError(f"Missing required columns: {', '.join(missing)}")
    return data


def clean_data(data: pd.DataFrame) -> pd.DataFrame:
    """Return a cleaned copy without duplicate or incomplete rows."""
    cleaned = data.copy()
    cleaned = cleaned.drop_duplicates().dropna().reset_index(drop=True)

    # The coursework gender comparison uses the Female and Male categories.
    cleaned = cleaned[cleaned["gender"].isin(["Female", "Male"])].reset_index(drop=True)
    return cleaned


def save_table(table: pd.DataFrame, path: str | Path) -> None:
    """Save a dataframe as a reproducible CSV output."""
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    table.to_csv(path)
