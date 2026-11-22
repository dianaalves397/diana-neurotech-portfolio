library(tidyverse)
library(here)
library(broom)

path <- here("projects", "parkinsons-biomedical-statistics", "data", "processed", "parkinsons_clean.csv")
data <- readr::read_csv(path, show_col_types = FALSE)

# Transparent baseline model. This is intentionally simple and does NOT solve
# the repeated-measure dependence problem.
baseline_model <- lm(motor_updrs ~ test_time + ppe, data = data)

print(summary(baseline_model))
print(broom::tidy(baseline_model, conf.int = TRUE))
print(broom::glance(baseline_model))

# TODO: inspect residuals and compare this baseline with the mixed-effects model.
# TODO: explain why standard errors/p-values from an ordinary model can be
# misleading when repeated recordings from the same participant are treated as independent.
