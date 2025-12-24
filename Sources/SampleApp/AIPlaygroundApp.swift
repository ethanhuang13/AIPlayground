import FoundationModelsUI
import SwiftUI

#if AnyLanguageModel
  import AnyLanguageModel
#else
  import FoundationModels
#endif

@main
struct AIPlaygroundApp: App {
  var body: some Scene {
    WindowGroup {
      let model = SystemLanguageModel.default
      BenchmarkingView<String>(
        model: model,
        instructions: """
          生成一段 podcast 的逐字稿。
          `weak self podcast` 是由一三、波肥、喬喬三個人主持的節目，請讓每個人輪流講話。
          內容涵蓋工程師的職場與生活話題、Swift 語言的發展、特定 iOS 技術的討論、軟體工程的挑戰、電玩遊戲的心得。
          在節目尾聲進行一小段 Apple 產品或最近玩到好玩遊戲的勸敗。
          prompt 是逐字稿的開頭，請接著寫下去，產生2000字的逐字稿。
          請勿生成任何程式碼。
          """,
        prompt:
          "歡迎收聽 weak self podcast，我是一三、我是波肥、我是喬喬。weak self 是一個 iOS 工程師錄給 iOS 工程師的 podcast。",
        shouldPrewarm: true
      )
    }
  }
}
