library(tidyverse)
library(here)

path <- here("projects", "parkinsons-biomedical-statistics", "data", "processed", "parkinsons_clean.csv")
data <- readr::read_csv(path, show_col_types = FALSE)

# Start with a small, justified set of variables rather than an automatic
# correlation dump across every column.
selected <- data |>
  select(motor_updrs, total_updrs, test_time, hnr, rpde, dfa, ppe)

pearson <- cor(selected, use = "pairwise.complete.obs", method = "pearson")
spearman <- cor(selected, use = "pairwise.complete.obs", method = "spearman")

print(pearson)
print(spearman)

# TODO: inspect scatterplots before interpreting coefficients.
# TODO: discuss repeated measurements and why naive correlation across all rows
# does not fully separate within-participant from between-participant association.
