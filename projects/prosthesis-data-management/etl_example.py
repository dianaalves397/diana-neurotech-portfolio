"""CSV-to-MySQL loading pattern used in the prosthesis database coursework.

Connection details are read from the MYSQL_URL environment variable instead of
being committed to source control.
"""

import os
from pathlib import Path

import pandas as pd
from sqlalchemy import create_engine


def load_csv_to_table(csv_path: str | Path, table: str) -> None:
    mysql_url = os.environ.get("MYSQL_URL")
    if not mysql_url:
        raise RuntimeError(
            "Set MYSQL_URL, e.g. mysql+pymysql://user:password@localhost/proteses"
        )

    data = pd.read_csv(csv_path)
    data = data.drop_duplicates().copy()

    engine = create_engine(mysql_url)
    data.to_sql(table, con=engine, if_exists="append", index=False)


if __name__ == "__main__":
    load_csv_to_table("data/pacientes_proteses.csv", "paciente")
