# 01-data-structures 學習筆記

## 學習進度 Checklist

**陣列 & 字串**
- [x] 陣列記憶體結構：連續記憶體 vs 鏈結記憶體的差別
- [x] `Array` vs `List<T>` vs `LinkedList<T>`：什麼情況選哪個
- [x] 時間複雜度：隨機存取 O(1)、插入/刪除 O(n) 的原因
- [x] 字串不可變性（immutable）：為什麼 `+=` 很慢，`StringBuilder` 何時用
- [ ] 練習：實作一個 circular buffer（環形緩衝區）

**Stack & Queue**
- [x] Stack（LIFO）：call stack、遞迴本質是 stack
- [x] Queue（FIFO）：BFS 用 Queue 的原因
- [x] C# 實作：`Stack<T>`、`Queue<T>`、`Deque`（`LinkedList` 模擬）
- [x] Monotonic Stack 概念（面試常考）
- [x] 練習：用 Stack 實作「合法括號判斷」

**Hash Table**
- [x] Hash function 是什麼，碰撞（collision）怎麼解決
- [x] `Dictionary<K,V>` 的時間複雜度：平均 O(1) vs 最壞 O(n)
- [x] `HashSet<T>` vs `Dictionary<K,V>` 的使用場景
- [x] 面試常見模式：Two Sum 為什麼用 HashMap 解
- [ ] 練習：設計一個 LRU Cache（不用程式庫）

**Tree**
- [ ] Tree 基本術語：root、leaf、height、depth
- [ ] Binary Search Tree（BST）：插入/搜尋/刪除邏輯
- [ ] BST 退化問題 → 引出平衡樹概念（AVL/Red-Black，知道概念即可）
- [ ] Heap（Min/Max）：`PriorityQueue<T,P>` 在 C# 怎麼用
- [ ] Trie（前綴樹）：字典搜尋、autocomplete 應用
- [ ] 練習：手寫 BST insert + inorder traversal

**Graph**
- [ ] 圖的表示法：Adjacency List vs Adjacency Matrix（各自優劣）
- [ ] BFS vs DFS：用途差異，面試選哪個的判斷依據
- [ ] Topological Sort（拓樸排序）：為什麼面試常考（依賴關係問題）
- [ ] Union-Find（Disjoint Set）：判斷連通性
- [ ] 練習：用 BFS 找出兩點之間最短路徑

---

## 陣列記憶體結構：連續記憶體 vs 鏈結記憶體
> 學習日期：2026-04-20

**概念說明：**
陣列佔用連續記憶體，可用公式直接算出任意元素的位址；LinkedList 元素分散各處，靠指標（記憶體位址）串起來。

**連續記憶體（Array / List）：**
```
位址：  1000  1004  1008
值：    [10]  [20]  [30]

存取 arr[2] = 1000 + (2 × 4) = 1008，直接跳過去 → O(1)
```

**鏈結記憶體（LinkedList）：**
```
1000：[10 | 下一個→2500]
2500：[20 | 下一個→0300]
0300：[30 | 下一個→null]

找第3個元素 → 要從頭跟著指標走 → O(n)
```

**指標（Pointer）：**
- 指標是「記憶體位址」，不是值本身
- LinkedList 每個節點存「下一個節點在哪裡」，這就是指標
- C# 日常開發不需要直接操作指標，但 LinkedList 底層就是靠它串接

---

## Array vs List\<T\> vs LinkedList\<T\>：什麼情況選哪個
> 學習日期：2026-04-20

**複雜度比較：**

| 操作 | `int[]` | `List<T>` | `LinkedList<T>` |
|---|---|---|---|
| 隨機存取 `[i]` | O(1) | O(1) | O(n) |
| 尾端新增 | ❌ 不支援 | O(1) 均攤 | O(1) |
| 頭部插入/刪除 | ❌ 不支援 | O(n) | O(1) |
| 中間插入/刪除 | ❌ 不支援 | O(n) | O(n) |
| 大小 | 固定，記憶體不變 | 動態 | 動態 |

