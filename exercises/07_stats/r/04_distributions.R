# 対訳 — Stretch 04 — 分布と外れ値
# Body_Massの平均値、標準偏差、種ごとの分位点、外れ値件数を全体と種ごとで表示してください。
# r/ に入って実行: Rscript 04_distributions.R
library(dplyr)
library(readr)

df <- read_csv("../../../data/penguins.csv", show_col_types = FALSE)
x <- df$Body_Mass[!is.na(df$Body_Mass)]
m <- mean(x)
s <- sd(x)
message(sprintf("mean=%.1f sd=%.1f", m, s))

print("--- quantiles by Species_short ---")
df |>
  filter(!is.na(Body_Mass)) |>
  group_by(Species_short) |>
  summarise(
    q05 = quantile(Body_Mass, 0.05),
    q50 = quantile(Body_Mass, 0.5),
    q95 = quantile(Body_Mass, 0.95),
    .groups = "drop"
  ) |>
  print()

q1 <- as.numeric(quantile(x, 0.25))
q3 <- as.numeric(quantile(x, 0.75))
iqr <- q3 - q1
lo <- q1 - 1.5 * iqr
hi <- q3 + 1.5 * iqr
z <- (x - m) / s
message(sprintf("IQR fences (overall): [%.1f, %.1f]  n_out=%d", lo, hi, sum(x < lo | x > hi)))
message(sprintf("|z|>3 (overall): n_out=%d", sum(abs(z) > 3)))

message("--- within Species_short (IQR) ---")
df |>
  filter(!is.na(Body_Mass)) |>
  group_by(Species_short) |>
  group_walk(\(g, key) {
    vals <- g$Body_Mass
    qq1 <- as.numeric(quantile(vals, 0.25))
    qq3 <- as.numeric(quantile(vals, 0.75))
    flo <- qq1 - 1.5 * (qq3 - qq1)
    fhi <- qq3 + 1.5 * (qq3 - qq1)
    n_out <- sum(vals < flo | vals > fhi)
    message(sprintf(
      "%s: fences=[%.1f, %.1f]  n_out=%d",
      key$Species_short, flo, fhi, n_out
    ))
  })
