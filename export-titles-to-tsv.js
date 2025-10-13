#!/usr/bin/env node

// export-titles-to-tsv.js
// 用途：輸出指定根目錄下所有 .html 的相對路徑與 <title> 成 .tsv 檔
// 用法：node export-titles-to-tsv.js [根目錄] [輸出檔路徑]
// 範例：node export-titles-to-tsv.js "/Users/Irvin/Downloads/sinica/cctw" "./pages.tsv"

const fs = require('fs');
const fsp = fs.promises;
const path = require('path');

async function* walk(dir) {
  const entries = await fsp.readdir(dir, { withFileTypes: true });
  for (const entry of entries) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      yield* walk(full);
    } else if (entry.isFile() && entry.name.toLowerCase().endsWith('.html')) {
      yield full;
    }
  }
}

function extractTitle(html) {
  const m = html.match(/<title[^>]*>([\s\S]*?)<\/title>/i);
  if (!m) return '';
  return m[1]
    .replace(/[\r\n\t]+/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

async function main() {
  const rootDir = process.argv[2] || "./";
  const outFile = process.argv[3] || path.join(process.cwd(), "pages.tsv");

  const stat = await fsp.stat(rootDir).catch(() => null);
  if (!stat || !stat.isDirectory()) {
    console.error(`根目錄不存在或不是目錄: ${rootDir}`);
    process.exit(1);
  }

  const rows = [];
  for await (const full of walk(rootDir)) {
    let html;
    try {
      html = await fsp.readFile(full, 'utf8');
    } catch (e) {
      console.warn(`讀取失敗(略過): ${full} - ${e.message}`);
      continue;
    }
    const title = extractTitle(html);
    const rel = path.relative(rootDir, full).split(path.sep).join('/');
    const safeTitle = title.replace(/\t/g, ' ');
    rows.push(`${rel}\t${safeTitle}`);
  }

  rows.sort((a, b) => a.localeCompare(b, 'en'));

  const tsv = ['path\ttitle', ...rows].join('\n') + '\n';
  await fsp.writeFile(outFile, tsv, 'utf8');

  console.log(`已輸出 TSV: ${outFile}`);
  console.log(`總筆數: ${rows.length}`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