**關鍵細節：**
- `int[]` 清空資料後記憶體依然佔用那幾格，要等 GC 回收才釋放
- `List<T>` 底層是陣列，尾端 `.Add()` 通常 O(1)，但當陣列滿了會：
  1. 開一塊**兩倍大**的新記憶體
  2. 把所有元素**複製過去** → O(n)
  3. 再加入新元素
  - 平均下來還是 O(1)，術語叫 **均攤 O(1)（amortized O(1)）**
- `LinkedList` 中間插入/刪除整體是 O(n)，因為找到節點本身就要 O(n)

**什麼時候選哪個：**
- 大部分情況用 `List<T>`（簡單、cache friendly、夠用）
- 需要頻繁在**頭部**插入/刪除 → 考慮 `LinkedList<T>`
- `LinkedList` 實務使用頻率低，面試考它主要是考你懂不懂指標和複雜度

**面試這樣說：**
> "`List.Add()` 通常是 O(1)，但觸發擴容時是 O(n)，均攤下來是 O(1)。"

---

## 字串不可變性（String Immutability）
> 學習日期：2026-04-20

**概念說明：**
字串一旦建立內容永遠不能改，所有「修改」都是建立一個全新字串。

**關鍵行為：**
```csharp
string s = "Hello";
s += " World";
// 記憶體裡有兩個字串："Hello" 和 "Hello World"
// s 只是改成指向新字串，舊的等 GC 回收
```

**為什麼迴圈裡 += 很慢（O(n²)）：**
```csharp
string s = "";
for (int i = 0; i < n; i++)
{
    s += i;  // 每次都複製整個字串！
}
// 複製次數：1 + 2 + 3 + ... + n = n(n+1)/2 → O(n²)
```

**StringBuilder 解法（O(n)）：**
```csharp
var sb = new StringBuilder();
for (int i = 0; i < n; i++)
{
    sb.Append(i);  // 直接在同一塊記憶體加，不建立新字串
}
string result = sb.ToString();  // 最後才建立一個字串
```

**什麼時候用 StringBuilder：** 字串需要在迴圈裡反覆拼接時。一兩次 `+=` 沒差。

---

## 時間複雜度直覺
> 學習日期：2026-04-20

**概念說明：**
衡量程式執行次數隨資料量 n 成長的速度。

**各複雜度對照（n = 1000）：**

| 複雜度 | 操作次數 | 感覺 |
|---|---|---|
| O(1) | 1 次 | 瞬間 |
| O(log n) | ~10 次 | 很快 |
| O(n) | 1,000 次 | 還好 |
| O(n log n) | ~10,000 次 | 可接受 |
| O(n²) | 1,000,000 次 | 慢 |

**快速判斷口訣：**
- 一層迴圈 → O(n)
- 兩層巢狀迴圈 → O(n²)
- 每次把問題砍半（如二分搜尋）→ O(log n)
- 一層迴圈裡面砍半 → O(n log n)（如 Merge Sort）

---

## Hash Table
> 學習日期：2026-04-20

**概念說明：**
用 Hash Function 把 Key 轉換成位址，直接跳到那個位址存取，達到平均 O(1)。

**Hash Function：**
```
Hash("Roger") → 42  → 位址 42 存 Roger
Hash("Alice") → 7   → 位址 7  存 Alice

查詢 "Roger"：計算 Hash("Roger") → 42 → 直接去位址 42 → O(1)
```

**碰撞（Collision）與 Chaining：**
```
Hash("Roger") → 42
Hash("Mary")  → 42  ← 撞了！

解法：位址 42 改存 LinkedList
位址 42： Roger → Mary → null
```
C# 底層自動處理，不需要自己實作。

**C# 使用：**
```csharp
// Dictionary：Key查Value
var dict = new Dictionary<string, int>();
dict["Roger"] = 25;
dict.ContainsKey("Roger");  // true
dict["Roger"];              // 25

// HashSet：只判斷有沒有
var set = new HashSet<string>();
set.Add("Roger");
set.Contains("Roger");  // true
```

**HashSet vs Dictionary：**
- `HashSet<T>` = 只有 Key 的字典，用來判斷「有沒有」、去重複
- `Dictionary<K,V>` = Key 查 Value，用來查表、計數
- 底層：`HashSet<T>` 就是 `Dictionary<T, 空的>`

