from pathlib import Path

from utils import clean_data, load_data, save_table
from preprocessing import build_numeric_dataset
from stats import (
    class_balance,
    correlation_matrix,
    descriptive_summary,
    diabetes_group_summary,
    generate_figures,
)


def run_analysis(data_path: str = "data/diabetes.csv") -> None:
    """Run the complete exploratory diabetes analysis."""
    data = load_data(data_path)
    cleaned = clean_data(data)

    results_dir = Path("results")
    figures_dir = Path("figures")
    results_dir.mkdir(exist_ok=True)
    figures_dir.mkdir(exist_ok=True)

    save_table(descriptive_summary(cleaned), results_dir / "descriptive_summary.csv")
    save_table(diabetes_group_summary(cleaned), results_dir / "diabetes_group_summary.csv")
    save_table(class_balance(cleaned), results_dir / "class_balance.csv")

    numeric = build_numeric_dataset(cleaned)
    save_table(correlation_matrix(numeric), results_dir / "correlation_matrix.csv")

    generate_figures(cleaned, figures_dir)

    print(f"Rows loaded: {len(data):,}")
    print(f"Rows after cleaning: {len(cleaned):,}")
    print(f"Rows removed during cleaning: {len(data) - len(cleaned):,}")
    print("Analysis complete.")
    print(f"Tables: {results_dir.resolve()}")
    print(f"Figures: {figures_dir.resolve()}")


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
        description="Exploratory analysis of the diabetes prediction dataset."
    )
    parser.add_argument(
        "--data",
        default="data/diabetes.csv",
        help="Path to the diabetes CSV file.",
    )
    args = parser.parse_args()
    run_analysis(args.data)
