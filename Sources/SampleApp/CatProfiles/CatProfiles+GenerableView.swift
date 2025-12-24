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
      // XXX: Workaround of an AnyLanguageModel's @Generable macro bug:
      // It generated `var [CatProfile]` instead of `var [CatProfile].PartiallyGenerated`
      ForEach(catProfiles.asPartiallyGenerated()) {
        catProfile in catProfile
      }
    }
  }
}

#Preview("CatProfiles") {
  BenchmarkingView<CatProfiles>(
    instructions: """
      User locale: zh-Hant-tw
      這是一款養貓模擬遊戲。生成多隻貓作為建議選項
      """,
    prompt: "我不喜歡太黏人的貓",
    shouldPrewarm: false
  )
}
