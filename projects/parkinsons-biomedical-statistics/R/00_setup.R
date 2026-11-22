# Parkinson's Telemonitoring — environment setup
# Run this once in RStudio from the project root.

if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv")
}

# First run only:
# renv::init()

packages <- c(
  "tidyverse",
  "here",
  "janitor",
  "skimr",
  "broom",
  "lme4",
  "lmerTest",
  "performance",
  "parameters",
  "patchwork",
  "quarto"
)

# After renv::init(), install missing packages inside the project environment:
# renv::install(packages)
# renv::snapshot()

message("Do not commit a hand-written renv.lock. Generate it with renv::snapshot().")
