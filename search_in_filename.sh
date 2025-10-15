#!/bin/bash

# 搜索包含特定字串的檔名的檔案並列成 txt 清單
# 使用方法: ./search-files.sh <搜索目錄> <搜索字串> [輸出檔案名]

# 檢查參數數量
if [ $# -lt 2 ]; then
    echo "使用方法:"
    echo "$0 <搜索目錄> <搜索字串> [輸出檔案名]"
    echo ""
    echo "範例:"
    echo "$0 /path/to/search .delayed results.txt"
    echo "$0 . .tmp"
    echo ""
    exit 1
fi

SEARCH_DIR="$1"
SEARCH_STRING="$2"
OUTPUT_FILE="${3:-search-results-$(date +%s).txt}"

# 檢查搜索目錄是否存在
if [ ! -d "$SEARCH_DIR" ]; then
    echo "錯誤: 目錄 $SEARCH_DIR 不存在"
    exit 1
fi

echo "開始搜索目錄: $SEARCH_DIR"
echo "搜索字串: \"$SEARCH_STRING\""

# 使用 find 命令搜索檔案並寫入結果
find "$SEARCH_DIR" -type f -name "*$SEARCH_STRING*" > "$OUTPUT_FILE"

# 計算找到的檔案數量
FILE_COUNT=$(wc -l < "$OUTPUT_FILE")

echo ""
echo "搜索完成！"
echo "找到 $FILE_COUNT 個檔案"
echo "結果已寫入: $OUTPUT_FILE"

# 顯示前幾個結果作為預覽
if [ $FILE_COUNT -gt 0 ]; then
    echo ""
    echo "前 5 個結果預覽:"
    head -5 "$OUTPUT_FILE" | nl
    if [ $FILE_COUNT -gt 5 ]; then
        echo "... 還有 $((FILE_COUNT - 5)) 個檔案"
    fi
fi
