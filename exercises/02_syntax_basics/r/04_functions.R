# 【正解】04_functions.R — 関数

scores <- c(55, 72, 88, 41, 95)

# 問題1: standardize(x, mean, sd)を定義する。
standardize <- function(x, mean, sd) {
  (x - mean) / sd
}

# 問題2: scoresの平均mと、母分散ベースの標準偏差sdを求める（分散はnで割る）。
m <- mean(scores)
sd <- sqrt(mean((scores - m)^2))
m
sd

# 問題3: 各scoreをstandardizeし、小数第3位に丸めたベクトルを表示する。
zs <- vapply(scores, function(v) standardize(v, m, sd), numeric(1))
round(zs, 3)
