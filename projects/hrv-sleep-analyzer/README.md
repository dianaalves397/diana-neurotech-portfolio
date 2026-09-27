# HRV Sleep Analyzer

**Polysomnographic case study · ECG · heart-rate variability · sleep staging · signal quality**

A biomedical signal-processing project that characterizes how heart rhythm variability changes during sleep in the `slp01a` recording from the **MIT-BIH Polysomnographic Database**.

The project follows the signal from raw ECG through QRS detection, RR intervals, HRV calculation, sleep-stage alignment and quality-aware interpretation.

## Why this project

Sleep is not only a brain-state phenomenon. It is also accompanied by changes in cardiovascular and autonomic regulation.

A polysomnographic recording makes it possible to look at several physiological systems at the same time. In this project, the ECG channel is used to study **heart-rate variability (HRV)** while the sleep-stage annotations provide the context needed to ask:

> How does ECG-derived HRV vary over time and across sleep stages in this recording, and how much can QRS-detection errors change the resulting HRV values?

The project was inspired by three ideas:

1. **biosignal processing should start from the raw physiological signal**, not only from already-cleaned tables;
2. **algorithm validation matters**, because a small error in beat detection can propagate into later calculations;
3. **sleep physiology is temporal**, so the result should be viewed together with the hypnogram instead of only as a single average.

## Concepts before the pipeline

### What is ECG?

An electrocardiogram (ECG) records the electrical activity associated with cardiac depolarization and repolarization.

For HRV analysis, the most important recurring landmark is the ventricular depolarization complex, the **QRS complex**. A detector can identify the timing of each QRS event and use those timestamps to estimate the time between consecutive heartbeats.

### What is an RR interval?

An **RR interval** is the time between two consecutive detected beats.

For example:

```text
Beat 1        Beat 2              Beat 3
  |-------------|-------------------|
       820 ms            910 ms
```

The heart does not beat at perfectly constant intervals. Those beat-to-beat changes are the basis of HRV.

### What is HRV?

**Heart-rate variability** describes variation in the time between consecutive heartbeats.

Different metrics summarize different aspects of that variation:

| Metric | What it describes |
| --- | --- |
| Mean HR | average heart rate during the window |
| SDNN | overall spread of NN/RR intervals within the window |
| RMSSD | short-term beat-to-beat variability |
| pNN50 | percentage of successive interval differences greater than 50 ms |
| LF | spectral power in the low-frequency band |
| HF | spectral power in the high-frequency band |
| LF/HF | ratio between LF and HF power |

RMSSD and pNN50 depend strongly on **successive** intervals. This is why a single incorrectly inserted or missed beat can have a visible effect.

### Why analyse HRV in windows?

A single value for an entire 2-hour recording would hide temporal changes.

This project uses **5-minute windows** so that HRV can be followed over time while still using a window long enough for standard short-term HRV analysis.

### Why connect HRV to sleep stages?

The same HRV value has more meaning when we know what the subject was doing physiologically at that moment.

The sleep-stage annotations provide a hypnogram containing:

- W — wake;
- N1;
- N2;
- N3;
- REM.

Old stage-3 and stage-4 labels in the source annotations are grouped into **N3**.

A stage-purity threshold is used so that a 5-minute window is only assigned to a sleep stage when enough of that window belongs to the same stage. This avoids calling a mixed transition period a “pure N2” or “pure N3” window.

## Data source

The project uses record `slp01a` from the **MIT-BIH Polysomnographic Database** hosted on PhysioNet.

Relevant files:

```text
slp01a.hea   recording header
slp01a.dat   waveform data
slp01a.ecg   reference beat annotations
slp01a.st    sleep-stage annotations
```

ECG sampling frequency used here: **250 Hz**.

The raw PhysioNet signals are not committed to this repository. The repository contains code, documentation and derived summary results.

Source:

https://physionet.org/content/slpdb/1.0.0/

## Why detect QRS instead of using the reference beats directly?

