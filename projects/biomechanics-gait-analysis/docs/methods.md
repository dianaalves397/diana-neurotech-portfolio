# Analysis methods

## Knee angle

Thigh vector: `thigh = GT - ELF`

Shank vector: `shank = ML - ELF`

The angle between the two segments was calculated from the dot product:

`theta = arccos((thigh · shank) / (|thigh| |shank|))`

and converted from radians to degrees.

## Kinematics

Three-dimensional displacement between two positions:

`Δs = sqrt((Xf-Xi)^2 + (Yf-Yi)^2 + (Zf-Zi)^2)`

Frame-to-frame velocity:

`v_i = (s_(i+1) - s_i) / (t_(i+1) - t_i)`

Frame-to-frame acceleration:

`a_i = (v_(i+1) - v_i) / (t_(i+1) - t_i)`

## Variability

`CV = (s / x̄) × 100`

## Right-left symmetry

`SI = |R-L| / ((R+L)/2) × 100`

Lower values indicate greater right-left similarity for the analysed metric.

## Ground contact

Support intervals were estimated from vertical ground-reaction force using a **50 N threshold**. Partial intervals at the start/end of the acquisition were excluded from the mean.