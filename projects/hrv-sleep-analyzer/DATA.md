# Data and reproducibility

## Source

MIT-BIH Polysomnographic Database (PhysioNet):

https://physionet.org/content/slpdb/1.0.0/

Primary record used: `slp01a`.

## Expected local data layout

```text
data/
└── raw/
    └── slp01a/
        ├── slp01a.hea
        ├── slp01a.dat
        ├── slp01a.ecg
        └── slp01a.st
```

The raw database files are intentionally not committed here.

## Reproducibility notes

- ECG sampling frequency used in the project: 250 Hz
- QRS detector: WFDB XQRS
- validation reference: `.ecg` annotations
- validation tolerance: ±100 ms
- HRV windows: 5 min
- sleep-stage purity threshold: 0.8
- stages 3 and 4 are grouped as N3
- final physiological description uses PASS windows only

The published summary tables are derived outputs from the local analysis workflow.
