# 【問題】02_logging.py — logging

from logging import INFO, basicConfig, getLogger

# basicConfigでINFOレベルに設定する（formatに時刻とレベルを含める）。
basicConfig(
    level=INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)

# 問題1: loggerインスタンスをgetLogger(__name__)で作成し、
#         logger.info() / logger.debug() / logger.warning() でログを出力する。