**複雜度：**
- 平均 O(1)，最壞 O(n)（大量碰撞時 LinkedList 變很長，正常使用不會發生）

**Two Sum 解法（HashMap O(n)）：**
```csharp
public int[] TwoSum(int[] nums, int target)
{
    var dict = new Dictionary<int, int>(); // Key=數字, Value=index

    for (int i = 0; i < nums.Length; i++)
    {
        int need = target - nums[i];

        if (dict.ContainsKey(need))
            return new int[] { dict[need], i };

        dict[nums[i]] = i;  // 先查再存，避免同一個元素用兩次
    }

    return new int[] {};
}
```
關鍵：**先查再存**，否則 `[3,3] target=6` 會把自己查到。

---

## Stack & Queue
> 學習日期：2026-04-20

**Stack（LIFO 後進先出）：**
```csharp
var stack = new Stack<int>();
stack.Push(1);    // 放入頂端
stack.Push(2);
stack.Peek();     // 看頂端：2（不取出）
stack.Pop();      // 取出頂端：2
```

**Queue（FIFO 先進先出）：**
```csharp
var queue = new Queue<int>();
queue.Enqueue(1);  // 從尾端加入
queue.Enqueue(2);
queue.Peek();      // 看最前端：1（不取出）
queue.Dequeue();   // 取出最前端：1
```

**複雜度：** Push/Pop/Enqueue/Dequeue 均攤 O(1)（底層是陣列，偶爾擴容）

**對比：**

| | Stack | Queue |
|---|---|---|
| 規則 | LIFO 後進先出 | FIFO 先進先出 |
| 加入 | `Push` | `Enqueue` |
| 取出 | `Pop` | `Dequeue` |
| 用途 | 遞迴、括號配對、undo/redo | BFS、背景工作排程 |

**Stack 實際應用：**
- Call Stack：每個函式呼叫都 Push，執行完 Pop，無限遞迴 → Stack Overflow
- Valid Parentheses（#20）：開括號 Push，關括號 Pop 比對，最後 Stack 要是空的

**實務補充：**
- 直接用 `Stack<T>` `Queue<T>` 的機會不多，但概念無所不在
- Queue 概念：Azure Service Bus、RabbitMQ、Hangfire 等工作排程工具底層都是 Queue

**合法括號判斷（#20 Valid Parentheses）思路：**
1. 遇到開括號 `( [ {` → Push
2. 遇到關括號 `) ] }` → Pop，檢查是否配對
3. 最後 Stack 要是空的 → 合法

```
"([)]" 走到 ) 時，Pop 出來是 [，不配對 → 不合法 ❌
"({[]})" 每次 Pop 都配對，最後 Stack 空 → 合法 ✅
```

**Monotonic Stack（單調堆疊）：**
維護一個永遠遞減的 Stack，用來解「找右邊第一個更大的數字」類型的題目。

```
[3, 1, 4, 2, 5] → 找每個數字右邊第一個比它大的

走到 3 → Push        Stack: [3]
走到 1 → Push        Stack: [3,1]
走到 4 → 4>1 Pop 1，答案4；4>3 Pop 3，答案4；Push 4   Stack: [4]
走到 2 → Push        Stack: [4,2]
走到 5 → 5>2 Pop 2，答案5；5>4 Pop 4，答案5；Push 5   Stack: [5]

結果：3→4, 1→4, 4→5, 2→5, 5→-1（留在Stack裡的沒有答案）
```

為什麼 O(n)：每個元素最多 Push 一次、Pop 一次，共 2n 次操作。

**LeetCode #739 Daily Temperatures（Monotonic Stack 變形）：**
- 題目：每天要等幾天後氣溫才會升高？
- 差別：Stack 存 index，答案是 `i - idx`（距離幾天）

```csharp
public int[] DailyTemperatures(int[] temperatures) {
    int n = temperatures.Length;
    int[] result = new int[n];
    var stack = new Stack<int>(); // 存 index

    for (int i = 0; i < n; i++) {
        while (stack.Count > 0 && temperatures[i] > temperatures[stack.Peek()])
        {
            int idx = stack.Pop();
            result[idx] = i - idx;
        }
        stack.Push(i);
    }
    return result;
}
```

---
