#!/bin/bash
# 執行方式：bash setup.sh
# 這個腳本幫你建立所有資料夾、初始化 git

echo "🚀 建立計算機概論 + LeetCode 學習專案..."

# 建立資料夾結構
mkdir -p docs/cs-fundamentals
mkdir -p docs/leetcode/easy
mkdir -p docs/leetcode/medium
mkdir -p src/LeetCode/Easy
mkdir -p src/LeetCode/Medium
mkdir -p .claude/skills/cs-tutor

# 建立 progress.md 初始版本
cat > docs/progress.md << 'EOF'
# 學習進度

## 基本資訊
- 開始日期：2026-04-20
- 目標日期：2026-08-31
- 最後更新：2026-04-20

## 當前狀態
- 目前 Phase：Phase 1 - 資料結構
- 最後學到：（還沒開始）
- 卡關問題：（無）

## 今日學習
- 學了什麼：
- 解了哪些題：

## LeetCode 統計
- Easy 完成：0 / 20
- Medium 完成：0 / 30

## 重要筆記快取
（Claude Code 自動填入）
EOF

# 建立各筆記檔
for f in 01-data-structures 02-algorithms 03-os-basics 04-networking 05-databases; do
  cat > docs/cs-fundamentals/$f.md << EOF
# ${f} 學習筆記

## 學習進度 Checklist
（Claude Code 會在這裡自動加入 checkmark）

---

（筆記由 Claude Code 自動整理，每學完一個項目就會更新）
EOF
done

cat > docs/leetcode/patterns.md << 'EOF'
# LeetCode 解題模式整理

## Two Pointers
- 適用：排序陣列、找配對、回文判斷
- 題目：

## Sliding Window
- 適用：連續子陣列/子字串的最大/最小問題
- 題目：

## HashMap / HashSet
- 適用：查重複、找配對、計數
- 題目：

## Stack（單調棧）
- 適用：下一個更大/更小元素
- 題目：

## BFS（Queue）
- 適用：最短路徑、層次遍歷
- 題目：

## DFS（遞迴/Stack）
- 適用：路徑搜尋、樹的遍歷、圖的連通性
- 題目：

## Binary Search
- 適用：排序陣列搜尋、「最小化最大值」類問題
- 題目：

## Dynamic Programming
- 適用：最優子結構、重疊子問題
- 題目：

## Backtracking
- 適用：排列、組合、子集合、路徑
- 題目：
EOF

# 建立 .gitignore
cat > .gitignore << 'EOF'
# .NET
bin/
obj/
*.user
.vs/

# macOS
.DS_Store

# 個人設定（不推上 git）
.claude/settings.local.json
EOF

# 把 SKILL.md 複製進 .claude/skills/cs-tutor/
cp SKILL.md .claude/skills/cs-tutor/SKILL.md

# 建立 dotnet console 專案（LeetCode C# 用）
echo "正在建立 C# 專案..."
cd src/LeetCode
dotnet new console -n Easy --force > /dev/null 2>&1 && echo "✅ Easy 專案建立完成"
dotnet new console -n Medium --force > /dev/null 2>&1 && echo "✅ Medium 專案建立完成"
cd ../..

# 初始化 git
git init
git add -A
git commit -m "init: 建立計算機概論 + LeetCode 學習專案 - 2026-04-20"

echo ""
echo "✅ 完成！接下來："
echo "1. 把這個資料夾推上 GitHub："
echo "   git remote add origin https://github.com/你的帳號/cs-leetcode-learning.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "2. 打開 Claude Code："
echo "   claude"
echo ""
echo "3. 說：「開始今天的學習」，Claude 會自動讀取進度"
