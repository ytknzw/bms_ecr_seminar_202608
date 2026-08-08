# Exercise 6対訳: ヒストグラム（体重・種で重ね描き）
library(ggplot2)
library(readr)

path <- "../../../data/penguins.csv"
df <- read_csv(path, show_col_types = FALSE)
out_dir <- "out"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

p <- ggplot(df, aes(Body_Mass, fill = Species_short)) +
  geom_histogram(alpha = 0.7, position = "identity", bins = 20) +
  scale_fill_brewer(palette = "Dark2") +
  theme_minimal() +
  labs(title = "体重の分布")
ggsave(file.path(out_dir, "histogram.png"), p, width = 7, height = 5)
message("wrote ", file.path(out_dir, "histogram.png"))

p_facet <- ggplot(df, aes(Body_Mass)) +
  geom_histogram(bins = 20, fill = "gray40", color = "white") +
  facet_wrap(~Species_short) +
  theme_minimal() +
  labs(title = "体重の分布（種ごと）")
ggsave(file.path(out_dir, "facet_histogram.png"), p_facet, width = 9, height = 4)
message("wrote ", file.path(out_dir, "facet_histogram.png"))
