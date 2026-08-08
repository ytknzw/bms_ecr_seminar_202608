# Exercise 6対訳: 箱ひげ図（種ごとの体重）
library(ggplot2)
library(readr)

path <- "../../../data/penguins.csv"
df <- read_csv(path, show_col_types = FALSE)
out_dir <- "out"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

p <- ggplot(df, aes(Species_short, Body_Mass, fill = Species_short)) +
  geom_boxplot(outlier.alpha = 0.5) +
  scale_fill_brewer(palette = "Dark2") +
  theme_minimal() +
  labs(title = "種ごとの体重", x = "Species_short", y = "Body_Mass")
ggsave(file.path(out_dir, "box.png"), p, width = 7, height = 5)
message("wrote ", file.path(out_dir, "box.png"))
