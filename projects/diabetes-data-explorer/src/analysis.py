from pathlib import Path

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data" / "diabetes.csv"
FIGURES = ROOT / "figures"
RESULTS = ROOT / "results"


def load_and_clean(path: Path) -> pd.DataFrame:
    df = pd.read_csv(path)
    df = df.drop_duplicates().dropna().copy()
    if "gender" in df.columns:
        df = df[df["gender"] != "Other"].copy()
    return df


def save_descriptive_summary(df: pd.DataFrame) -> None:
    RESULTS.mkdir(exist_ok=True)
    numeric = ["age", "bmi", "HbA1c_level", "blood_glucose_level"]
    available = [c for c in numeric if c in df.columns]
    df[available].describe().T.to_csv(RESULTS / "descriptive_summary.csv")


def save_figures(df: pd.DataFrame) -> None:
    FIGURES.mkdir(exist_ok=True)

    if "age" in df:
        plt.figure(figsize=(8, 5))
        plt.hist(df["age"], bins=20, edgecolor="black")
        plt.xlabel("Age")
        plt.ylabel("Frequency")
        plt.title("Age distribution")
        plt.tight_layout()
        plt.savefig(FIGURES / "age_distribution.png", dpi=160)
        plt.close()

    if {"diabetes", "bmi"}.issubset(df.columns):
        plt.figure(figsize=(7, 5))
        sns.boxplot(data=df, x="diabetes", y="bmi")
        plt.title("BMI by diabetes status")
        plt.tight_layout()
        plt.savefig(FIGURES / "bmi_by_diabetes.png", dpi=160)
        plt.close()

    if {"age", "bmi", "diabetes"}.issubset(df.columns):
        plt.figure(figsize=(8, 5))
        sns.scatterplot(data=df.sample(min(len(df), 5000), random_state=7), x="age", y="bmi", hue="diabetes", alpha=0.55)
        plt.title("Age vs BMI by diabetes status")
        plt.tight_layout()
        plt.savefig(FIGURES / "age_bmi_scatter.png", dpi=160)
        plt.close()

    numeric_df = df.select_dtypes(include="number")
    if not numeric_df.empty:
        plt.figure(figsize=(9, 7))
        sns.heatmap(numeric_df.corr(), annot=True, fmt=".2f", cmap="coolwarm", center=0)
        plt.title("Numeric correlation matrix")
        plt.tight_layout()
        plt.savefig(FIGURES / "correlation_matrix.png", dpi=160)
        plt.close()


def main() -> None:
    if not DATA.exists():
        raise FileNotFoundError(f"Dataset not found: {DATA}. Add the sourced dataset before running.")
    df = load_and_clean(DATA)
    save_descriptive_summary(df)
    save_figures(df)
    print(f"Analysed {len(df):,} cleaned records.")


if __name__ == "__main__":
    main()
