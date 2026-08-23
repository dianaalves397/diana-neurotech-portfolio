# Data

Store only data that you are allowed to publish.

Suggested structure once the software phase starts:

```text
data/
├── raw/
├── processed/
├── synthetic/
└── fixtures/
```

## Rules

- Never edit the original file in `raw/`; create processed outputs separately.
- Keep a `SOURCE.md` beside any external dataset with source, licence, date accessed and variables used.
- Prefer public, synthetic or fully de-identified datasets for the portfolio.
- Record units and sampling frequency.
- Small deterministic test fixtures belong in `fixtures/` and should be designed to test specific requirements or edge cases.

## First project decision

TODO: Choose the version-1 input source and document its columns/units before implementing the importer.
