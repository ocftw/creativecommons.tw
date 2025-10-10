#!/bin/sh

# 用法: ./files_to_urls.sh
# 從 matched_files.txt 讀取檔案列表，生成對應的 URL 列表到 matched_urls.txt

ROOT_DIR="./creativecommons.tw"
CACHE_FILE="$ROOT_DIR/hts-cache/new.txt"
MATCHED_FILES="matched_files.txt"
MATCHED_URLS="matched_urls.txt"

if [ ! -f "$MATCHED_FILES" ]; then
  echo "❌ 找不到 matched_files.txt，請先執行 page_search_to_list.sh"
  exit 1
fi

if [ ! -f "$CACHE_FILE" ]; then
  echo "❌ 找不到 cache file: $CACHE_FILE"
  exit 1
fi

echo "🔗 開始將檔案路徑映射為 URL..."
echo "[debug] 讀取檔案：$MATCHED_FILES"
echo "[debug] 快取檔案：$CACHE_FILE"

# 建立 local → URL 映射檔
TMP_MAPPING="tmp_mapping.txt"
echo "[debug] 建立 URL 映射表..."
# 包含所有檔案類型，不管狀態碼
awk -F'\t' '{print $8 "\t" $9}' "$CACHE_FILE" > "$TMP_MAPPING"

echo "[debug] 映射表建立完成，共 $(wc -l < "$TMP_MAPPING") 筆記錄"

# 清空輸出檔案
> "$MATCHED_URLS"

# 統計變數
total_files=0
matched_count=0

# 開始比對輸出 URL
while IFS= read -r fullpath; do
  total_files=$((total_files + 1))
  relpath="${fullpath#$ROOT_DIR/}"
  relpath="${relpath#./}"

  echo "[debug] 處理檔案 $total_files: $relpath"

  # 直接查找精確對應
  url=$(awk -F'\t' -v p="$relpath" '$2 == p {print $1}' "$TMP_MAPPING")

  # 如果沒找到，嘗試添加 creativecommons.tw/creativecommons.tw/ 前綴
  if [ -z "$url" ]; then
    cleanpath="${relpath#creativecommons.tw/}"
    altpath="creativecommons.tw/creativecommons.tw/$cleanpath"
    url=$(awk -F'\t' -v p="$altpath" '$2 == p {print $1}' "$TMP_MAPPING")
    echo "[debug] 嘗試 altpath: $altpath"
  fi

  # 如果還是沒找到，嘗試去除 .html 後綴
  if [ -z "$url" ]; then
    noext="${relpath%.html}"
    cleanpath="${noext#creativecommons.tw/}"
    altpath="creativecommons.tw/creativecommons.tw/$cleanpath"
    url=$(awk -F'\t' -v p="$altpath" '$2 == p {print $1}' "$TMP_MAPPING")
    echo "[debug] 嘗試去除.html後綴: $altpath"
  fi

  # 如果還是沒找到，嘗試 fallback：去除 index.html
  if [ -z "$url" ]; then
    case "$relpath" in
      */index.html)
        fallback="${relpath%/index.html}/"
        url=$(awk -F'\t' -v p="$fallback" '$2 == p {print $1}' "$TMP_MAPPING")
        echo "[debug] 嘗試 fallback: $fallback"
        ;;
    esac
  fi

  # 如果還是沒找到，嘗試直接匹配檔案名
  if [ -z "$url" ]; then
    filename=$(basename "$relpath")
    url=$(awk -F'\t' -v f="$filename" '$2 ~ f {print $1}' "$TMP_MAPPING" | head -1)
    echo "[debug] 嘗試檔案名匹配: $filename"
  fi

  # 如果還是沒找到，嘗試 URL 編碼後匹配
  if [ -z "$url" ]; then
    # 使用 python 進行 URL 編碼，並轉為小寫
    encoded_path=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$relpath', safe='/').lower())" 2>/dev/null)
    # 添加前綴以匹配映射表中的路徑格式（移除重複的前綴）
    if [[ "$encoded_path" == creativecommons.tw/* ]]; then
      # 如果已經有 creativecommons.tw 前綴，只添加 creativecommons.tw/ 前綴
      encoded_path="creativecommons.tw/$encoded_path"
    else
      # 如果沒有前綴，添加完整的前綴
      encoded_path="creativecommons.tw/creativecommons.tw/$encoded_path"
    fi
    if [ "$encoded_path" != "$relpath" ]; then
      echo "[debug] 嘗試 URL 編碼: $relpath -> $encoded_path"
      # 在映射表中搜尋編碼後的路徑
      url=$(awk -F'\t' -v p="$encoded_path" '$2 == p {print $1}' "$TMP_MAPPING")
      if [ -z "$url" ]; then
        # 嘗試添加前綴
        altpath="creativecommons.tw/creativecommons.tw/$encoded_path"
        url=$(awk -F'\t' -v p="$altpath" '$2 == p {print $1}' "$TMP_MAPPING")
        if [ -n "$url" ]; then
          echo "[debug] ✅ 找到 URL 編碼匹配: $altpath -> $url"
        fi
      else
        echo "[debug] ✅ 找到 URL 編碼匹配: $encoded_path -> $url"
      fi
    fi
  fi

  if [ -n "$url" ]; then
    matched_count=$((matched_count + 1))
    if [ "$matched_count" -le 5 ]; then
      echo "[debug] ✅ 對應成功：$relpath → $url"
    fi
    echo "$url" >> "$MATCHED_URLS"
  else
    echo "[debug] ❌ 無法對應：$relpath"
  fi
done < "$MATCHED_FILES"

# 清理臨時檔案
[ -f "$TMP_MAPPING" ] && rm "$TMP_MAPPING"

echo "✅ 處理完成！"
echo "📊 統計："
echo "   - 總檔案數：$total_files"
echo "   - 成功映射：$matched_count"
echo "   - 失敗映射：$((total_files - matched_count))"
echo "   - 成功率：$((matched_count * 100 / total_files))%"
echo "📄 已輸出網址列表：$MATCHED_URLS"
