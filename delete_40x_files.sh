#!/bin/bash

# 刪除所有包含 <title>404 的 HTML 檔案

echo "開始搜尋包含 <title>40x 的 HTML 檔案..."

# 搜尋並計算檔案數量
file_count=$(find . -name "*.html" -exec grep -l "<title>40" {} \; | wc -l)

echo "找到 $file_count 個檔案需要刪除"

if [ $file_count -eq 0 ]; then
    echo "沒有找到需要刪除的檔案"
    exit 0
fi

# 詢問使用者確認
echo ""
echo "確定要刪除這些檔案嗎？(y/N)"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "開始刪除檔案..."

    # 執行刪除
    find . -name "*.html" -exec grep -l "<title>40" {} \; | xargs rm -f

    # 驗證刪除結果
    remaining_count=$(find . -name "*.html" -exec grep -l "<title>40" {} \; | wc -l)

    echo "刪除完成！"
    echo "已刪除 $((file_count - remaining_count)) 個檔案"
    echo "剩餘 $remaining_count 個檔案"
else
    echo "操作已取消"
fi
