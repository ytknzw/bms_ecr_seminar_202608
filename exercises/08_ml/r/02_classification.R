# 対訳 — Must 02 — 分類（k近傍法: 形態 → Species_short）
# Culmen_Length / Culmen_Depth / Flipper_Length / Body_MassからSpecies_shortを予測し、
# テストデータのaccuracyと混同行列を表示してください（Python版は classification_report）。
library(readr)
library(dplyr)
library(class)

path <- "../../../data/penguins.csv"
df <- read_csv(path, show_col_types = FALSE) |>
  tidyr::drop_na(
    Culmen_Length, Culmen_Depth, Flipper_Length, Body_Mass, Species_short
  ) |>
  mutate(Species_short = as.character(Species_short))

feats <- c("Culmen_Length", "Culmen_Depth", "Flipper_Length", "Body_Mass")
set.seed(123)
n <- nrow(df)
test_idx <- sample.int(n, size = floor(0.3 * n))
train <- df[-test_idx, ]
test <- df[test_idx, ]

# スケールを揃えてから knn（距離ベースのため）
train_x <- scale(train[, feats])
test_x <- scale(
  test[, feats],
  center = attr(train_x, "scaled:center"),
  scale = attr(train_x, "scaled:scale")
)

pred <- knn(
  train = train_x,
  test = test_x,
  cl = train$Species_short,
  k = 5
)

acc <- mean(pred == test$Species_short)
cat("accuracy:", round(acc, 3), "\n")
print(table(truth = test$Species_short, pred = pred))
