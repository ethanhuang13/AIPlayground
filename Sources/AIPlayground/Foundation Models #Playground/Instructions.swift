import Playgrounds

#if AnyLanguageModel
  import AnyLanguageModel
#else
  import FoundationModels
#endif

private let prompt = "學習 Swift 程式語言的策略？"

#Playground("No instructions") {
  let session = LanguageModelSession(model: SystemLanguageModel.default)

  let response = try await session.respond(to: prompt)
  print(response)
}

#Playground("Instructions") {
  let instructions = """
    你是一名資深軟體工程師與講師，樂於分享經驗與知識。
    """
  let session = LanguageModelSession(
    model: SystemLanguageModel.default,
    instructions: instructions
  )

  let response = try await session.respond(to: prompt)
  print(response)
}
