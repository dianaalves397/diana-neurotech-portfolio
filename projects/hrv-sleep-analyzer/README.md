# HRV Sleep Analyzer

**Single-subject polysomnographic case study · ECG · HRV · sleep staging · quality control**

An in-depth biomedical signal-processing project that characterizes autonomic dynamics during sleep in one subject using ECG-derived heart-rate variability (HRV).

The project uses record `slp01a` from the **MIT-BIH Polysomnographic Database** and follows the signal from raw ECG through QRS detection, RR intervals, HRV metrics, sleep-stage alignment and quality-controlled interpretation.

## Project question

> How does ECG-derived HRV vary over time and across sleep stages in one subject, and how sensitive are those HRV estimates to QRS-detection errors?

This is deliberately a **single-subject case study**. The results describe this recording and are not intended as population-level or diagnostic conclusions.

## Pipeline

```text
Raw ECG (250 Hz)
      ↓
WFDB XQRS detector
      ↓
QRS validation against PhysioNet reference annotations
      ↓
RR intervals + plausibility filtering
      ↓
5-minute HRV windows
      ↓
Sleep-stage purity filter
      ↓
Time-domain + frequency-domain HRV
      ↓
Window-level quality control
      ↓
Single-subject autonomic profile
```

## QRS validation

Validation used a **±100 ms matching tolerance** against the PhysioNet ECG beat annotations.

| Metric | Result |
| --- | ---: |
| Reference beats | 7,806 |
| XQRS detections | 7,809 |
| True positives | 7,803 |
| False positives | 6 |
| False negatives | 3 |
| Sensitivity | **99.96%** |
| Positive predictivity | **99.92%** |
| F1 score | **99.94%** |

The validation was not treated as a single global score only. Error regions were inspected and their downstream effect on HRV was quantified.

## Quality-control result

Eighteen 5-minute HRV windows were retained after stage-purity and RR criteria:

- **16 PASS** windows
- **2 FLAG** windows

Flagged windows:

| Window | Stage | FP | FN | Main consequence |
| --- | --- | ---: | ---: | --- |
| 65–70 min | N2 | 1 | 0 | strong distortion of RMSSD and HF |
| 80–85 min | N2 | 1 | 1 | smaller but measurable HRV distortion |

The 65–70 min window is a useful demonstration that **one QRS error can disproportionately alter HRV metrics**, even when global detector performance is excellent.

## Clean-window subject profile

### N2 — 14 PASS windows

| Metric | Median |
| --- | ---: |
| Mean HR | **64.32 bpm** |
| SDNN | **44.99 ms** |
| RMSSD | **22.70 ms** |
| pNN50 | **3.30%** |
| LF | **740.64 ms²** |
| HF | **146.02 ms²** |
| LF/HF | **5.24** |

### N3 — 2 PASS windows

| Metric | Median |
| --- | ---: |
| Mean HR | **63.93 bpm** |
| SDNN | **44.03 ms** |
| RMSSD | **21.93 ms** |
| pNN50 | **2.53%** |
| LF | **1121.28 ms²** |
| HF | **93.03 ms²** |
| LF/HF | **12.83** |

Only two N3 windows are available, so N2-vs-N3 differences are presented **descriptively only**.

## Notable clean periods

The **90–95 min N2 window** is the clearest high-short-term-variability period among PASS windows:

- RMSSD: **37.82 ms**
- pNN50: **7.34%**
- HF: **465.05 ms²**

Other clean-window extrema:

- lowest mean HR: **61.07 bpm**, 40–45 min, N2
- highest mean HR: **68.07 bpm**, 105–110 min, N2
- highest SDNN: **77.65 ms**, 35–40 min, N2
- highest LF: **1514.40 ms²**, 15–20 min, N3

## Why the QC layer matters

The project explicitly separates:

- **PASS** windows used for the main physiological description;
- **FLAG** windows retained for transparency but not used for the primary interpretation.

That prevents a detector artefact from being mistaken for an autonomic event.

## Files

```text
hrv-sleep-analyzer/
├── README.md
├── REPORT.md
├── DATA.md
├── requirements.txt
├── src/
│   └── subject_profile_final.py
└── results/
    ├── validation_summary.csv
    ├── stage_summary.csv
    └── window_highlights.csv
```

## Data source

MIT-BIH Polysomnographic Database, PhysioNet:

https://physionet.org/content/slpdb/1.0.0/

The raw PhysioNet signals are **not committed** to this repository. The public project contains code, documented methods and derived summary results.

## Methods and interpretation boundaries

- HRV window length: **5 min**
- sleep-stage purity threshold used in the project: **0.8**
- old sleep stages 3 and 4 are grouped into **N3**
- QRS validation tolerance: **±100 ms**
- LF and LF/HF are not interpreted as direct, exclusive measures of sympathetic activity or “sympathovagal balance”
- the project is **research/education**, not diagnosis

## Skills demonstrated

`Python` · `NumPy` · `pandas` · `Matplotlib` · `WFDB` · `ECG processing` · `QRS detection` · `HRV` · `sleep staging` · `signal quality control` · `validation` · `biomedical data interpretation`

## Author

**Diana Alves** — Biomedical Technology student working across biomedical data, biosignals and computational neuroscience.

[Portfolio](https://diana-neurotech-portfolio.vercel.app) · [GitHub](https://github.com/dianaalves397) · [ORCID](https://orcid.org/0009-0008-1557-2729)
