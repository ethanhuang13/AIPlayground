import FoundationModels
import Playgrounds

#Playground {
  let session = LanguageModelSession()
  let response = try await session.respond(to: "今天不太想上班，幫我想幾個跟老闆請假的理由，用幽默的方式表達")
}
