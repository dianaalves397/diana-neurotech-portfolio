# HRV Sleep Analyzer — Short Scientific Report

## 1. Aim

This project developed and validated a single-subject workflow for characterizing autonomic dynamics during sleep from ECG-derived heart-rate variability.

The central technical question was not only whether QRS complexes could be detected accurately, but also **how local detection errors propagate into downstream HRV estimates**.

## 2. Data

The analysis used the `slp01a` record from the MIT-BIH Polysomnographic Database.

Key properties used in the project:

- ECG sampling frequency: **250 Hz**
- analysed duration: **120 min**
- ECG used for automatic QRS detection
- PhysioNet beat annotations used as the validation reference
- sleep-stage annotations used for stage alignment

The signal record also contains other polysomnographic channels, but this project intentionally focuses on ECG-derived HRV and sleep-stage context.

## 3. Signal-processing workflow

The workflow consisted of:

1. reading the raw ECG;
2. detecting QRS complexes with WFDB XQRS;
3. validating detections against the PhysioNet beat annotations;
4. deriving RR intervals;
5. applying transparent RR plausibility filtering;
6. computing HRV in 5-minute windows;
7. retaining windows with sufficient sleep-stage purity;
8. calculating time- and frequency-domain metrics;
9. identifying detection-error regions;
10. assigning PASS/FLAG quality-control status;
11. creating a QC-aware temporal subject profile.

## 4. QRS detector validation

Using a ±100 ms matching tolerance:

- reference annotations: **7,806**
- XQRS detections: **7,809**
- TP: **7,803**
- FP: **6**
- FN: **3**
- sensitivity: **99.96%**
- PPV: **99.92%**
- F1: **99.94%**

The error count was low globally, but the analysis showed that global detector performance alone is not sufficient for HRV quality assurance.

## 5. Local error analysis

The main error regions included:

- an initial boundary miss near the beginning of the record;
- an isolated high-amplitude transient around 67.23 min;
- a closely spaced FP/FN pair around 80.18 min;
- a cluster of errors around 117 min in a visibly degraded signal region.

The ~117 min region did not belong to any of the retained 18 HRV windows and therefore did not contribute directly to the final HRV comparison.

## 6. Downstream impact on HRV

The 65–70 min N2 window contained only one formal FP, but compared with the reference-annotation pipeline it showed:

- SDNN absolute difference: **14.82 ms**
- RMSSD absolute difference: **24.75 ms**
- LF absolute difference: **206.35 ms²**
- HF absolute difference: **457.90 ms²**
- LF/HF absolute difference: **6.61**

This was the strongest example of error propagation in the project.

By contrast, the 80–85 min window contained 1 FP + 1 FN but produced a substantially smaller RMSSD difference (**3.39 ms**). Therefore, the number of detector errors alone did not determine downstream distortion; their position in the RR sequence also mattered.

## 7. Quality-controlled subject profile

After quality control:

- total retained HRV windows: **18**
- PASS: **16**
- FLAG: **2**
- PASS N2 windows: **14**
- PASS N3 windows: **2**

### N2 medians

- mean HR: **64.32 bpm**
- SDNN: **44.99 ms**
- RMSSD: **22.70 ms**
- pNN50: **3.30%**
- LF: **740.64 ms²**
- HF: **146.02 ms²**
- LF/HF: **5.24**

### N3 medians

- mean HR: **63.93 bpm**
- SDNN: **44.03 ms**
- RMSSD: **21.93 ms**
- pNN50: **2.53%**
- LF: **1121.28 ms²**
- HF: **93.03 ms²**
- LF/HF: **12.83**

Because only two clean N3 windows were available, these values are descriptive and not evidence of a general N2-vs-N3 effect.

## 8. Temporal characterization

Among PASS windows, the 90–95 min N2 window had the highest:

- RMSSD: **37.82 ms**
- pNN50: **7.34%**
- HF: **465.05 ms²**

Within this recording, that window represents the clearest period of increased short-term HRV among the retained clean windows.

The lowest and highest clean-window mean HR values were **61.07 bpm** at 40–45 min and **68.07 bpm** at 105–110 min.

## 9. Interpretation

The key finding of the project is methodological: **a high-performing QRS detector can still produce local HRV distortions that matter scientifically**.

For that reason, the final single-subject profile uses a QC-aware approach rather than interpreting every numerically valid HRV window equally.

The project does not diagnose autonomic dysfunction, and the results should not be generalized beyond this subject/record.

## 10. Limitations

- single-subject observational case study;
- only 18 retained HRV windows;
- only 2 clean N3 windows;
- no population inference;
- sleep-stage annotations are inherited from the source record;
- frequency-domain HRV is sensitive to RR preprocessing and local errors;
- LF and LF/HF are not treated as direct physiological readouts of sympathetic activity.

## 11. Conclusion

This case study demonstrates an end-to-end biomedical signal-processing workflow that links **raw ECG, automated QRS detection, validation, RR quality control, HRV, sleep-stage context and error-aware interpretation**.

The project is designed as a portfolio example of reproducible, cautious biomedical data analysis rather than as a clinical tool.
