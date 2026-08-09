# 対訳 — Stretch 03 — PCA・クラスタリング・置換重要度（penguins）
# 標準化後にPCA(2)・KMeans(3)・Ridgeの置換重要度を求めてください。
library(readr)
library(dplyr)

path <- "../../../data/penguins.csv"
cols <- c("Culmen_Length", "Culmen_Depth", "Flipper_Length", "Body_Mass")
X <- read_csv(path, show_col_types = FALSE) |>
  select(all_of(cols)) |>
  tidyr::drop_na()

# 標準化（Python: StandardScaler）
Xs <- scale(as.matrix(X))

# PCA(n_components=2, random_state=123) — 寄与率
set.seed(123)
pc <- prcomp(Xs, center = FALSE, scale. = FALSE)
evr <- (pc$sdev^2 / sum(pc$sdev^2))[1:2]
cat("explained_variance_ratio_:", round(evr, 3), "\n")

# KMeans(n_clusters=3, random_state=123, n_init=10)
set.seed(123)
km <- kmeans(Xs, centers = 3, nstart = 10)
cat("cluster sizes:\n")
print(table(km$cluster))

# Ridge（閉形式, alpha=1）+ 置換重要度（スコアはR2、n_repeats=10）
# 特徴: Body_Mass以外 → y: Body_Mass、test_size=0.25, seed=123
feat <- c("Culmen_Length", "Culmen_Depth", "Flipper_Length")
y <- X$Body_Mass
Xp <- as.matrix(X[, feat])

set.seed(123)
n <- nrow(Xp)
test_idx <- sample.int(n, size = floor(0.25 * n))
X_train <- Xp[-test_idx, , drop = FALSE]
X_test <- Xp[test_idx, , drop = FALSE]
y_train <- y[-test_idx]
y_test <- y[test_idx]

ridge_fit <- function(Xm, ym, alpha = 1) {
  Xb <- cbind(1, Xm)
  pen <- diag(ncol(Xb))
  pen[1, 1] <- 0
  solve(crossprod(Xb) + alpha * pen, crossprod(Xb, ym))
}
ridge_predict <- function(beta, Xm) as.numeric(cbind(1, Xm) %*% beta)
r2_score <- function(ym, pred) {
  1 - sum((ym - pred)^2) / sum((ym - mean(ym))^2)
}

beta <- ridge_fit(X_train, y_train, alpha = 1)
base_r2 <- r2_score(y_test, ridge_predict(beta, X_test))

set.seed(123)
n_repeats <- 10
imp_mean <- setNames(numeric(length(feat)), feat)
for (j in feat) {
  drops <- numeric(n_repeats)
  for (r in seq_len(n_repeats)) {
    Xp_perm <- X_test
    Xp_perm[, j] <- sample(Xp_perm[, j])
    drops[r] <- base_r2 - r2_score(y_test, ridge_predict(beta, Xp_perm))
  }
  imp_mean[[j]] <- mean(drops)
}

ord <- order(imp_mean, decreasing = TRUE)
cat("permutation importance:\n")
for (i in ord) {
  cat(sprintf("%s=%.3f\n", names(imp_mean)[i], imp_mean[[i]]))
}

cat("\nMLOpsメモ: 学習コード・データ版・評価指標をセットで残す（再現性）\n")
