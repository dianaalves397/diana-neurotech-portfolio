# PSM — MATLAB Signal Processing Foundations

**Academic coursework · Processamento de Sinais (PSM) · MATLAB**

## Overview

A collection of my original MATLAB laboratory exercises covering introductory **discrete-time signal processing**. The work progresses from functions, vector operations and simple statistics to **autocorrelation, FIR moving-average smoothing, DC/mean removal and zero-crossing detection**, including a two-threshold hysteresis approach. It includes original source scripts and a supplied CSV output.

> **Academic work in progress.** These are learning exercises and some are unfinished or contain errors. Original files are preserved as submitted, not silently rewritten or represented as fully tested software. The input called `ECG` in some scripts is a **synthetic sinusoidal sequence**, not a recorded or medically validated ECG.

## What I implemented and practised

| Topic | MATLAB evidence |
| --- | --- |
| Discrete-time signals | Synthesized `x[n] = 2 sin(2πn/8 + π/2)` with `N=8` and 128 samples |
| Signal characterization | `max`, `min`, peak-to-peak, `mean`, `std`, energy `sum(x.^2)` and mean power |
| Autocorrelation | `xcorr(xn)` and the associated lag vector |
| FIR smoothing | A hand-coded 2-point moving average and a 3-tap average using `filter(ones(1,M)/M,1,xn)` |
| Removing DC offset | `xn - mean(xn)` |
| Zero crossings | Adjacent-sample sign comparisons and a threshold/state-based hysteresis detector |
| Noisy signals | Sinusoid plus white Gaussian noise via `randn` and plotting |
| MATLAB programming | Scripts and local functions, vector preallocation, `for`/`if` constructs and CSV writing |

## Source of the example signal

```matlab
N = 8;
n = 0:(16*N-1);
xn = 2*sin(2*pi*n/N + pi/2);
```

## Supplied result

The uploaded [CSV](matlab/parametros_do_sinal.csv) provides the following descriptors for the above **synthetic** signal, labelled `ECG` by the original script:

| Maximum | Minimum | Peak-to-peak | Mean | Sample std. dev. | Energy | Mean power |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 2.000000 | -2.000000 | 4.000000 | -0.000000 | 1.419770 | 256.000000 | 2.000000 |

This table is a supplied coursework output; it is **not** a clinical ECG analysis.

## Source archive

All 13 uploaded `.m` files and the uploaded CSV are stored in [`matlab/`](matlab), with their original names.

| Files | Work demonstrated |
| --- | --- |
| [`lab2ext.m`](matlab/lab2ext.m) | Expanded exercise: metrics, autocorrelation, moving-average filtering, mean removal, crossing detection and CSV export |
| [`caracteristica (1).m`](matlab/caracteristica%20(1).m), [`caracteristicas_sinal (1).m`](matlab/caracteristicas_sinal%20(1).m) | Signal metrics, lagged autocorrelation and CSV generation |
| [`analise_fun.m`](matlab/analise_fun.m) | Draft utility for descriptors and CSV |
| [`lab 2 (1).m`](matlab/lab%202%20(1).m), [`untitled.m`](matlab/untitled.m) | Two-point moving-average exercises |
| [`conta_z.m`](matlab/conta_z.m), [`conta_z1.m`](matlab/conta_z1.m), [`conta_zeros.m`](matlab/conta_zeros.m) | Sign crossings of sampled and noisy sinusoids; iterative code drafts |
| [`contar_zeros (1).m`](matlab/contar_zeros%20(1).m), [`ElementosNulosFuncao (1).m`](matlab/ElementosNulosFuncao%20(1).m) | Count elements whose value is **exactly zero** (not sign crossings) |
| [`soma (1).m`](matlab/soma%20(1).m), [`calcula (1).m`](matlab/calcula%20(1).m) | Introductory reusable MATLAB functions |
| [`parametros_do_sinal.csv`](matlab/parametros_do_sinal.csv) | Provided numeric output |

The two submitted ZIP archives, `caracteristica.zip` and `caracteristica2.zip`, are byte-for-byte identical. Each contains `caracteristica.m`, matching the separately uploaded `caracteristica (1).m` apart from one whitespace-only difference. The source is represented above rather than adding duplicate archive binaries.

## Code-review notes and limitations

- `analise_fun.m` references `n` and `N` without defining or passing them. It is a draft, not a ready-to-run function.
- `conta_z.m` has `t=1:fs:1`, producing only one time sample for `fs=1000`; the intended sample vector is not created.
- `conta_zeros.m` includes the misspelling `lenght` and accesses `x(i+1)` at the final iteration.
- The two-sample moving-average drafts include `if i==1:`, which requires syntax correction in MATLAB.
- Adjacent-sample sign tests ignore samples exactly equal to zero. Hysteresis detection has different transition semantics from strict sign changes.
- The example scripts have not been subjected to a complete automated test suite; the signal generator is synthetic.
- Executing the scripts that export `parametros_do_sinal.csv` may overwrite an output file of the same name.

## Relevance

These foundations support later work on **biomedical signal preprocessing, ECG/EMG interpretation and signal-feature extraction**. The coursework here establishes programming and digital signal-processing skills; applications to real physiological signals require separate data, validation and quality control.

---

**Resumo (PT):** Exercícios académicos de PSM em MATLAB: sinais discretos, descritores estatísticos, autocorrelação, filtro FIR por média móvel, remoção da média, cruzamentos por zero, histerese e exportação CSV. Os originais são conservados, incluindo rascunhos e erros. O sinal designado `ECG` é sintético.
