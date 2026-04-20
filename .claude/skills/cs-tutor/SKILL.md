---
name: cs-tutor
description: >
  學習進度管理技能。在以下情況觸發：
  - 每次 session 開始時：讀取進度、告訴使用者學到哪
  - 學完一個 checklist 項目：更新 progress.md 並寫筆記
  - 解完一道 LeetCode 題：記錄解法、複雜度、Pattern
  - Session 結束前：提醒 git commit 並推上去
---

# CS Tutor Skill

這個技能負責維護學習連續性，確保每次打開新對話都能無縫繼續。

---

## 🔁 Skill 1：Session 開場（每次必執行）

**觸發時機：** 使用者說「開始」「繼續學習」「今天學什麼」或開啟新對話

**執行步驟：**

```bash
# 步驟 1：讀取主進度檔
cat docs/progress.md

# 步驟 2：讀取對應階段的筆記（根據 progress.md 中的當前階段）
# 例如：cat docs/cs-fundamentals/01-data-structures.md
```

**輸出格式：**

```
📍 上次進度：[階段] - [最後學到的項目]
📅 距離目標：還有 X 天（2026-08-31）
⚠️  上次卡關：[問題描述，如果有的話]

今天要繼續 [計概 / LeetCode]，還是換個方向？
```

---

## ✅ Skill 2：更新學習進度

**觸發時機：** 使用者說「學完了」「下一個」「可以打勾了」「記錄一下」

**執行步驟：**

1. 在 `CLAUDE.md` 的 checklist 把對應項目改為 `[x]`
2. 在對應的 `docs/` 筆記檔新增以下格式的內容：

```markdown
## [概念名稱]
> 學習日期：YYYY-MM-DD

**概念說明：**
[用一句白話解釋這個概念]

**關鍵語法（C#）：**
```csharp
// 程式碼範例
```

**常見錯誤：**
- [錯誤 1]
- [錯誤 2]

**我的練習：**
[練習題描述 + 我的解法或思路]

---
```

3. 更新 `docs/progress.md` 的「最後學到」欄位

---

## 🧩 Skill 3：LeetCode 解題紀錄

**觸發時機：** 使用者說「AC 了」「解完了」「記錄這題」

**執行步驟：**

1. 在 `src/LeetCode/Easy/` 或 `Medium/` 建立 `.cs` 檔案存 code
2. 在 `docs/leetcode/easy/` 或 `medium/` 建立 `.md` 紀錄：

```markdown
# #[題號] [題目名稱]

**難度：** Easy / Medium
**日期：** YYYY-MM-DD
**解題時間：** XX 分鐘
**Pattern：** [Two Pointers / HashMap / Sliding Window / DP / ...]

## 題目核心
[一句話說明這題在問什麼]

## 解題思路
1. [步驟 1]
2. [步驟 2]

## 複雜度
- 時間：O(?)
- 空間：O(?)

## 我的解法
```csharp
// 貼上最終 AC 的程式碼
```

## 學到的東西
- [這題用到的 pattern 或技巧]
- [下次可以更快的地方]

---
```

3. 更新 `docs/leetcode/patterns.md`，把這題的 pattern 加進去（如果是新 pattern）

---

## 💾 Skill 4：Git 同步提醒

**觸發時機：** 使用者說「今天學夠了」「準備結束」「掰掰」

**執行步驟：**

```bash
# 確認有什麼變更
git status

# 提示使用者確認後執行：
git add -A
git commit -m "學習進度：[今天學的內容] - $(date '+%Y-%m-%d')"
git push origin main
```

**輸出格式：**

```
今天學了：[摘要]
準備 commit 以下檔案：[列出變更的 docs/]

確認要推上去嗎？（打「推」就幫你執行）
```

---

## 📊 Skill 5：進度健康檢查

**觸發時機：** 使用者說「我進度怎麼樣」「來得及嗎」「查一下進度」

**執行步驟：**

```bash
# 統計 checklist 完成比例
grep -c '\[x\]' CLAUDE.md   # 已完成
grep -c '\[ \]' CLAUDE.md   # 未完成
```

**輸出格式：**

```
📊 整體進度：[XX/YY 項目完成]（ZZ%）

Phase 1 計概：[完成數]/[總數]
Phase 2 Easy：[完成數]/[總數]
Phase 3 Medium：[完成數]/[總數]

距離 2026-08-31 還有 X 天
建議每天完成 Y 個項目才能準時到達
```

---

## 📁 進度主檔格式（docs/progress.md）

**這個檔案由 Claude Code 維護，不要手動亂改。**

```markdown
# 學習進度

## 基本資訊
- 開始日期：2026-04-XX
- 目標日期：2026-08-31
- 最後更新：YYYY-MM-DD

## 當前狀態
- 目前 Phase：Phase 1 - 資料結構
- 最後學到：陣列 & 字串
- 卡關問題：（如果有）

## 今日學習
- 學了什麼：
- 解了哪些題：

## LeetCode 統計
- Easy 完成：0 / 20
- Medium 完成：0 / 30

## 重要筆記快取
（Claude Code 自動填入最近的重點）
```

---

## ⚙️ 關於 Hooks（選擇性設定）

如果你想讓 git commit 完全自動化（不需要手動叫我做），可以在
`.claude/settings.json` 加入：

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write|Create",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'git add -A && git commit -m \"auto: $(date +%Y-%m-%d-%H%M)\" 2>/dev/null || true'"
          }
        ]
      }
    ]
  }
}
```

**但我建議不要用這個**，原因：
- 自動 commit 會有很多垃圾訊息，git log 變很亂
- 用 Skill 4 手動確認，commit 訊息更有意義
- 出錯時比較好追蹤（你知道「今天這個 commit 學了什麼」）

只有在你很常忘記 commit 才考慮開啟。
