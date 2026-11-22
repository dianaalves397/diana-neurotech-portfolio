library(tidyverse)
library(here)
library(lme4)
library(lmerTest)
library(parameters)

path <- here("projects", "parkinsons-biomedical-statistics", "data", "processed", "parkinsons_clean.csv")
data <- readr::read_csv(path, show_col_types = FALSE) |>
  mutate(subject_id = factor(subject_id))

# Model 1: time only, participant-specific random intercept.
m1 <- lmer(motor_updrs ~ test_time + (1 | subject_id), data = data, REML = TRUE)

# Model 2: add one selected voice feature.
m2 <- lmer(motor_updrs ~ test_time + ppe + (1 | subject_id), data = data, REML = TRUE)

print(summary(m1))
print(summary(m2))
print(parameters::model_parameters(m2, ci = 0.95))

# TODO: justify the selected voice feature before expanding the model.
# TODO: compare models appropriately and interpret fixed effects in biomedical terms.
# TODO: consider random slopes only after inspecting subject trajectories and model fit.
