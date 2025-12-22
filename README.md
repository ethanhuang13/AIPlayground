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

其中，`AIPlayground` library 的 `Foundation Models #Playground` 與 `Foundation Models #Preview` 資料夾有數個範例。

## 使用 FoundationModelsUI library

此專案也可以透過 `import FoundationModelsUI` library 來使用 `BenchmarkingView`。

這是個方便在 SwiftUI 中測試從模型產生 `@Generable` 物件到畫面過程的工具。

詳情請見文章：[⟨⏱️iOS 本地 AI：衡量 Foundation Models 效能的策略⟩](https://ethanhuang13.plus/local-ai-series-foundation-models-benchmarking/)

## 使用 Sample App Project

如果你想開發此專案，或是想直接使用 sample app project（而非把 Package 加到自己的專案），請打開專案資料夾中的 `Xcode > AIPlayground.xcworkspace`。
