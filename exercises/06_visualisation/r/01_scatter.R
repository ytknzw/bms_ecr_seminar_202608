# Exercise 6対訳: 散布図（ggplot）
library(ggplot2)
library(readr)

path <- "../../../data/penguins.csv"
df <- read_csv(path, show_col_types = FALSE)

out_dir <- "out"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

p <- ggplot(df, aes(Culmen_Length, Flipper_Length, color = Species_short, shape = Species_short)) +
  geom_point(alpha = 0.7) +
  scale_color_brewer(palette = "Dark2") +
  theme_minimal() +
  labs(title = "くちばしの長さとひれの長さ")
ggsave(file.path(out_dir, "scatter.png"), p, width = 7, height = 5)
message("wrote ", file.path(out_dir, "scatter.png"))

p_facet <- ggplot(df, aes(Culmen_Length, Flipper_Length)) +
  geom_point(alpha = 0.7) +
  facet_wrap(~Species_short) +
  theme_minimal() +
  labs(title = "くちばしの長さとひれの長さ（種ごと）")
ggsave(file.path(out_dir, "facet_scatter.png"), p_facet, width = 9, height = 4)
message("wrote ", file.path(out_dir, "facet_scatter.png"))
