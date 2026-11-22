library(tidyverse)
library(here)

path <- here("projects", "parkinsons-biomedical-statistics", "data", "processed", "parkinsons_clean.csv")
data <- readr::read_csv(path, show_col_types = FALSE)

# Participant-level example: one mean outcome per participant.
participant_means <- data |>
  group_by(subject_id) |>
  summarise(mean_motor_updrs = mean(motor_updrs), .groups = "drop")

n <- nrow(participant_means)
mean_x <- mean(participant_means$mean_motor_updrs)
se_x <- sd(participant_means$mean_motor_updrs) / sqrt(n)
t_crit <- qt(0.975, df = n - 1)

ci <- tibble(
  estimate = mean_x,
  lower_95 = mean_x - t_crit * se_x,
  upper_95 = mean_x + t_crit * se_x,
  n_participants = n
)

print(ci)

# TODO: explain why this participant-level CI is different from treating all recordings as independent.
# TODO: add model-based CIs once the mixed-effects model exists.
