# Analysis methods

## Acquisition

Three dynamic conditions were analysed: **walking, running and sprinting**.

Each condition contained **1,000 frames sampled at 100 Hz**, corresponding to **10 seconds** of motion-capture data. Reflective markers were tracked by a **Qualisys** infrared-camera system and force platforms were used to complement the kinematic data with ground-contact information.

The lower-limb analysis used three anatomical landmarks on both sides:

- **GT** — greater trochanter;
- **ELF** — lateral femoral epicondyle;
- **ML** — lateral malleolus.

For each marker, X, Y and Z coordinates were exported in `.tsv` format and processed in Excel.

## Knee angle from 3D vectors

The thigh vector was defined as:

`thigh = GT - ELF`

The shank vector was defined as:

`shank = ML - ELF`

The angle between the two segments was calculated from the dot product:

`theta = arccos((thigh · shank) / (|thigh| |shank|))`

and converted from radians to degrees.

The analysis then summarised mean, standard deviation, minimum, maximum, range and coefficient of variation for each condition and side.

## Marker displacement

Three-dimensional displacement between two positions:

`Δs = sqrt((Xf-Xi)^2 + (Yf-Yi)^2 + (Zf-Zi)^2)`

The trajectories were also compared component-by-component to study how movement amplitude changed between proximal and distal landmarks and across locomotion speeds.

## Velocity and acceleration

Frame-to-frame velocity:

`v_i = (s_(i+1) - s_i) / (t_(i+1) - t_i)`

Frame-to-frame acceleration:

`a_i = (v_(i+1) - v_i) / (t_(i+1) - t_i)`

The ML marker was especially useful for studying the larger distal-segment movement associated with running and sprinting.

## Variability

For each analysed metric, mean and standard deviation were calculated. Relative variability was compared using:

`CV = (s / x̄) × 100`

## Right-left symmetry

Right-left differences were quantified with:

`SI = |R-L| / ((R+L)/2) × 100`

Lower values indicate greater right-left similarity for the analysed metric.

## Ground contact

Support intervals were estimated from **vertical ground-reaction force** using a **50 N threshold**. Partial intervals at the beginning and end of a recording were excluded from the mean so that incomplete cycles did not distort the timing results.

This produced support and no-contact timing for the left and right sides in walking, running and sprint.

## Step and stride parameters

Mean step and stride times were derived from the analysed cycles. Spatial parameters were estimated from the lateral-malleolus trajectories because the exported dataset did not contain markers placed directly on the foot.

`stride length ≈ 2 × step length`

The spatial values are therefore used as movement estimates, while the recorded force-platform and kinematic measures provide the stronger direct evidence in the project.
