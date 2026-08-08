# 【正解】02_control_flow.py — for / while / if / def

scores = [55, 72, 88, 41, 95]

# 問題1: for文を使いscoresの各点数が60以上なら「合格」、未満なら「不合格」と表示する。
for score in scores:
    label = "合格" if score >= 60 else "不合格"
    score, label  # スクリプトとして実行する場合にはprint()関数を使って表示する。

# 問題2: whileを使い、iを1から10まで1ずつ増やしながら合計totalを求め、表示する。
total = 0
i = 1
while i <= 10:
    total += i
    i += 1
total

# 問題3: 引数xsの平均を返す関数avg(xs)を定義する（sum(xs) / len(xs)）。
def avg(xs):
    return sum(xs) / len(xs)

# 問題4: avg(scores)の結果を表示する。
avg(scores)
