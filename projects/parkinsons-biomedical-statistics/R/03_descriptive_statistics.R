library(tidyverse)
library(here)

path <- here("projects", "parkinsons-biomedical-statistics", "data", "processed", "parkinsons_clean.csv")
data <- readr::read_csv(path, show_col_types = FALSE)

participant_summary <- data |>
  group_by(subject_id) |>
  summarise(
    n_recordings = n(),
    age = first(age),
    sex = first(sex),
    follow_up_days = max(test_time, na.rm = TRUE) - min(test_time, na.rm = TRUE),
    mean_motor_updrs = mean(motor_updrs, na.rm = TRUE),
    sd_motor_updrs = sd(motor_updrs, na.rm = TRUE),
    mean_total_updrs = mean(total_updrs, na.rm = TRUE),
    sd_total_updrs = sd(total_updrs, na.rm = TRUE),
    .groups = "drop"
  )

outcomes <- data |>
  summarise(
    motor_mean = mean(motor_updrs),
    motor_median = median(motor_updrs),
    motor_sd = sd(motor_updrs),
    motor_iqr = IQR(motor_updrs),
    total_mean = mean(total_updrs),
    total_median = median(total_updrs),
    total_sd = sd(total_updrs),
    total_iqr = IQR(total_updrs)
  )

print(participant_summary)
print(outcomes)

# TODO: compare participant-level and recording-level summaries.
# TODO: discuss why repeated recordings can overweight participants with more observations.
