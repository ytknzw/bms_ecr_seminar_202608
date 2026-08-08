# 【正解】03_collections.py — list / dict

nums = [3, 1, 2]
names = ["ぱいそん", "あーる", "じゅりあ"]
counts = {"apple": 2, "banana": 0, "cherry": 3}

# 問題1: numsの先頭要素と末尾要素を表示する。
nums[0]
nums[-1]

# 問題2: namesに"しー"をappendし、結果のリストを表示する。
names.append("しー")
names

# 問題3: sorted(nums)の結果と、元のnums（変化していないこと）を両方表示する。
sorted(nums)
nums

# 問題4: counts.items()をforで走査し、各キーと値を表示する。
for key, value in counts.items():
    key, value
