library(tidyverse)
library(here)
library(janitor)
library(skimr)

raw_path <- here("projects", "parkinsons-biomedical-statistics", "data", "raw", "parkinsons_updrs.data")

stopifnot(file.exists(raw_path))

raw <- readr::read_csv(raw_path, show_col_types = FALSE)

cat("Rows:", nrow(raw), "\n")
cat("Columns:", ncol(raw), "\n")
cat("Participants:", dplyr::n_distinct(raw$`subject#`), "\n")
cat("Duplicated rows:", sum(duplicated(raw)), "\n")
cat("Missing cells:", sum(is.na(raw)), "\n")

print(names(raw))
print(skimr::skim(raw))

recordings_per_subject <- raw |>
  count(`subject#`, name = "n_recordings") |>
  arrange(n_recordings)

print(recordings_per_subject)

range_checks <- raw |>
  summarise(
    test_time_min = min(test_time, na.rm = TRUE),
    test_time_max = max(test_time, na.rm = TRUE),
    motor_updrs_min = min(motor_UPDRS, na.rm = TRUE),
    motor_updrs_max = max(motor_UPDRS, na.rm = TRUE),
    total_updrs_min = min(total_UPDRS, na.rm = TRUE),
    total_updrs_max = max(total_UPDRS, na.rm = TRUE)
  )

print(range_checks)

# TODO: document any unexpected values before proceeding to cleaning.
