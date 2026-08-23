# Biomechanics Gait Analysis

**Team coursework project · Biomechanics · 2026**

A quantitative comparison of **walking, running and sprinting** using motion-capture and force-platform data. The analysis focused on lower-limb kinematics, knee flexion, gait timing, right/left symmetry and movement variability.

## What was analysed

- 3D trajectories from reflective markers at the **greater trochanter (GT)**, **lateral femoral epicondyle (ELF)** and **lateral malleolus (ML)**
- Walking, running and sprint conditions
- Knee angle from 3D segment vectors and the dot product
- Marker displacement, frame-to-frame velocity and acceleration
- Mean, standard deviation and coefficient of variation
- Right/left symmetry index
- Ground-contact timing from vertical ground-reaction force using a 50 N threshold
- Step/stride timing and estimated spatial gait parameters

## Experimental setup

Data were exported from a **Qualisys motion-capture system**. Each dynamic condition contained 1,000 frames sampled at 100 Hz, corresponding to 10 seconds of recording. Force platforms complemented the kinematic data for contact timing.

## Selected findings

| Metric | Walking | Running | Sprint |
| --- | ---: | ---: | ---: |
| Mean knee flexion — left | 17.8° | 36.4° | 43.6° |
| Mean knee flexion — right | 23.6° | 43.0° | 50.3° |
| Knee-flexion symmetry index | 28.4% | 16.7% | 14.3% |
| Mean step time | 0.63 s | 0.34 s | 0.32 s |
| Mean stride time | 1.27 s | 0.69 s | 0.63 s |
| Flight / no-contact fraction | 0.0% | 20.0% | 30.1% |

The distal ML marker showed the largest vertical excursion, increasing markedly from walking to sprint. An isolated walking acceleration value on the right ML was flagged during interpretation as a likely experimental artefact.

## Methods demonstrated

`Biomechanics` · `motion capture` · `Qualisys` · `3D vectors` · `kinematics` · `force platforms` · `gait analysis` · `descriptive statistics` · `symmetry analysis` · `critical interpretation`

## Study scope

The dataset represents a single laboratory trial. Spatial gait measures were estimated from the available exported variables, while timing and kinematic results come directly from the recorded motion-capture and force-platform data.

The public project includes the technical methodology and aggregated results used to demonstrate the analysis workflow.
