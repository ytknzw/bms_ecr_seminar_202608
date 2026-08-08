# 【正解】02_control_flow.R — for / while / if / function

scores <- c(55, 72, 88, 41, 95)

# 問題1: for文を使いscoresの各点数が60以上なら「合格」、未満なら「不合格」と表示する。
for (score in scores) {
  label <- if (score >= 60) "合格" else "不合格"
  # for内は自動表示されないためprintが必要（PythonのREPLとは挙動が異なる）。
  print(list(score = score, label = label))
}

# 問題2: whileを使い、iを1から10まで1ずつ増やしながら合計totalを求め、表示する。
total <- 0
i <- 1
while (i <= 10) {
  total <- total + i
  i <- i + 1
}
total

# 問題3: 引数xsの平均を返す関数avg(xs)を定義する（sum(xs) / length(xs)）。
avg <- function(xs) {
  sum(xs) / length(xs)
}

# 問題4: avg(scores)の結果を表示する。
avg(scores)
