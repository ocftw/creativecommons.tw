#!/bin/sh

# 用法: ./page_search_to_list.sh "Page not found"
# 功能: 搜尋包含指定文字的檔案並建立 matched_files.txt

ROOT_DIR="./creativecommons.tw"
SEARCH_TERM="$1"

MATCHED_FILES="matched_files.txt"

if [ -z "$SEARCH_TERM" ]; then
  echo "❌ 請提供要搜尋的字串，例如："
  echo "   ./page_search_to_list.sh \"Page not found\""
  exit 1
fi

echo "🔍 搜尋 \"$SEARCH_TERM\" 中..."
echo "[debug] 搜尋根目錄：$ROOT_DIR"
echo "[debug] 使用字串：$SEARCH_TERM"

# Step 1: 找出含指定文字的本地檔案（包括所有檔案類型）
find "$ROOT_DIR" -type f -exec grep -q "$SEARCH_TERM" {} \; -print > "$MATCHED_FILES"
echo "[debug] 檢查 matched_files.txt..."
head -n 5 "$MATCHED_FILES"

if [ ! -s "$MATCHED_FILES" ]; then
  echo "[debug] 沒有找到任何檔案包含 \"$SEARCH_TERM\"，請確認搜尋字串是否正確"
fi

echo "📁 找到 $(wc -l < "$MATCHED_FILES") 個檔案包含該文字"
echo "✅ 已輸出檔案列表：$MATCHED_FILES"
echo ""
echo "💡 提示：如需將檔案路徑轉換為 URL，請執行："
echo "   ./files_to_urls.sh"
