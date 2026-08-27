library(tidyverse)
library(here)

path <- here("projects", "parkinsons-biomedical-statistics", "data", "processed", "parkinsons_clean.csv")
data <- readr::read_csv(path, show_col_types = FALSE)

# Before adding a test, write the scientific question and hypotheses here.
# Example structure:
# RQ: ...
# H0: ...
# H1: ...
# alpha: 0.05
# Unit of analysis: participant / recording / repeated measure?
# Assumptions: ...
# Effect estimate: ...

# Participant-level example dataset for teaching standard tests without
# pretending that all 5,875 recordings are independent observations.
participant_level <- data |>
  group_by(subject_id) |>
  summarise(
    age = first(age),
    sex = first(sex),
    mean_motor_updrs = mean(motor_updrs),
    mean_total_updrs = mean(total_updrs),
    .groups = "drop"
  )

# TODO: define one justified comparison, inspect distributions/assumptions,
# and choose a parametric or non-parametric test accordingly.
