# Software Architecture

## Version 1 data flow

Complete and replace this draft as the design becomes concrete.

```text
Movement-data file
       ↓
Input validation
       ↓
Pre-processing
       ↓
Gait metric engine
       ↓
Quality / plausibility checks
       ↓
Results object
       ↓
User-facing report / interface
```

## Components

| Component | Responsibility | Inputs | Outputs | Related requirements |
| --- | --- | --- | --- | --- |
| Input validator | TODO | TODO | TODO | TODO |
| Pre-processing | TODO | TODO | TODO | TODO |
| Metric engine | TODO | TODO | TODO | TODO |
| Quality checks | TODO | TODO | TODO | TODO |
| Reporting layer | TODO | TODO | TODO | TODO |

## Interfaces

TODO: Define file formats, units, required columns and error behaviour.

## Data model

TODO: Define the internal representation for a trial/session and calculated metrics.

## Architecture decisions

Record important decisions here with date, option considered, decision and rationale.
