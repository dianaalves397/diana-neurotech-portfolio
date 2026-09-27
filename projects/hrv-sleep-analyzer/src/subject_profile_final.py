from pathlib import Path
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import wfdb

RECORD = "slp01a"

BASE = Path("data") / "raw" / RECORD / RECORD
PROFILE_PATH = Path("results") / "subject_profile" / f"{RECORD}_subject_windows_qc.csv"
OUT_DIR = Path("results") / "subject_profile"
OUT_DIR.mkdir(parents=True, exist_ok=True)
OUT_PNG = OUT_DIR / f"{RECORD}_sleep_hrv_timeline_qc.png"

df = pd.read_csv(PROFILE_PATH)

header = wfdb.rdheader(str(BASE))
fs = float(header.fs)
duration_min = float(header.sig_len) / fs / 60.0

ann = wfdb.rdann(str(BASE), "st")
samples = np.asarray(ann.sample, dtype=int)

def normalize_stage(note):
    s = "" if note is None else str(note).strip().upper()
    if not s:
        return None
    first = s.split()[0]
    if first in {"W", "WAKE"}:
        return "W"
    if first in {"R", "REM"}:
        return "REM"
    if first in {"1", "N1"}:
        return "N1"
    if first in {"2", "N2"}:
        return "N2"
    if first in {"3", "4", "N3", "N4"}:
        return "N3"
    return None

notes = [normalize_stage(x) for x in ann.aux_note]
mask = np.asarray([x is not None for x in notes], dtype=bool)
stage_samples = samples[mask]
stage_names = np.asarray(notes, dtype=object)[mask]

stage_to_y = {"W": 0, "REM": 1, "N1": 2, "N2": 3, "N3": 4}
stage_labels = ["W", "REM", "N1", "N2", "N3"]
stage_t_min = stage_samples / fs / 60.0
stage_y = np.asarray([stage_to_y[s] for s in stage_names], dtype=float)
hyp_t = np.r_[stage_t_min, duration_min]
hyp_y = np.r_[stage_y, stage_y[-1]]

df["mid_min"] = (df["start_min"] + df["end_min"]) / 2.0
passed = df[df["qc_status"] == "PASS"].copy()
flagged = df[df["qc_status"] == "FLAG"].copy()

metrics = [
    ("mean_hr_bpm", "HR (bpm)"),
    ("rmssd_ms", "RMSSD (ms)"),
    ("sdnn_ms", "SDNN (ms)"),
    ("hf_ms2", "HF (ms²)"),
]

fig, axes = plt.subplots(
    5, 1, figsize=(15, 13), sharex=True,
    gridspec_kw={"height_ratios": [1.2, 1, 1, 1, 1]}
)

axes[0].step(hyp_t, hyp_y, where="post", linewidth=1.5)
axes[0].set_yticks(range(len(stage_labels)))
axes[0].set_yticklabels(stage_labels)
axes[0].set_ylabel("Sleep stage")
axes[0].set_ylim(-0.25, 4.25)
axes[0].invert_yaxis()
axes[0].grid(alpha=0.25)
axes[0].set_title(
    "HRV Sleep Analyzer — Single-Subject Autonomic Profile (slp01a)\n"
    "QC-aware timeline: PASS windows used for the main physiological description"
)

for ax, (metric, ylabel) in zip(axes[1:], metrics):
    ax.plot(passed["mid_min"], passed[metric], marker="o", linewidth=1.1, label="PASS")
    if not flagged.empty:
        ax.scatter(flagged["mid_min"], flagged[metric], marker="x", s=70, label="FLAG")
        for _, row in flagged.iterrows():
            ax.axvspan(row["start_min"], row["end_min"], alpha=0.10)
    ax.set_ylabel(ylabel)
    ax.grid(alpha=0.25)

if not passed.empty:
    best = passed.loc[passed["rmssd_ms"].idxmax()]
    for ax in axes:
        ax.axvspan(best["start_min"], best["end_min"], alpha=0.06)
    axes[2].annotate(
        f"Highest clean RMSSD\n{best['start_min']:.0f}-{best['end_min']:.0f} min",
        xy=(best["mid_min"], best["rmssd_ms"]),
        xytext=(best["mid_min"] + 5, best["rmssd_ms"]),
        arrowprops={"arrowstyle": "->"},
    )

handles, labels = axes[1].get_legend_handles_labels()
if handles:
    axes[1].legend(loc="best")

axes[-1].set_xlabel("Time from start of recording (min)")
for ax in axes:
    ax.set_xlim(0, duration_min)

plt.tight_layout()
plt.savefig(OUT_PNG, dpi=220, bbox_inches="tight")
plt.close(fig)
