# 【正解】04_functions.py — 関数

scores = [55, 72, 88, 41, 95]

# 問題1: standardize(x, mean, sd)を定義する。
def standardize(x, mean, sd):
    return (x - mean) / sd

# 問題2: scoresの平均mと、母分散ベースの標準偏差sdを求める（分散はnで割る）。
m = sum(scores) / len(scores)
var = sum((v - m) ** 2 for v in scores) / len(scores)
sd = var**0.5
m, sd

# 問題3: 各scoreをstandardizeし、小数第3位に丸めたリストを表示する。
zs = [round(standardize(v, m, sd), 3) for v in scores]
zs
