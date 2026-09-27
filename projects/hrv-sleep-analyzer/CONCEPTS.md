# Concepts and reasoning behind the HRV Sleep Analyzer

This document explains the main ideas behind the project in a more tutorial-like format.

## 1. From an ECG waveform to a number

An ECG is a continuous voltage signal.

HRV is not calculated directly from the voltage amplitude. It is calculated from **timing**.

The key transformation is:

```text
ECG waveform
   ↓ detect QRS events
beat timestamps
   ↓ subtract consecutive timestamps
RR intervals
   ↓ calculate variability
HRV metrics
```

This means that beat timing is the bridge between the raw waveform and HRV.

## 2. Why QRS detection matters so much

Suppose the true beat times are:

```text
0.0 s   0.8 s   1.6 s   2.4 s
```

The RR intervals are:

```text
800 ms, 800 ms, 800 ms
```

Now imagine the detector adds a false beat at 1.2 s:

```text
0.0 s   0.8 s   1.2 s   1.6 s   2.4 s
```

The calculated intervals become:

```text
800 ms, 400 ms, 400 ms, 800 ms
```

The heart did not suddenly change in this example; the detector did.

That is why the project validates the detector before interpreting HRV.

## 3. Why use a reference annotation?

A reference annotation provides a set of beat times prepared independently from the automatic detector.

The automatic detector and the reference are compared so that the project can count:

- correctly matched beats;
- extra detections;
- missed beats.

The reference is therefore used as a **measurement standard for the algorithm**, not as the input that generates the final automated HRV result.

## 4. Why use a tolerance instead of requiring the exact same sample?

Different algorithms can place the fiducial point of the same QRS complex a few milliseconds apart.

Requiring the exact same sample would classify many physiologically equivalent detections as wrong.

The ±100 ms tolerance used here defines the matching rule explicitly.

It is a project choice and part of the validation method.

## 5. Why 5-minute windows?

HRV changes over time.

A very long interval gives one average and can hide short-term changes.

A very short interval can make some metrics unstable.

Five minutes is widely used for short-term HRV analysis and provides a practical balance between temporal resolution and metric stability.

## 6. Why a stage-purity threshold?

Sleep can transition from one stage to another inside the same 5-minute interval.

If a window contains a mixture of stages, assigning it entirely to one stage can be misleading.

The stage-purity threshold asks:

> Is enough of this window occupied by one stage to label the whole window with that stage?

The threshold used in this project is 0.8.

## 7. Why are there only two retained N3 windows?

The sleep-stage annotation is usually much finer than the 5-minute HRV window.

A recording can contain many N3 epochs but still produce only a small number of 5-minute windows that are:

1. long enough;
2. sufficiently pure N3;
3. acceptable after RR-quality checks.

The project includes **all N3 windows that meet those rules**. For the analysed segment, that number is two.

## 8. What do PASS and FLAG mean?

PASS and FLAG are not sleep stages.

They are a simple quality label added after the detector-validation step.

### PASS
No false-positive or false-negative detection was identified inside the retained HRV window.

### FLAG
At least one such detection was identified in the window.

A FLAG window is not deleted from history. It is kept visible so that the user can see why its HRV values deserve extra caution.

## 9. Why look at several HRV metrics?

No single HRV metric contains all the information.

- Mean HR tells us the overall rate.
- SDNN summarizes total interval variability within a window.
- RMSSD emphasizes changes between consecutive intervals.
- pNN50 counts larger consecutive changes.
- LF and HF describe spectral components of the RR series.

Using several metrics makes it easier to see whether an apparent change is consistent across different views of the same RR sequence.

## 10. Why combine HRV with a hypnogram?

A standalone HRV curve tells us **when** something changed.

A hypnogram adds the physiological context of **what sleep stage was annotated at that time**.

The combined timeline therefore answers two questions at once:

```text
When did the HRV metric change?
What sleep stage was occurring around that time?
```

## 11. Why keep signal-quality information in the final figure?

A clean-looking line graph can hide uncertainty.

Showing FLAG windows directly on the final timeline makes the quality-control decision visible to the person reading the project.

That is important in biomedical analysis because the processing chain is part of the result.

## 12. Why this project is useful as a portfolio project

The project combines several layers of biomedical technology:

- physiology;
- ECG;
- digital signal processing;
- algorithm validation;
- time-series analysis;
- sleep staging;
- data visualization;
- scientific interpretation;
- reproducible Python workflows.

It is therefore not only an HRV calculator. It demonstrates how raw physiological data can be transformed into an interpretable biomedical analysis while documenting the decisions made along the way.
