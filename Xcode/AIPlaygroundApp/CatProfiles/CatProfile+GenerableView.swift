import FoundationModelsUI
import SwiftUI

#if AnyLanguageModel
  import AnyLanguageModel
#else
  import FoundationModels
#endif

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
