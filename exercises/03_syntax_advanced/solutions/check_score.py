# 【正解】check_score.py — check_score（Stretch）


def check_score(score: float) -> str:
    """点数を評語に変換する。

    Args:
        score: 点数。0以上100以下であること。

    Returns:
        評語。「優」「良」「可」「不可」のいずれか。
            優: 80以上
            良: 70以上80未満
            可: 50以上70未満
            不可: 50未満

    Raises:
        ValueError: score が 0–100 の外のとき。
    """
    if score < 0 or score > 100:
        raise ValueError("score out of range")
    if score >= 80:
        return "優"
    if score >= 70:
        return "良"
    if score >= 50:
        return "可"
    return "不可"
