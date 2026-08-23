from pathlib import Path

import matplotlib.pyplot as plt
import pandas as pd


NUMERIC_COLUMNS = ["age", "bmi", "HbA1c_level", "blood_glucose_level"]


def descriptive_summary(data: pd.DataFrame) -> pd.DataFrame:
    """Descriptive statistics for the main continuous variables."""
    return data[NUMERIC_COLUMNS].describe().T.round(2)


def diabetes_group_summary(data: pd.DataFrame) -> pd.DataFrame:
    """Min, max, mean, median and standard deviation by diabetes status."""
    summary = (
        data.groupby("diabetes")[NUMERIC_COLUMNS]
        .agg(["min", "max", "mean", "median", "std"])
        .round(2)
    )
    summary.columns = [f"{variable}_{statistic}" for variable, statistic in summary.columns]
    summary["cases"] = data.groupby("diabetes").size()
    return summary


def class_balance(data: pd.DataFrame) -> pd.DataFrame:
    """Count and percentage of observations by diabetes status."""
    counts = data["diabetes"].value_counts().sort_index()
    result = pd.DataFrame(
        {
            "count": counts,
            "percentage": (counts / counts.sum() * 100).round(2),
        }
    )
    result.index.name = "diabetes"
    return result


def correlation_matrix(numeric_data: pd.DataFrame) -> pd.DataFrame:
    """Pearson correlation matrix for numeric features."""
    return numeric_data.corr(numeric_only=True).round(3)


def _save(path: Path) -> None:
    plt.tight_layout()
    plt.savefig(path, dpi=180, bbox_inches="tight")
    plt.close()


def _boxplot_by_diabetes(data: pd.DataFrame, column: str, ylabel: str, path: Path) -> None:
    groups = [
        data.loc[data["diabetes"] == 0, column].dropna(),
        data.loc[data["diabetes"] == 1, column].dropna(),
    ]
    plt.figure(figsize=(7, 5))
    plt.boxplot(groups, tick_labels=["No diabetes", "Diabetes"])
    plt.ylabel(ylabel)
    plt.title(f"{ylabel} by diabetes status")
    _save(path)


def generate_figures(data: pd.DataFrame, output_dir: str | Path) -> None:
    """Generate univariate, bivariate and multivariate EDA figures."""
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    plt.figure(figsize=(8, 5))
    plt.hist(data["age"].dropna(), bins=20, edgecolor="black")
    plt.xlabel("Age")
    plt.ylabel("Frequency")
    plt.title("Age distribution")
    _save(output_dir / "age_distribution.png")

    plt.figure(figsize=(8, 5))
    plt.hist(data["bmi"].dropna(), bins=25, edgecolor="black")
    plt.xlabel("BMI")
    plt.ylabel("Frequency")
    plt.title("BMI distribution")
    _save(output_dir / "bmi_distribution.png")

    smoking_counts = data["smoking_history"].value_counts()
    plt.figure(figsize=(8, 5))
    plt.bar(smoking_counts.index.astype(str), smoking_counts.values)
    plt.xlabel("Smoking history")
    plt.ylabel("Count")
    plt.title("Smoking history")
    plt.xticks(rotation=30, ha="right")
    _save(output_dir / "smoking_history.png")

    _boxplot_by_diabetes(data, "bmi", "BMI", output_dir / "bmi_by_diabetes.png")
    _boxplot_by_diabetes(data, "HbA1c_level", "HbA1c level", output_dir / "hba1c_by_diabetes.png")
    _boxplot_by_diabetes(
        data,
        "blood_glucose_level",
        "Blood glucose level",
        output_dir / "glucose_by_diabetes.png",
    )

    gender_diabetes = pd.crosstab(data["gender"], data["diabetes"])
    plt.figure(figsize=(7, 5))
    x = range(len(gender_diabetes.index))
    width = 0.35
    plt.bar([i - width / 2 for i in x], gender_diabetes.get(0, 0), width, label="No diabetes")
    plt.bar([i + width / 2 for i in x], gender_diabetes.get(1, 0), width, label="Diabetes")
    plt.xticks(list(x), gender_diabetes.index)
    plt.ylabel("Count")
    plt.title("Diabetes status by gender")
    plt.legend()
    _save(output_dir / "gender_by_diabetes.png")

    sample = data.sample(min(len(data), 5000), random_state=42)
    plt.figure(figsize=(8, 6))
    for status, label in [(0, "No diabetes"), (1, "Diabetes")]:
        subset = sample[sample["diabetes"] == status]
        plt.scatter(subset["age"], subset["bmi"], alpha=0.35, s=12, label=label)
    plt.xlabel("Age")
    plt.ylabel("BMI")
    plt.title("Age and BMI by diabetes status")
    plt.legend()
    _save(output_dir / "age_bmi_diabetes.png")

    grouped = data.groupby(["gender", "diabetes"])["bmi"].mean().unstack()
    plt.figure(figsize=(7, 5))
    x = range(len(grouped.index))
    plt.bar([i - width / 2 for i in x], grouped.get(0), width, label="No diabetes")
    plt.bar([i + width / 2 for i in x], grouped.get(1), width, label="Diabetes")
    plt.xticks(list(x), grouped.index)
    plt.ylabel("Mean BMI")
    plt.title("Mean BMI by gender and diabetes status")
    plt.legend()
    _save(output_dir / "gender_bmi_diabetes.png")
