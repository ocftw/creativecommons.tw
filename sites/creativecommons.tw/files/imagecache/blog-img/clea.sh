#!/bin/bash

# 目標資料夾（預設為目前目錄）
DIR="${1:-.}"

# 切換到該資料夾
cd "$DIR" || exit 1

# 尋找所有含有 '?itok=' 的檔案並重新命名
for file in *'?itok='*; do
  # 確認檔案存在（避免沒有匹配時出錯）
  [ -e "$file" ] || continue

  # 移除 '?itok=...' 的部分
  newname="${file%%\?itok=*}"

  # 重新命名
  echo "Renaming: $file → $newname"
  mv "$file" "$newname"
done

echo "✅ Done!"