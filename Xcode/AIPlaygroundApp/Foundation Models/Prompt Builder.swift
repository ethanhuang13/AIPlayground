import FoundationModels
import Playgrounds

#Playground("Prompt Builder") {
  let instructions = """
    User locale: zh-Hant-tw
    這是一款養貓模擬遊戲。提供 5 隻貓作為一開始的建議選項
    """
  let session = LanguageModelSession(
    instructions: instructions
  )

  let previousCat: CatProfile? = CatProfile(
    name: "阿喵",
    age: 10,
    personality: .lazy,
    expertise: "睡覺"
  )

  let prompt = Prompt {
    "我不喜歡太黏人的貓。"
    if let previousCat {
      "參考之前選擇過的貓："
      previousCat
    }
  }

  let response = try await session.respond(
    to: prompt,
    generating: [CatProfile].self,
    options: GenerationOptions(sampling: .greedy)
  )
}
