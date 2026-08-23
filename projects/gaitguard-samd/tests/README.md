# Automated Tests

Add automated software tests here when implementation starts.

Suggested later structure:

```text
tests/
├── test_io.py
├── test_preprocessing.py
├── test_metrics.py
├── test_quality.py
└── fixtures/
```

For each test:

1. identify the requirement/test-case ID;
2. define the input;
3. define the expected result;
4. define the acceptance criterion;
5. run automatically where possible;
6. record the result in the traceability matrix.

Prioritise boundary values, invalid/missing input, unit handling and risk-control tests - not only happy-path examples.
