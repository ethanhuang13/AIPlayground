# AIPlayground

這是一個搭配 [13+ 專欄](https://ethanhuang13.plus/) 2025 年 12 月連載專題「[**📲 本地 AI**](https://ethanhuang13.plus/tag/local-ai/)」的示範專案。

若你對上手 Foundation Models framework 或是學習 iOS 開發進階主題有興趣，歡迎加入 [13+ 專欄](https://ethanhuang13.plus/)。 

## 需求

- macOS 26.0，建議使用 26.1 以上版本
- 欲使用 Foundation Models，請開啟 Apple Intelligence
- Xcode 26.0，建議使用 26.1 以上版本

## 參考 AIPlayground library

讀者可以參考此專案建立自己的 Foundation Models framework 研究專案。

此專案本身就是一個 `AIPlayground` Swift Package。

其中，`AIPlayground` library 的 `Foundation Models #Playground` 與 `Foundation Models #Preview` 資料夾有數個範例，對應著個別文章：

- `Basic.swift`: [✍️iOS 本地 AI：上手 Foundation Models 的學習策略](https://ethanhuang13.plus/local-ai-series-foundation-models-hands-on/)
- `Availability.swift` and `Instructions.swift`: [🉑iOS 本地 AI：Foundation Models 的 Availability 與 Instructions](https://ethanhuang13.plus/local-ai-series-foundation-models-availability-instructions/)
- `Structured Output - Step.swift` and `Structured Output - CatProfile.swift`: [🍱iOS 本地 AI：用 Structured Output 功能讓 Foundation Models 回傳你想要的型別](https://ethanhuang13.plus/local-ai-series-foundation-models-structured-output/)
- `Prompt Builder.swift`: [🚦iOS 本地 AI：用 PromptBuilder 動態組合 Foundation Models 的 Prompt](https://ethanhuang13.plus/local-ai-series-foundation-models-prompt-builder/)
- `Streaming Response.swift` [🛝iOS 本地 AI：不讓使用者乾等，Foundation Models 的 Stream Response 能輕鬆實現漸進式使用者體驗](https://ethanhuang13.plus/local-ai-series-stream-response/)
- `Tool Calling - Weather.swift` and `Tool Calling - Calculation.swift`: [🧮iOS 本地 AI：Foundation Models 的 Tool Calling，真正的問題是什麼時候該用](https://ethanhuang13.plus/local-ai-series-foundation-models-tool-calling/)

## 使用 FoundationModelsUI library

此專案也可以透過 `import FoundationModelsUI` library 來使用 `BenchmarkingView`。

這是個方便在 SwiftUI 中測試從模型產生 `@Generable` 物件到畫面過程的工具。

詳情請見文章：[⏱️iOS 本地 AI：衡量 Foundation Models 效能的策略](https://ethanhuang13.plus/local-ai-series-foundation-models-benchmarking/)

## 使用 Sample App Project

如果你想開發此專案，或是想直接使用 sample app project（而非把 Package 加到自己的專案），請打開專案資料夾中的 `Xcode > AIPlayground.xcworkspace`。
