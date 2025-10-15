#!/bin/bash

# 檢查沒有副檔名的檔案是否為 HTML 檔案，並加上 .html 副檔名

# 設定預設目錄
TARGET_DIR="${1:-.}"

echo "開始搜尋目錄 $TARGET_DIR 下沒有副檔名的檔案..."

# 檢查目錄是否存在
if [ ! -d "$TARGET_DIR" ]; then
    echo "錯誤：目錄 '$TARGET_DIR' 不存在"
    exit 1
fi

# 以完整路徑列出所有一般檔案（排除隱藏與特殊目錄），後續再以 basename 判斷是否無副檔名
total_files=0
renamed_count=0
html_files=()
candidate_files=()

while IFS= read -r -d '' f; do
    base_name=$(basename "$f")
    # 排除隱藏檔
    case "$base_name" in
        .*) continue ;;
    esac
    # 排除已含副檔名者
    case "$base_name" in
        *.*) continue ;;
    esac
    candidate_files+=("$f")
done < <(find "$TARGET_DIR" -type f \
    ! -path "*/.git/*" \
    ! -path "*/node_modules/*" \
    ! -path "*/.*" -print0)

if [ ${#candidate_files[@]} -eq 0 ]; then
    echo "沒有找到沒有副檔名的檔案"
    exit 0
fi

total_files=${#candidate_files[@]}
echo "找到 $total_files 個沒有副檔名的檔案"

echo ""
echo "開始檢查檔案內容..."

for file in "${candidate_files[@]}"; do
    # 檢查檔案是否存在且可讀
    if [ ! -r "$file" ]; then
        echo "警告：無法讀取檔案 $file"
        continue
    fi

    # 讀取檔案前 512 個字元，去除前導空白，轉小寫，比對 <!doctype html（不區分大小寫）
    first_chars=$(LC_ALL=C head -c 512 "$file" 2>/dev/null | sed 's/^\s\+//' | tr '[:upper:]' '[:lower:]')

    if [[ "$first_chars" == "<!doctype html"* ]]; then
        html_files+=("$file")
        echo "發現 HTML 檔案：$file"

        # 檢查目標檔案是否已存在
        target_file="${file}.html"
        if [ -e "$target_file" ]; then
            echo "警告：目標檔案 $target_file 已存在，跳過重新命名"
            continue
        fi

        # 執行重新命名
        if mv "$file" "$target_file" 2>/dev/null; then
            echo "✓ 已重新命名：$file -> $target_file"
            ((renamed_count++))
        else
            echo "✗ 重新命名失敗：$file"
        fi
    fi
done

echo ""
echo "檢查完成！"
echo "總共檢查了 $total_files 個沒有副檔名的檔案"
echo "發現 $(( ${#html_files[@]} )) 個 HTML 檔案"
echo "成功重新命名 $renamed_count 個檔案"

if [ $renamed_count -gt 0 ]; then
    echo ""
    echo "已重新命名的檔案："
    for file in "${html_files[@]}"; do
        if [ -e "${file}.html" ]; then
            echo "  $file -> ${file}.html"
        fi
    done
fi
