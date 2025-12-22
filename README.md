# AIPlayground

> 一個完整的 Apple Foundation Models framework 學習專案，搭配 [13+ 專欄](https://ethanhuang13.plus/) 2025 年 12 月連載專題「[**📲 本地 AI**](https://ethanhuang13.plus/tag/local-ai/)」。

## 目錄

- [專案簡介](#專案簡介)
- [系統需求](#系統需求)
- [安裝與設定](#安裝與設定)
- [專案結構](#專案結構)
- [範例程式碼與學習資源](#範例程式碼與學習資源)
- [使用方式](#使用方式)
- [貢獻與支持](#貢獻與支持)

## 專案簡介

AIPlayground 是一個專為學習 Apple Foundation Models framework 設計的示範專案。透過這個專案，你可以：

- **學習本地 AI 技術**：了解如何在 iOS/macOS 裝置上使用 Apple Intelligence 的 Foundation Models framework
- **實作各種應用場景**：從基礎的文字生成到進階的 Tool Calling，涵蓋完整的使用案例
- **掌握最佳實踐**：學習結構化輸出、串流回應、效能測試等實務技巧
- **快速上手開發**：可以透過 Xcode Canvas 直接在 Playground 或 Preview 中執行範例

若你對上手 Foundation Models framework 或是學習 iOS 開發進階主題有興趣，歡迎加入 [13+ 專欄](https://ethanhuang13.plus/)。

## 系統需求

- **macOS**: 26.0 或以上（建議使用 26.1+）
- **Xcode**: 26.0 或以上（建議使用 26.1+）
- **Apple Intelligence**: 必須開啟 Apple Intelligence 功能才能使用 Foundation Models

## 安裝與設定

### 方法一：作為 Swift Package 使用

1. 在你的 Xcode 專案中，選擇 **File > Add Package Dependencies...**
2. 輸入此專案的 Git URL
3. 選擇你需要的 library：
   - `AIPlayground`：包含所有 Foundation Models 範例程式碼
   - `FoundationModelsUI`：提供效能測試用的 `BenchmarkingView`

### 方法二：Clone 專案直接使用

```bash
# Clone 此專案
git clone https://github.com/ethanhuang13/AIPlayground.git
cd AIPlayground

# 開啟 Xcode Workspace
open Xcode/AIPlayground.xcworkspace
```

### 設定 Apple Intelligence

1. 前往「系統設定」>「Apple Intelligence」
2. 開啟 Apple Intelligence 功能
3. 確認你的裝置支援 Apple Intelligence

## 專案結構

```
AIPlayground/
├── Sources/
│   ├── AIPlayground/              # 主要 Library
│   │   ├── Foundation Models #Playground/  # Playground 範例
│   │   └── Foundation Models #Preview/     # SwiftUI Preview 範例
│   └── FoundationModelsUI/        # UI 工具 Library
│       └── BenchmarkingView.swift # 效能測試工具
├── Xcode/                         # Sample App 專案
│   └── AIPlayground.xcworkspace
└── README.md
```

## 範例程式碼與學習資源

`AIPlayground` library 的 `Foundation Models #Playground` 與 `Foundation Models #Preview` 資料夾有數個範例，源自於個別文章：

- `Basic.swift`: [✍️iOS 本地 AI：上手 Foundation Models 的學習策略](https://ethanhuang13.plus/local-ai-series-foundation-models-hands-on/)
- `Availability.swift` and `Instructions.swift`: [🉑iOS 本地 AI：Foundation Models 的 Availability 與 Instructions](https://ethanhuang13.plus/local-ai-series-foundation-models-availability-instructions/)
- `Structured Output - Step.swift` and `Structured Output - CatProfile.swift`: [🍱iOS 本地 AI：用 Structured Output 功能讓 Foundation Models 回傳你想要的型別](https://ethanhuang13.plus/local-ai-series-foundation-models-structured-output/)
- `Prompt Builder.swift`: [🚦iOS 本地 AI：用 PromptBuilder 動態組合 Foundation Models 的 Prompt](https://ethanhuang13.plus/local-ai-series-foundation-models-prompt-builder/)
- `Streaming Response.swift`: [🛝iOS 本地 AI：不讓使用者乾等，Foundation Models 的 Stream Response 能輕鬆實現漸進式使用者體驗](https://ethanhuang13.plus/local-ai-series-stream-response/)
- `Tool Calling - Weather.swift` and `Tool Calling - Calculation.swift`: [🧮iOS 本地 AI：Foundation Models 的 Tool Calling，真正的問題是什麼時候該用](https://ethanhuang13.plus/local-ai-series-foundation-models-tool-calling/)

## 使用方式

### 在 Xcode Playground 中執行

1. 開啟 `Xcode/AIPlayground.xcworkspace`
2. 找到 `AIPlayground` library 中的範例檔案
3. 在 `Foundation Models #Playground` 資料夾中選擇任一範例
4. 執行 Playground 來查看結果

### 在 SwiftUI Preview 中執行

1. 開啟 `Xcode/AIPlayground.xcworkspace`
2. 找到 `AIPlayground` library 中的範例檔案
3. 在 `Foundation Models #Preview` 資料夾中選擇任一範例
4. 使用 Xcode 的 Canvas 功能來預覽執行結果

### 使用 FoundationModelsUI Library

`FoundationModelsUI` library 提供 `BenchmarkingView`，讓你可以在 SwiftUI 中測試從模型產生 `@Generable` 物件到畫面的完整流程。

詳情請見文章：[⏱️iOS 本地 AI：衡量 Foundation Models 效能的策略](https://ethanhuang13.plus/local-ai-series-foundation-models-benchmarking/)

使用範例：

```swift
import FoundationModels
import FoundationModelsUI
import SwiftUI

@Generable(description: "貓的性格")
enum CatPersonality: String {
  case independent = "獨立"
  case curious = "好奇"
  case playful = "愛玩"
  case mischievous = "調皮"
  case clingy = "黏人"
  case unpredictable = "無法預測"
  case lazy = "懶惰"
}

@Generable(description: "貓的基本資料")
struct CatProfile {
  @Guide(description: "中文名字")
  var name: String

  @Guide(description: "貓的年齡", .range(0...20))
  var age: Int

  @Guide(description: "性格")
  var personality: CatPersonality

  @Guide(description: "專長")
  var expertise: String
}

extension CatProfile: GenerableView {}
extension CatProfile.PartiallyGenerated: View {
  var body: some View {
    if let name = self.name {
      VStack(alignment: .leading) {
        HStack {
          Text(name)
            .font(.title)
          if let age = self.age {
            Text("\(age) 歲")
          }
        }
        if let personality = self.personality {
          Text("性格：\(personality.rawValue)")
        }
        if let expertise = self.expertise {
          Text("專長：\(expertise)")
        }
      }
    }
  }
}

#Preview("CatProfile") {
  BenchmarkingView<CatProfile>(
    instructions: """
      User locale: zh-Hant-tw
      這是一款養貓模擬遊戲。生成一隻貓作為建議選項
      """,
    prompt: "我不喜歡太黏人的貓",
    shouldPrewarm: false
  )
}
```

### 在你的專案中使用

將 AIPlayground 加入你的專案後，即可匯入使用：

```swift
import AIPlayground
import FoundationModelsUI

// 使用範例程式碼
// 或參考範例來建立你自己的 Foundation Models 應用
```

## 貢獻與支持

這個專案是 [13+ 專欄](https://ethanhuang13.plus/) 的配套教材。如果你覺得這個專案對你有幫助：

- 給這個專案一個 Star ⭐️
- 分享給更多對 iOS 本地 AI 開發有興趣的朋友
- 加入 [13+ 專欄](https://ethanhuang13.plus/) 獲得更深入的學習內容

如有任何問題或建議，歡迎新增 Issue 討論。

---

**Made with ❤️ by [Ethan Huang](https://twitter.com/ethanhuang13)**
