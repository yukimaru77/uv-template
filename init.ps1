# 古いGit構成を削除
if (Test-Path ".git") {
    Remove-Item -Path ".git" -Recurse -Force -ErrorAction SilentlyContinue
}

# Git初期化
git init

# ライブラリインストール
uv sync

# pre-commitフックの作成
# Pythonのpre-commitパッケージは使わず、シェルスクリプトを直接配置する
$hookPath = ".git/hooks/pre-commit"
$hookContent = "#!/bin/sh
# Ruffによる修正と整形
uv run ruff check --fix .
uv run ruff format .

# 変更されたファイルをステージングに追加（これがないと修正分がコミットに含まれない）
git add .

# 成功として終了
exit 0
"

# フックファイルの書き込み（UTF-8, 改行コードLF推奨だがWindowsのGitなら動作する）
[System.IO.File]::WriteAllText($hookPath, $hookContent)

# スクリプト自身の削除
Remove-Item -Path $MyInvocation.MyCommand.Path -Force

# 初期コミット
git add .
git commit -m "Initial commit" --no-verify