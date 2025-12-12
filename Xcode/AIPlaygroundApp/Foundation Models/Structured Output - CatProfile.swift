import FoundationModels
import Playgrounds

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

#Playground("Generate Cat Profiles") {
  let instructions = """
    User locale: zh-Hant-tw
    這是一款養貓模擬遊戲。提供 5 隻貓作為一開始的建議選項
    """
  let session = LanguageModelSession(
    instructions: instructions
  )

  let response = try await session.respond(
    to: "我不喜歡太黏人的貓", // user input
    generating: [CatProfile].self,
    options: GenerationOptions(sampling: .greedy)
  )
}
