# Exercise 6対訳: 折れ線（年平均体重）
library(ggplot2)
library(dplyr)
library(readr)

path <- "../../../data/penguins.csv"
df <- read_csv(path, show_col_types = FALSE)
out_dir <- "out"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

by_year <- df |>
  filter(!is.na(Date_Egg), !is.na(Body_Mass)) |>
  mutate(year = as.integer(format(as.Date(Date_Egg), "%Y"))) |>
  group_by(Species_short, year) |>
  summarise(mean_body_mass = mean(Body_Mass), .groups = "drop") |>
  arrange(year)

p <- ggplot(by_year, aes(year, mean_body_mass, color = Species_short, linetype = Species_short, shape = Species_short)) +
  geom_line() +
  geom_point() +
  scale_color_brewer(palette = "Dark2") +
  scale_y_continuous(limits = c(0, NA)) +
  theme_minimal() +
  labs(title = "年ごとの平均体重", y = "Body_Mass")
ggsave(file.path(out_dir, "line.png"), p, width = 7, height = 5)
message("wrote ", file.path(out_dir, "line.png"))
