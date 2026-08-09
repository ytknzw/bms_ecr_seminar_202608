# 対訳 — Stretch 04 — LightGBM（penguins）
# LightGBMで回帰（R2）と分類（accuracy + CV）を行ってください。
# 特徴例: Culmen_Length / Culmen_Depth / Flipper_Length / Island → Body_Mass / Species_short
library(readr)
library(dplyr)
library(lightgbm)

path <- "../../../data/penguins.csv"
df <- read_csv(path, show_col_types = FALSE) |>
  tidyr::drop_na(
    Body_Mass, Culmen_Length, Culmen_Depth, Flipper_Length, Island, Species_short
  ) |>
  mutate(
    Island = as.factor(Island),
    Species_short = as.character(Species_short)
  )

# Python OneHotEncoder(Island) に合わせ、数値3列 + Islandダミー
make_X <- function(data) {
  model.matrix(~ Culmen_Length + Culmen_Depth + Flipper_Length + Island - 1, data = data)
}

# --- 回帰: Body_Mass ---
set.seed(123)
n <- nrow(df)
reg_test_idx <- sample.int(n, size = floor(0.25 * n))
train_reg <- df[-reg_test_idx, ]
test_reg <- df[reg_test_idx, ]

X_train_reg <- make_X(train_reg)
X_test_reg <- make_X(test_reg)
# 学習時の列にテストを揃える
missing_cols <- setdiff(colnames(X_train_reg), colnames(X_test_reg))
for (mc in missing_cols) X_test_reg <- cbind(X_test_reg, setNames(0, mc))
X_test_reg <- X_test_reg[, colnames(X_train_reg), drop = FALSE]

dtrain_reg <- lgb.Dataset(data = X_train_reg, label = train_reg$Body_Mass)
bst_reg <- lgb.train(
  params = list(
    objective = "regression",
    metric = "l2",
    learning_rate = 0.1,
    seed = 123
  ),
  data = dtrain_reg,
  nrounds = 50,
  verbose = -1
)
pred_reg <- predict(bst_reg, X_test_reg)
rsq <- 1 - sum((test_reg$Body_Mass - pred_reg)^2) /
  sum((test_reg$Body_Mass - mean(test_reg$Body_Mass))^2)
cat(sprintf("r2_score: %.6f\n", rsq))

# --- 分類: Species_short（stratify 相当）---
set.seed(123)
cls_test_idx <- unlist(lapply(split(seq_len(n), df$Species_short), function(idx) {
  sample(idx, size = floor(0.25 * length(idx)))
}))
train_cls <- df[-cls_test_idx, ]
test_cls <- df[cls_test_idx, ]

y_levels <- sort(unique(df$Species_short))
y_train_cls <- match(train_cls$Species_short, y_levels) - 1L
y_test_cls <- match(test_cls$Species_short, y_levels) - 1L

X_train_cls <- make_X(train_cls)
X_test_cls <- make_X(test_cls)
missing_cols <- setdiff(colnames(X_train_cls), colnames(X_test_cls))
for (mc in missing_cols) X_test_cls <- cbind(X_test_cls, setNames(0, mc))
X_test_cls <- X_test_cls[, colnames(X_train_cls), drop = FALSE]

dtrain_cls <- lgb.Dataset(data = X_train_cls, label = y_train_cls)
bst_cls <- lgb.train(
  params = list(
    objective = "multiclass",
    metric = "multi_error",
    num_class = length(y_levels),
    learning_rate = 0.1,
    seed = 123
  ),
  data = dtrain_cls,
  nrounds = 50,
  verbose = -1
)
# lightgbm R: multiclass predict はクラス優先（列方向）なので byrow=FALSE
pred_prob <- predict(bst_cls, X_test_cls)
pred_mat <- matrix(pred_prob, ncol = length(y_levels), byrow = FALSE)
pred_cls <- max.col(pred_mat) - 1L
acc <- mean(pred_cls == y_test_cls)
cat(sprintf("accuracy_score: %.6f\n", acc))

# --- 5-fold CV（accuracy）---
set.seed(123)
folds <- sample(rep(1:5, length.out = n))
cv_scores <- numeric(5)
for (k in 1:5) {
  tr <- df[folds != k, ]
  te <- df[folds == k, ]
  y_tr <- match(tr$Species_short, y_levels) - 1L
  y_te <- match(te$Species_short, y_levels) - 1L
  X_tr <- make_X(tr)
  X_te <- make_X(te)
  miss <- setdiff(colnames(X_tr), colnames(X_te))
  for (mc in miss) X_te <- cbind(X_te, setNames(0, mc))
  X_te <- X_te[, colnames(X_tr), drop = FALSE]

  dtr <- lgb.Dataset(data = X_tr, label = y_tr)
  bst <- lgb.train(
    params = list(
      objective = "multiclass",
      metric = "multi_error",
      num_class = length(y_levels),
      learning_rate = 0.1,
      seed = 123
    ),
    data = dtr,
    nrounds = 50,
    verbose = -1
  )
  pr <- predict(bst, X_te)
  pm <- matrix(pr, ncol = length(y_levels), byrow = FALSE)
  cv_scores[k] <- mean((max.col(pm) - 1L) == y_te)
}
cat(sprintf("cv.mean=%.6f, cv.std=%.6f\n", mean(cv_scores), sd(cv_scores)))
