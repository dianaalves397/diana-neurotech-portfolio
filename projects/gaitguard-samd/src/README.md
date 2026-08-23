# Source Code

Put the actual GaitGuard implementation here **after** the product, system and software requirements are sufficiently defined.

Suggested later structure:

```text
src/
└── gaitguard/
    ├── __init__.py
    ├── io.py
    ├── preprocessing.py
    ├── metrics.py
    ├── quality.py
    └── reporting.py
```

## What each module should eventually contain

- `io.py` - import and validate movement-data files.
- `preprocessing.py` - clean/standardise units and prepare signals.
- `metrics.py` - calculate the version-1 gait metrics.
- `quality.py` - plausibility checks and invalid-input handling.
- `reporting.py` - structure results for display/export.

Before adding a function, identify the software requirement it implements.
