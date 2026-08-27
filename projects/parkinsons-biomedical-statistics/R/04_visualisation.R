library(tidyverse)
library(here)

path <- here("projects", "parkinsons-biomedical-statistics", "data", "processed", "parkinsons_clean.csv")
fig_dir <- here("projects", "parkinsons-biomedical-statistics", "results", "figures")
dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)

data <- readr::read_csv(path, show_col_types = FALSE)

p_distribution <- ggplot(data, aes(motor_updrs)) +
  geom_histogram(bins = 30) +
  labs(
    title = "Distribution of motor UPDRS recordings",
    x = "Motor UPDRS",
    y = "Recordings"
  )

ggsave(file.path(fig_dir, "motor_updrs_distribution.png"), p_distribution, width = 8, height = 5, dpi = 180)

p_trajectories <- ggplot(data, aes(test_time, motor_updrs, group = factor(subject_id))) +
  geom_line(alpha = 0.35) +
  labs(
    title = "Participant-level motor UPDRS trajectories",
    x = "Days since recruitment",
    y = "Motor UPDRS"
  )

ggsave(file.path(fig_dir, "motor_updrs_trajectories.png"), p_trajectories, width = 9, height = 6, dpi = 180)

# TODO: choose one voice measure based on a stated biomedical/statistical reason,
# then create a scatterplot that makes the repeated-participant structure visible.
