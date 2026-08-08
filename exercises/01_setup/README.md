# Ex1 環境構築

演習用の実装スクリプトはありません。当日は [env/SETUP.md](../../env/SETUP.md) に従い、VS Code・Git・uv・Python 環境を整えます。

## 成功条件

リポジトリールートで:

```bash
uv python install 3.13 && uv sync
uv run python -c "import sys, platform; print(sys.version); print(platform.platform())"
uv run python env/check_packages.py
```

必須パッケージが OK なら Ex1 完了（推奨パッケージの WARN は可）。詳細は SETUP.md §4.4。
