#!/usr/bin/env bash

# 用法: ./httrack_url_list.sh <url_list_file>
# 功能: 重新下載指定 URL 列表檔案中的網址

if [ -z "$1" ]; then
  echo "❌ 請提供 URL 列表檔案，例如："
  echo "   ./httrack_url_list.sh matched_urls.txt"
  exit 1
fi

URLS_FILE="$1"

if [ ! -f "$URLS_FILE" ]; then
  echo "❌ 找不到檔案：$URLS_FILE"
  exit 1
fi

httrack --list "$URLS_FILE" \
  -O "creativecommons.tw" \
  -v \
  --display \
  --robots=0 \
  --retries=3 \
  --depth=3 \
  --continue \
  --update \
  --sockets=4 \
  --assume=no \
  '-*.pdf' '-*.zip' '-*.webm' '-*.mp4' '-*.odp' '-*.ppt' \
  '-*web.archive.org*'