The database already contains reference beat annotations, but using them as the input would skip one of the most important biosignal-processing steps.

The main pipeline therefore uses **WFDB XQRS** to detect QRS events automatically from the ECG.

The PhysioNet `.ecg` annotations are used separately as a **reference for validation**.

This creates two roles:

```text
Raw ECG ──► XQRS ──► detected beats ──► HRV pipeline

PhysioNet .ecg annotations ───────────► validation reference
```

That separation allows the project to test whether the automated detector is accurate enough before relying on its RR intervals.

## Pipeline

```text
Raw ECG (250 Hz)
      ↓
WFDB XQRS detector
      ↓
Detected QRS timestamps
      ↓
Validation against PhysioNet beat annotations
      ↓
RR intervals
      ↓
RR plausibility checks
      ↓
5-minute windows
      ↓
Sleep-stage purity check
      ↓
Time-domain + frequency-domain HRV
      ↓
Window-level quality status
      ↓
Timeline with hypnogram + HRV
```

## Why validate QRS detections?

If a detector inserts a beat that is not really present, one RR interval may become artificially short.

If it misses a real beat, an interval may become artificially long.

A timing shift can also change two neighbouring intervals even when the detector still identifies the correct cardiac event.

Because HRV is calculated from RR intervals, these errors can propagate into SDNN, RMSSD, pNN50 and spectral metrics.

### Validation rule

Detected beats were compared with the PhysioNet beat annotations using a **±100 ms matching tolerance**.

This means a detected event is counted as a match when it falls within 100 ms of a reference beat.

### Validation results

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

### What TP, FP and FN mean here

- **TP — true positive:** a detected QRS matches a reference beat;
- **FP — false positive:** the detector added an event without a matching reference beat;
- **FN — false negative:** a reference beat was not matched by the detector.

These numbers are useful because they quantify detector behaviour before HRV is interpreted.

## Why use RR plausibility checks?

Even a generally accurate detector can occasionally generate intervals that are physiologically implausible or inconsistent with neighbouring intervals.

RR quality checks are therefore used before HRV calculation.

The purpose is not to “force” the data to look smooth. The purpose is to prevent obvious detection errors from being treated as genuine beat-to-beat physiology.

## Why create PASS and FLAG windows?

A global detector score can be excellent while a small number of windows still contain errors.

For this reason, the final timeline keeps a simple window-level status:

- **PASS** — no FP/FN identified in that retained HRV window;
- **FLAG** — at least one FP or FN falls inside the window.

FLAG windows remain visible because they are useful for understanding the signal and the algorithm. PASS windows are used for the main subject-profile summary.

## Quality-control result

Eighteen 5-minute HRV windows were retained after the stage-purity and RR criteria:

- **16 PASS**
- **2 FLAG**

Flagged windows:

| Window | Stage | FP | FN | Observed effect |
| --- | --- | ---: | ---: | --- |
| 65–70 min | N2 | 1 | 0 | large change in RMSSD and HF relative to the reference-beat pipeline |
| 80–85 min | N2 | 1 | 1 | smaller but measurable change in HRV |

This comparison is useful because it connects a concrete signal-processing error with the numerical metric that appears later in the analysis.

## Subject profile

### N2 — all 14 retained PASS windows

| Metric | Median |
| --- | ---: |
| Mean HR | **64.32 bpm** |
| SDNN | **44.99 ms** |
| RMSSD | **22.70 ms** |
| pNN50 | **3.30%** |
| LF | **740.64 ms²** |
| HF | **146.02 ms²** |
| LF/HF | **5.24** |

### N3 — all retained N3 HRV windows

All N3 windows that satisfied the chosen **5-minute + stage-purity + RR-quality** criteria are included here. In this analysed 2-hour segment, that produced **2 retained N3 windows**.

The hypnogram can contain additional N3 epochs, but an isolated sleep-stage epoch does not automatically become a valid 5-minute stage-specific HRV window. A window must first satisfy the same criteria used for the rest of the analysis.

