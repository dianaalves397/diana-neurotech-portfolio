# MNE-BIDS issue #534 — glossary documentation contribution

Upstream issue: https://github.com/mne-tools/mne-bids/issues/534

## Problem

MNE-BIDS has an open documentation issue proposing a glossary page. Maintainers explicitly agreed that a glossary would be useful, especially for terminology describing the parts of a BIDS path.

For new users, terms such as `subject`, `session`, `task`, `acquisition`, `run`, `processing`, `recording`, `space`, `split`, `description`, `suffix`, `extension`, `datatype`, and `root` appear together in `BIDSPath`. Their relationship to filename entities and directory structure is not immediately obvious.

## Proposed contribution

This prepared patch:

1. adds `doc/glossary.rst`;
2. explains the main BIDS/MNE-BIDS path terms using the current `mne_bids.BIDSPath` terminology;
3. includes a concrete path example;
4. adds the glossary to the hidden documentation toctree in `doc/index.rst`.

The definitions were checked against the current `BIDSPath` docstring in `mne_bids/path.py` rather than invented independently.

## Files

- [`glossary.rst`](glossary.rst) — proposed new documentation page
- [`mne-bids-issue-534.patch`](mne-bids-issue-534.patch) — patch representing the upstream change

## Validation still required upstream

Before submitting the PR, the patch should be applied to a fork of `mne-tools/mne-bids`, followed by the project's documentation checks / Sphinx build. The current ChatGPT GitHub integration connected to this account can modify repositories owned by this account, but it does not expose the GitHub `fork` operation for external repositories; therefore the upstream fork/PR remains the only blocked step.

## Status

**Prepared for upstream PR — fork required.**
