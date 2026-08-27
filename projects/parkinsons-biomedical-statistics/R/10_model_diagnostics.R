library(tidyverse)
library(here)
library(lme4)
library(performance)

path <- here("projects", "parkinsons-biomedical-statistics", "data", "processed", "parkinsons_clean.csv")
data <- readr::read_csv(path, show_col_types = FALSE) |>
  mutate(subject_id = factor(subject_id))

model <- lmer(motor_updrs ~ test_time + ppe + (1 | subject_id), data = data, REML = TRUE)

print(performance::check_model(model))
print(performance::check_collinearity(model))
print(performance::check_heteroscedasticity(model))
print(performance::r2(model))
print(performance::icc(model))

# TODO: save the most informative diagnostics to results/figures/.
# TODO: document any influential observations or model changes rather than silently removing data.
