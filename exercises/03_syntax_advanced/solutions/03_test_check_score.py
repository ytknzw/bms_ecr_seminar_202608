# 【正解】03_test_check_score.py — pytest（Stretch）
# check_score.py の check_score を検証する（同じディレクトリで実行）。

import pytest
from check_score import check_score


# 問題1: 境界値で優・良を検証する（80→優、90→優、79.9→良、70→良）。
def test_yuu_ryou():
    assert check_score(80) == "優"
    assert check_score(90) == "優"
    assert check_score(79.9) == "良"
    assert check_score(70) == "良"


# 問題2: 境界値で可・不可を検証する（69.9→可、50→可、49.9→不可）。
def test_ka_fuka():
    assert check_score(69.9) == "可"
    assert check_score(50) == "可"
    assert check_score(49.9) == "不可"


# 問題3: 範囲外（-1, 101）でValueErrorになることを検証する。
def test_invalid():
    with pytest.raises(ValueError):
        check_score(-1)
    with pytest.raises(ValueError):
        check_score(101)
