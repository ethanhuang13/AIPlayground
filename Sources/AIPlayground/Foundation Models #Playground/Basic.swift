import Playgrounds

#if AnyLanguageModel
  import AnyLanguageModel
#else
  import FoundationModels
#endif

#Playground {
  let session = LanguageModelSession(model: SystemLanguageModel.default)
  let response = try await session.respond(to: "今天不太想上班，幫我想幾個跟老闆請假的理由，用幽默的方式表達")
  print(response)
}
