import FoundationModels
import Playgrounds

#Playground("Generate Cat Profiles") {
  let instructions = """
    User locale: zh-Hant-tw
    這是一款養貓模擬遊戲。提供 5 隻貓作為一開始的建議選項
    """
  let session = LanguageModelSession(
    model: SystemLanguageModel.default,
    instructions: instructions
  )

  let response = try await session.respond(
    to: "我不喜歡太黏人的貓",  // user input
    generating: [CatProfile].self,
    options: GenerationOptions(sampling: .greedy)
  )
  print(response)
}
