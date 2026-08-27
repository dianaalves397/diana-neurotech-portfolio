# Open-source issue shortlist

Snapshot: 2026-08-27

A practical shortlist of scientific-Python / neuroscience issues considered for contribution. Priority reflects relevance to computational neuroscience and biomedical data, scope, duplication risk, and suitability for an early open-source contribution.

| Priority | Repository / issue | Scope | Assessment |
| --- | --- | --- | --- |
| 1 | `neuromechanist/emg2mu#16` | Fix consecutive motor-unit spikes closer than `min_firing_interval` | **Active target.** Good first issue; maintainer explicitly requested a tested fork + PR. Patch and regression test prepared. |
| 2 | `mne-tools/mne-bids#534` | Add glossary page to MNE-BIDS docs | **Active target.** Small, documentation-only, maintainer-supported scope. Patch prepared. |
| 3 | `mne-tools/mne-python#13707` | Improve structure of Decoding (MVPA) documentation | **Strong next target.** Directly relevant to neural decoding; no matching PR found during triage. Needs maintainer-aligned restructuring rather than a large rewrite. |
| 4 | `mne-tools/mne-python#13406` | Check consistency between permutation-cluster docstring and tutorial | **Good learning target.** Statistics + documentation; requires verifying intended array dimensions before editing. |
| 5 | `mne-tools/mne-bids#1525` | Make `BIDSPath` implement `os.PathLike` | **Small code target.** Potentially compact implementation, but should include tests and discussion of API implications. |
| 6 | `mne-tools/mne-bids#1519` | Warn on case-only entity mismatches | **Medium target.** Useful real-world data-validation problem; likely needs matching tests. |
| 7 | `mne-tools/mne-python#14196` | Expand MVPA docs with temporal decoders / Time-GAL | **Relevant stretch target.** Excellent thematic fit but too large for a first contribution. |
| 8 | `mne-tools/mne-python#13634` | `crop(tmin)` vs `get_data(tmin)` semantics | **Defer.** Interesting numerical/API bug but higher regression risk and larger design discussion. |

## Issues deliberately not targeted

- `mne-tools/mne-python#13689`: an existing PR already addresses it.
- `mne-tools/mne-python#12197`: multiple PRs already address or overlap with it.
- `neurallatents/nlb_tools`: no suitable open beginner issue was found in the current triage, so no contribution is being forced merely to create activity.
- `mne-tools/mne-bids#522`: overlaps strongly with the glossary work in #534 and should not be pursued as a separate duplicate contribution without maintainer guidance.

## Contribution rule

Before starting each new patch:

1. confirm the issue is still open;
2. search existing and recent PRs for duplicate work;
3. read maintainer comments;
4. make the smallest change that resolves the agreed scope;
5. add a test or reproducible validation when the change affects behavior;
6. only then open the upstream PR.
