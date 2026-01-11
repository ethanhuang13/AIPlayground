import FoundationModelsUI
import SwiftUI

#if AnyLanguageModel
  import AnyLanguageModel
#else
  import FoundationModels
#endif

@Generable
struct CatProfiles {
  @Guide(description: "貓", .count(5))
  var catProfiles: [CatProfile]
}

extension CatProfiles: GenerableView {}

extension CatProfiles.PartiallyGenerated: View {
  var body: some View {
    if let catProfiles {
      // XXX: With `AnyLanguageModel`, use catProfiles.asPartiallyGenerated()
      // as a workaround of an AnyLanguageModel's @Generable macro bug:
      // It generated `var [CatProfile]` instead of `var [CatProfile].PartiallyGenerated`
      // With `AnyLanguageModel`, use catProfiles.asPartiallyGenerated()
      ForEach(catProfiles) {
        catProfile in catProfile
      }
    }
  }
}

struct CatProfilesBenchmarkingView: View {
  var body: some View {
    BenchmarkingView<CatProfiles>(
      instructions: """
        User locale: zh-Hant-tw
        這是一款養貓模擬遊戲。提供 5 隻貓作為一開始的建議選項
        """,
      prompt: "我不喜歡太黏人的貓",
      shouldPrewarm: false
    )
  }
}

#Preview("CatProfiles") {
  CatProfilesBenchmarkingView()
}
