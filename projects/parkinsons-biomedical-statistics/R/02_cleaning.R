library(tidyverse)
library(here)
library(janitor)

raw_path <- here("projects", "parkinsons-biomedical-statistics", "data", "raw", "parkinsons_updrs.data")
out_path <- here("projects", "parkinsons-biomedical-statistics", "data", "processed", "parkinsons_clean.csv")

dir.create(dirname(out_path), recursive = TRUE, showWarnings = FALSE)

raw <- readr::read_csv(raw_path, show_col_types = FALSE)

clean <- raw |>
  janitor::clean_names() |>
  rename(subject_id = subject) |>
  arrange(subject_id, test_time)

# Keep cleaning minimal and explicit. Add transformations only after they are justified.
# TODO: if any values are recoded, document the original coding and the reason here.

readr::write_csv(clean, out_path)

cat("Wrote:", out_path, "\n")
cat("Rows:", nrow(clean), " Participants:", n_distinct(clean$subject_id), "\n")
