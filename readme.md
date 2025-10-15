# creativecommons.tw 封存

## todo

- [ ] 把檔案中的外部資源內部化
- [ ] 把頁面中到 http(s)?://creativecommons.tw 的連結改成相對連結

- [x] 重新下載 *.tmp 檔案
- [x] 重新下載 *.delayed 檔案
- [x] 把沒有副檔名的 html 檔案加入 .html 副檔名
- [x] 補回頁面上遺失的圖片檔
- [x] 加入 script 把 github lfs 管理的檔案動態指向 github repo
- [x] 列出所有的頁面目錄與標題清單
- [x] 重新下載 zero_bytes_url.txt 的檔案
- [x] 刪除 `<title>40x` 的 HTML 檔案
- [x] 設定 git-pages repo 並將 /creativecommons.tw/creativecommons.tw 搬移到根目錄下以便打開 github pages
- [x] files/downloads/ 下的檔案實在太大了，透過 Git LFS 上傳
- [x] 如果 `<TITLE>Page has moved</TITLE>` 頁面有對應的 .html 檔案，就將其移除
- [x] 把所有的 page not found 刪除
- [x] 修正變成 0 Bytes 的檔案
- [x] feed 要改名叫 feed.xml
- [x] 移除 <script>jQuery.extend(Drupal.settings...</script> 標籤
- [x] 修正檔案內連結的 css 變成 html
- [x] 列出所有的 binary 檔案清單並且抓取
- [x] 內容有「Click here...」的頁面是沒有成功抓到的頁面

## 鏡像網站製作流程

詳細的鏡像過程可參考 commit history - [main branch](https://github.com/ocftw/creativecommons.tw/commits/main/)、[gh-pages branch](https://github.com/ocftw/creativecommons.tw/commits/gh-pages/)

1. 在 mac 上安裝 httrack

  ```bash
  ➜  ~ brew install httrack
  ```

2. 建立基礎鏡像

  ```bash
  ./httrack.sh
  ```

3. binary 檔案的擷取策略

  - 先只抓 html 網頁
  - 接著再從 hts-cache/new.txt 中列舉 binary 檔案
  - sftp 進去主機找該檔案，下載後置入，於 httrack.sh 手動排除該路徑
  - 再用 httrack_url_list.sh 抓取其餘的 binary 檔案

## 完整頁面清單

[pages.tsv](https://github.com/ocftw/creativecommons.tw/blob/main/pages.tsv) 中列舉了所有頁面

## 授權

- [main](https://github.com/ocftw/creativecommons.tw/tree/main) branch 下的所有檔案以 CC0 釋出至公眾領域。
- [gh-pages](https://github.com/ocftw/creativecommons.tw/tree/gh-pages) 內的網頁、影像與多媒體檔案，依循 creativecommons.tw 網站授權——除另有註明外，採用 [創用CC 姓名標示-相同方式分享 3.0 台灣 授權條款](https://creativecommons.org/licenses/by-sa/3.0/tw/) 釋出。