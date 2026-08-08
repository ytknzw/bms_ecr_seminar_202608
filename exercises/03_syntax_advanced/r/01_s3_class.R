# 【正解】01_s3_class.R — S3クラス（Student相当）

# 問題1: 点数を持つ生徒を表す S3 クラス student を定義する。
#   - student(name, score): 氏名と点数を list に入れ、class = "student" を付ける。
#   - print.student: 表示用（例: Student(name=Alice, score=72)）。
student <- function(name, score) {
  structure(list(name = name, score = score), class = "student")
}
print.student <- function(x, ...) {
  cat(sprintf("Student(name=%s, score=%g)\n", x$name, x$score))
}

# 問題2: 合否判定のジェネリック passed とメソッド passed.student を定義する。
#   - passed(x, threshold = 60): UseMethod("passed")。
#   - passed.student: score が threshold 以上なら TRUE、未満なら FALSE。
passed <- function(x, threshold = 60) {
  UseMethod("passed")
}
passed.student <- function(x, threshold = 60) {
  x$score >= threshold
}

# 問題3: 次のインスタンスを作り、passed の結果を表示する。
#   - student("Alice", 72)
#   - オブジェクト本体と passed()（既定の threshold）
#   - passed(a, threshold = 50) も試し、閾値を変えたときの結果を確認する。
a <- student("Alice", 72)
print(a)
passed(a)
passed(a, threshold = 50)
