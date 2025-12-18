import FoundationModels
import SwiftUI

@main
struct AIPlaygroundApp: App {
  var body: some Scene {
    WindowGroup {
      BenchmarkingView<CatProfile>(
        instructions: """
          User locale: zh-Hant-tw
          這是一款養貓模擬遊戲。提供 5 隻貓作為一開始的建議選項
          """,
        prompt: Prompt { "我不喜歡太黏人的貓" },
        prewarm: true
      )
    }
  }
}
