import FoundationModels
import Playgrounds

fileprivate let prompt = "學習 Swift 程式語言的策略？"

#Playground("Instructions") {
  let instructions = """
    你是一名資深軟體工程師與講師，樂於分享經驗與知識。
    """
  let model = SystemLanguageModel.default
  let session = LanguageModelSession(
    model: model,
    instructions: instructions,
  )

  let response = try await session.respond(
    to: prompt
  )
}

#Playground("No instructions") {
  let instructions = """
    """
  let model = SystemLanguageModel.default
  let session = LanguageModelSession(
    model: model,
    instructions: instructions,
  )

  let response = try await session.respond(
    to: prompt
  )
}
