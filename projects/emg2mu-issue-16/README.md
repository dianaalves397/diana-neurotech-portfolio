# Prepared contribution — neuromechanist/emg2mu #16

Status: **prepared and locally regression-tested; not yet submitted upstream**.

Upstream issue: `neuromechanist/emg2mu#16` — unusually high firing rates / consecutive spikes closer than the minimum firing interval.

## Finding

The current close-spike cleanup computes time differences at the true spike samples, but then uses the position inside the `np.diff` result (`t`, `t + 1`) to index `source` and `spike_train`. Those are not the original sample indices. It also computes the differences only once, so a run of three or more close spikes can leave a newly adjacent invalid pair after one removal.

## Proposed fix

- recover real spike sample indices with `np.flatnonzero`;
- compare `source` values at those real indices;
- remove the lower-valued event;
- recompute after each removal until no pair violates the minimum interval;
- add a regression test with three consecutive close spikes.

## Local verification

Run:

```bash
python regression_test.py
python reproduce_fix.py
```

The regression fixture demonstrates that the original logic leaves the wrong spikes, while the proposed logic retains sample `110` from the close run and leaves the valid distant spikes at `500` and `800`.

The `.patch` file contains the proposed upstream code change and regression test.
