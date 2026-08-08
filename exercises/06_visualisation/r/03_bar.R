# Exercise 6対訳: 棒グラフ（島×種の平均体重）
library(ggplot2)
library(dplyr)
library(readr)

path <- "../../../data/penguins.csv"
df <- read_csv(path, show_col_types = FALSE)
out_dir <- "out"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

by_island <- df |>
  group_by(Species_short, Island) |>
  summarise(mean_body_mass = mean(Body_Mass, na.rm = TRUE), .groups = "drop")

p <- ggplot(by_island, aes(Species_short, mean_body_mass, fill = Island)) +
  geom_col(position = "dodge") +
  scale_fill_brewer(palette = "Dark2") +
  theme_minimal() +
  labs(title = "島×種の平均体重", y = "Body_Mass")
ggsave(file.path(out_dir, "bar.png"), p, width = 7, height = 5)
message("wrote ", file.path(out_dir, "bar.png"))
