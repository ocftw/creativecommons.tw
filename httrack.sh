#!/usr/bin/env bash

httrack "https://creativecommons.tw" \
  -O "creativecommons.tw" \
  -v \
  --display \
  --robots=0 \
  --retries=3 \
  --depth=10 \
  --continue \
  --update \
  --sockets=4 \
  --assume=no \
  '-*.pdf' '-*.zip' '-*.webm' '-*.mp4' '-*.odp' '-*.ppt' \
  '-*web.archive.org*'