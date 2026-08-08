# 【正解】01_objects.R — 変数・型・演算・モジュール
# 注意: 対話モード（REPL）で実行する前提。値の確認にprint()/message()は使わず、式を評価して表示する。

# 問題1: math相当の機能はbaseに含まれるため、libraryは不要（Pythonのimport mathに相当する明示読込はない）。

# 問題2: 次の変数に値を代入する。
#   - name: 文字列（値: "ぱいそん"）
#   - age: 整数（値: 20L）
#   - score: 浮動小数点数（値: 72.5）
#   - is_passed: 論理値（scoreが60以上ならTRUE）
name <- "ぱいそん"
age <- 20L
score <- 72.5
is_passed <- score >= 60

# 問題3: 各変数の型（class）と値を表示する。
list(class(name), class(age), class(score), class(is_passed))
list(name, age, score, is_passed)

# 問題4: ageに1を足してから、結果を表示する（Rに複合代入+=はないので age <- age + 1）。
age <- age + 1
age

# 問題5: 次の演算結果を表示する。
#   - 7 %/% 2（整数除算）
#   - 7 %% 2（剰余）
#   - 2^3（累乗）
c(7 %/% 2, 7 %% 2, 2^3)

# 問題6: sqrt(9)の結果を表示する。
sqrt(9)
