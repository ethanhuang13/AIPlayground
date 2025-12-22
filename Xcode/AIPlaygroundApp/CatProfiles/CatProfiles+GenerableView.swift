import FoundationModels
import FoundationModelsUI
import SwiftUI

@Generable
struct CatProfiles {
  @Guide(description: "貓", .count(5))
  var catProfiles: [CatProfile]
}

extension CatProfiles: GenerableView {}

extension CatProfiles.PartiallyGenerated: View {
  var body: some View {
    if let catProfiles {
      ForEach(catProfiles) {
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
