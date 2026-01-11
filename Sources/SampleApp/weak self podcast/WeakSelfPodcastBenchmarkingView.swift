import FoundationModelsUI
import SwiftUI

#if AnyLanguageModel
  import AnyLanguageModel
#else
  import FoundationModels
#endif

struct WeakSelfPodcastBenchmarkingView: View {
  var body: some View {
    let foundationModel = SystemLanguageModel.default

    #if AnyLanguageModel
      // We use LM Studio as local LLM server
      // You can use other models service providers
      let lmStudio = OpenAILanguageModel(
        baseURL: URL(string: "http://localhost:1234/v1")!,
        apiKey: "",
        model: "google/gemma-3n-e4b",
      )
    #endif

    BenchmarkingView<String>(
      model: foundationModel,  //lmStudio, // select your own model or switch back to
      instructions: """
        User locale: zh-Hant-tw
        **weak self podcast**（名稱全部小寫）是由一三、波肥、喬喬三個人主持的節目。

        首先生成節目標題，例如：「weak self podcast Ep.114 節目標題」
        其次，節目內容的逐字稿。要有段落標題。
        逐字稿內容是讓每個主持人輪流講話。

        內容涵蓋工程師的職場與生活話題、Swift 語言的發展、特定 iOS 技術的討論、軟體工程的挑戰、電玩遊戲的心得。
        在節目尾聲進行一小段 Apple 產品或最近玩到好玩獨立遊戲的勸敗。
        prompt 是逐字稿的開頭，請接著寫下去，產生1000字的逐字稿。
        請勿生成任何程式碼。

        勸敗部分完畢以後，節目會進入最後一段。
        必定會有這句：
        **喬喬：「快樂時光特別短，又到時候說掰掰」。**
        然後剩下的部分由一三負責收尾。

        例如：
        # weak self podcast Ep.114 iOS 工程師的
        ## 開場
        一三：
        波肥：
        喬喬：
        ## （段落標題）
        一三：
        波肥：
        喬喬：
        ## 勸敗單元

        ## 收尾
        **喬喬：「快樂時光特別短，又到時候說掰掰」。**
        一三：（負責收尾）
        """,
      prompt:
        "歡迎收聽 weak self podcast，我是一三、我是波肥、我是喬喬。weak self 是一個 iOS 工程師錄給 iOS 工程師的 podcast。",
      shouldPrewarm: true
    )
  }
}

#Preview {
  WeakSelfPodcastBenchmarkingView()
}
