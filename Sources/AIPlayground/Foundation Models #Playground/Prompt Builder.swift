import Playgrounds

#if AnyLanguageModel
  import AnyLanguageModel
#else
  import FoundationModels
#endif

#Playground("Prompt Builder") {
  let instructions = """
    User locale: zh-Hant-tw
    這是一款養貓模擬遊戲。提供 5 隻貓作為一開始的建議選項
    """
  let session = LanguageModelSession(
    model: SystemLanguageModel.default,
    instructions: instructions
  )

  let previousCat: CatProfile? = CatProfile(
    name: "阿喵",
    age: 10,
    personality: CatPersonality.lazy,
    expertise: "睡覺"
  )

  let prompt = Prompt {
    "我不喜歡太黏人的貓。"
    if let previousCat {
      "以下是使用者之前的貓，首先建議相同的性格與專長，但是換個名字與較小的年齡："
      previousCat
    }
  }

  let response = try await session.respond(
    to: prompt,
    generating: [CatProfile].self,
    options: GenerationOptions(sampling: .greedy)
  )
  print(response)
}
