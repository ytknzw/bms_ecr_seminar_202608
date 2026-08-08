# Exercise 4対訳: groupby
# r/ に入って実行: Rscript 02_groupby.R
library(dplyr)
library(readr)

df <- read_csv("../../../data/penguins.csv", show_col_types = FALSE)

df |>
  group_by(Island, Species_short) |>
  summarise(body_mass_mean = mean(Body_Mass, na.rm = TRUE), .groups = "drop") |>
  print()

df |>
  group_by(Species_short) |>
  summarise(
    n = n(),
    body_mass_mean = mean(Body_Mass, na.rm = TRUE),
    flipper_mean = median(Flipper_Length, na.rm = TRUE),
    .groups = "drop"
  ) |>
  arrange(desc(body_mass_mean)) |>
  print()
