# creativecommons.tw 封存

## todo

- [ ] 重新下載 *.tmp 檔案
- [ ] 重新下載 *.delayed 檔案
- [ ] 把檔案中的外部資源內部化
- [ ] 刪除沒有附檔名，但是有同名 .html 檔案的檔案
- [ ] 把頁面中到 http(s)?://creativecommons.tw 的連結改成相對連結

- [x] 補回頁面上遺失的圖片檔
- [x] 加入 script 把 github lfs 管理的檔案動態指向 github repo
- [x] 列出所有的頁面目錄與標題清單
- [x] 重新下載 zero_bytes_url.txt 的檔案
- [x] 刪除 <title>40x 的 HTML 檔案
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

## 建立鏡像流程

### 在 mac 上安裝 httrack

```bash
➜  ~ brew install httrack
```

### Mirror

```bash
./httrack.sh
```

### 看到 binary 的策略

1. 第一次先抓 html
2. 第二次再從 hts-cache/new.txt 抓 binary

用 sftp 進去主機找該檔案，另外下載後置入，於 httrack.sh 手動排除該路徑

### binary 檔案位置

```text

```

## 頁面清單

```text

```