| Metric | Median |
| --- | ---: |
| Mean HR | **63.93 bpm** |
| SDNN | **44.03 ms** |
| RMSSD | **21.93 ms** |
| pNN50 | **2.53%** |
| LF | **1121.28 ms²** |
| HF | **93.03 ms²** |
| LF/HF | **12.83** |

## Notable periods in the retained windows

The **90–95 min N2 window** had the highest clean short-term HRV values among the retained PASS windows:

- RMSSD: **37.82 ms**
- pNN50: **7.34%**
- HF: **465.05 ms²**

Other extrema:

- lowest mean HR: **61.07 bpm**, 40–45 min, N2;
- highest mean HR: **68.07 bpm**, 105–110 min, N2;
- highest SDNN: **77.65 ms**, 35–40 min, N2;
- highest LF: **1514.40 ms²**, 15–20 min, N3.

## How to read the final timeline

The final figure combines several layers:

1. **hypnogram** — what sleep stage was annotated at each time;
2. **mean HR** — average heart rate in each retained window;
3. **RMSSD** — short-term beat-to-beat variability;
4. **SDNN** — overall interval variability;
5. **HF** — high-frequency spectral power;
6. **FLAG markers** — windows where beat-detection errors were identified.

Reading the panels together makes it easier to separate a real temporal pattern from a value that may have been affected by signal-processing quality.

## Why LF/HF is treated carefully

LF and HF are frequency-domain HRV components, but their physiological interpretation is not one-to-one.

In particular, LF/HF is not treated in this project as a direct meter of “sympathetic versus parasympathetic balance”.

It is kept because it is a commonly reported HRV feature and can still be useful descriptively when interpreted together with the other metrics and the recording context.

## Project inspiration

The project combines ideas from:

- polysomnography and sleep-stage analysis;
- ECG signal processing;
- QRS detection and algorithm validation;
- short-term HRV analysis;
- autonomic physiology;
- reproducible biomedical data analysis;
- PhysioNet-style open physiological datasets.

The main inspiration was to build a project where the **signal-processing decisions remain visible**, rather than jumping directly from a dataset to a final graph.

## How to explore this repository

A useful order is:

1. **README.md** — understand the project, concepts and reasoning;
2. **REPORT.md** — read the scientific narrative and results;
3. **DATA.md** — see the data source and local file layout;
4. **src/subject_profile_final.py** — inspect the code used for the final QC-aware timeline;
5. **results/validation_summary.csv** — detector-validation summary;
6. **results/stage_summary.csv** — stage-level HRV summary;
7. **results/window_highlights.csv** — notable and flagged windows.

Repository structure:

```text
hrv-sleep-analyzer/
├── README.md
├── REPORT.md
├── DATA.md
├── CONCEPTS.md
├── requirements.txt
├── src/
│   └── subject_profile_final.py
└── results/
    ├── validation_summary.csv
    ├── stage_summary.csv
    └── window_highlights.csv
```

## Methods summary

- HRV window length: **5 min**
- sleep-stage purity threshold: **0.8**
- old sleep stages 3 and 4 grouped as **N3**
- QRS detector: **WFDB XQRS**
- validation tolerance: **±100 ms**
- final timeline includes **PASS** and **FLAG** windows
- LF and LF/HF are interpreted together with the other HRV metrics and recording context

## References and useful background

- PhysioNet — MIT-BIH Polysomnographic Database: https://physionet.org/content/slpdb/1.0.0/
- WFDB Python processing tools: https://wfdb.readthedocs.io/en/latest/processing.html
- Task Force of the European Society of Cardiology and the North American Society of Pacing and Electrophysiology — *Heart rate variability: standards of measurement, physiological interpretation and clinical use*.

## Author

**Diana Alves** — Biomedical Technology

[Portfolio](https://diana-neurotech-portfolio.vercel.app) · [GitHub](https://github.com/dianaalves397) · [ORCID](https://orcid.org/0009-0008-1557-2729)
