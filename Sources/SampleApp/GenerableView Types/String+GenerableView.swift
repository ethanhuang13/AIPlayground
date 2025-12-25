import FoundationModelsUI
import SwiftUI

#if AnyLanguageModel
  import AnyLanguageModel
#else
  import FoundationModels
#endif

extension String: GenerableView {}
extension String: @retroactive View {
  public var body: some View {
    if let text = try? AttributedString(
      markdown: self,
      options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
    ) {
      Text(text)
        .textSelection(.enabled)
    } else {
      Text(self)
        .textSelection(.enabled)
    }
  }
}

struct StringBenchmarkingView: View {
  var body: some View {
    BenchmarkingView<String>(
      instructions: """
        User locale: zh-Hant-tw
        這是一款養貓模擬遊戲。提供 5 隻貓作為一開始的建議選項
        """,
      prompt: "我不喜歡太黏人的貓",
      shouldPrewarm: false
    )
  }
}

#Preview {
  StringBenchmarkingView()
}
