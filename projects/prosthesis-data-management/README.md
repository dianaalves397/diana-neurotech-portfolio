# Prosthesis Data Management System

**Team coursework project · Databases & Information Analysis · 2025/26**

A relational information system designed for **prosthesis management in a healthcare, clinic or rehabilitation setting**. The project connects patients, clinicians, technicians, laboratories, prostheses, examinations, consultations, medical problems and medical equipment in one structured data model.

The objective was to centralise information, reduce redundancy, preserve referential integrity and make the data useful for both operational queries and analytical dashboards.

## System architecture

```text
Source data
   ↓
Python / pandas cleaning
   ↓
Relational modelling
   ↓
MySQL database
   ↓
SQL queries / structured records
   ↓
Power BI analysis
```

## Relational model

The database includes the main entities:

`Patient` · `Physician` · `Technician` · `Laboratory` · `Prosthesis` · `Examination` · `Consultation` · `Medical Problem` · `Medical Equipment`

It also uses associative tables to represent many-to-many relationships such as technicians working on prostheses, technicians responsible for equipment and patients linked to multiple medical problems.

[**→ Open the full data model and ER relationships**](data-model.md)  
[**→ Inspect the SQL schema**](schema.sql)

### Example relationships

- one physician → many consultations
- one patient → many consultations and examinations
- one laboratory → many prostheses and examinations
- many technicians ↔ many prostheses via `protese_tecnico`
- many technicians ↔ many devices via `tecnico_equipamento`
- many patients ↔ many medical problems via `paciente_problema`

The model was developed around primary keys, foreign keys, cardinalities, integrity constraints and normalization concepts used in relational database design.

## Data preparation and ETL

The project used a hybrid dataset strategy: technical/catalogue information was researched from real-world sources while patient/history records were generated synthetically to avoid exposing real health data.

Before import, the workflow included:

- duplicate removal;
- missing-value checks;
- category standardisation for fields such as materials and locations;
- alignment of CSV column names with the logical database model;
- mapping of dates and numeric values to database-compatible types;
- programmatic loading into MySQL using **Python, pandas and SQLAlchemy**.

[**→ Open the ETL example**](etl_example.py)

## Power BI analysis

The database was then explored through dashboards covering:

- patient distribution by sex;
- prosthesis type and material;
- geographic patient distribution;
- laboratory locations;
- patients per physician;
- consultations over time;
- consultations per physician;
- patient age groups.

Selected reported values include **113 female and 87 male patients**, while the prosthesis-type view included **29 dental crowns, 28 dental implants, 25 total prostheses and 18 partial prostheses**.

[**→ See the documented dashboard outputs and analysis**](powerbi-results.md)

## Repository contents

```text
prosthesis-data-management/
├── README.md
├── data-model.md        # ER structure and relationship map
├── schema.sql           # relational schema
├── etl_example.py       # Python/pandas/SQLAlchemy loading pattern
└── powerbi-results.md   # dashboard views and reported results
```

## Tools & concepts

`MySQL` · `MySQL Workbench` · `SQL` · `Python` · `pandas` · `SQLAlchemy` · `Power BI` · `ER modelling` · `normalization` · `primary/foreign keys` · `referential integrity` · `ETL` · `biomedical information systems`
