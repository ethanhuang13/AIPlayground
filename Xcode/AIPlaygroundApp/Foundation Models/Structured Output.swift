import FoundationModels
import Playgrounds

@Generable
private struct Step {
  var number: Int
  var title: String
  var description: String
  var example: String
}

private let prompt = "學習 Swift 程式語言的策略？"

#Playground("Non-structured") {
  let instructions = """
    你是一名資深軟體工程師與講師，樂於分享經驗與知識。
    """
  let session = LanguageModelSession(
    instructions: instructions
  )

  let response = try await session.respond(
    to: prompt,
    options: GenerationOptions(sampling: .greedy)
  )
}

#Playground("Structured") {
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
