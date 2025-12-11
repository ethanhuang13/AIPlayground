import FoundationModels
import Playgrounds

@Generable
private struct Step {
  @Guide(description: "標題")
  var title: String
  @Guide(description: "描述")
  var description: String
  @Guide(description: "步驟順序")
  var number: Int
}

private let prompt = "學習 Swift 程式語言的策略？"

#Playground("Generate steps") {
  let instructions = """
    你是一名資深軟體工程師與講師，樂於分享經驗與知識。
    """
  let session = LanguageModelSession(
    instructions: instructions
  )

  let response = try await session.respond(
    to: prompt,
    generating: [Step].self,
    options: GenerationOptions(sampling: .greedy)
  )
}
