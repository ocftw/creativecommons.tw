#!/bin/bash

# 腳本：從 HTTrack 記錄中提取 creativecommons.tw 域名下被略過的多媒體檔案
# 作者：AI Assistant
# 用途：找出 creativecommons.tw 域名下可能被略過的多媒體檔案，生成 media_tbd_cc_tw.txt 列表

echo "開始提取 creativecommons.tw 及其子域名下被略過的多媒體檔案..."

# 設定路徑
CACHE_DIR="/Users/Irvin/Downloads/sinica/cctw/creativecommons.tw/hts-cache"
OUTPUT_FILE="/Users/Irvin/Downloads/sinica/cctw/media_tbd_cc_tw.txt"

# 清空輸出檔案
> "$OUTPUT_FILE"

echo "1. 從記錄檔案中提取 creativecommons.tw 及其子域名多媒體檔案..."

# 從記錄檔案中提取 creativecommons.tw 及其子域名下的多媒體檔案 URL
if [ -f "$CACHE_DIR/new.txt" ]; then
    echo "   - 處理 new.txt..."
    grep -E '\.(pdf|zip|webm|mp4|odp|ppt)(\?|$|/)' "$CACHE_DIR/new.txt" | \
    awk '{print $7}' | \
    grep -E '\.(pdf|zip|webm|mp4|odp|ppt)(\?|$|/)' | \
    grep -E "creativecommons\.tw" >> "$OUTPUT_FILE"
fi

if [ -f "$CACHE_DIR/old.txt" ]; then
    echo "   - 處理 old.txt..."
    grep -E '\.(pdf|zip|webm|mp4|odp|ppt)(\?|$|/)' "$CACHE_DIR/old.txt" | \
    awk '{print $7}' | \
    grep -E '\.(pdf|zip|webm|mp4|odp|ppt)(\?|$|/)' | \
    grep -E "creativecommons\.tw" >> "$OUTPUT_FILE"
fi

echo "2. 從 HTML 檔案中搜尋 creativecommons.tw 及其子域名多媒體連結..."

# 從 HTML 檔案中搜尋 creativecommons.tw 及其子域名下的多媒體檔案連結
HTML_DIR="/Users/Irvin/Downloads/sinica/cctw/creativecommons.tw"
if [ -d "$HTML_DIR" ]; then
    echo "   - 搜尋 HTML 檔案中的 creativecommons.tw 及其子域名多媒體連結..."
    find "$HTML_DIR" -name "*.html" -exec grep -hoE 'https?://[^"'\'']*creativecommons\.tw[^"'\'']*\.(pdf|zip|webm|mp4|odp|ppt)(\?[^"'\'']*)?' {} \; >> "$OUTPUT_FILE"
fi

echo "3. 處理和去重複..."

# 去重複並排序
sort -u "$OUTPUT_FILE" > "${OUTPUT_FILE}.tmp"
mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE"

# 統計結果
TOTAL_COUNT=$(wc -l < "$OUTPUT_FILE")
echo "完成！共找到 $TOTAL_COUNT 個 creativecommons.tw 及其子域名多媒體檔案"
echo "結果已儲存至：$OUTPUT_FILE"

# 顯示檔案類型統計
if [ $TOTAL_COUNT -gt 0 ]; then
    echo ""
    echo "檔案類型統計："
    echo "PDF 檔案：$(grep '\.pdf' "$OUTPUT_FILE" | wc -l | tr -d ' ')"
    echo "ZIP 檔案：$(grep '\.zip' "$OUTPUT_FILE" | wc -l | tr -d ' ')"
    echo "WEBM 檔案：$(grep '\.webm' "$OUTPUT_FILE" | wc -l | tr -d ' ')"
    echo "MP4 檔案：$(grep '\.mp4' "$OUTPUT_FILE" | wc -l | tr -d ' ')"
    echo "ODP 檔案：$(grep '\.odp' "$OUTPUT_FILE" | wc -l | tr -d ' ')"
    echo "PPT 檔案：$(grep '\.ppt' "$OUTPUT_FILE" | wc -l | tr -d ' ')"
    echo ""
    echo "前 10 個多媒體檔案預覽："
    head -10 "$OUTPUT_FILE"
    if [ $TOTAL_COUNT -gt 10 ]; then
        echo "... 還有 $((TOTAL_COUNT - 10)) 個檔案"
    fi
else
    echo "未找到任何 creativecommons.tw 及其子域名多媒體檔案"
fi
