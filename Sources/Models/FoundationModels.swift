import FoundationModels
import Playgrounds

// MARK: - 定義 Capability 類型（對應官方文件）

@Generable(description: "Foundation Models capability category")
enum CapabilityCategory: String, CaseIterable {
  case summarize = "Summarize"
  case extractEntities = "Extract entities"
  case understandText = "Understand text"
  case refineText = "Refine or edit text"
  case classifyText = "Classify or judge text"
  case creativeWriting = "Compose creative writing"
  case generateTags = "Generate tags from text"
  case gameDialog = "Generate game dialog"
}

// MARK: - 單一 Prompt 範例

@Generable(
  description: "A demo prompt showcasing a Foundation Models capability"
)
struct CapabilityDemo {
  @Guide(description: "The capability category this prompt demonstrates")
  var category: CapabilityCategory

  @Guide(
    description:
      "A specific prompt that demonstrates this capability, 10-50 words"
  )
  var prompt: String

  @Guide(description: "Expected output format or behavior, 5-20 words")
  var expectedOutput: String

  @Guide(
    description: "Potential iOS app use case for this capability, 10-30 words"
  )
  var appUseCase: String
}

// MARK: - Prompt 集合

@Generable(description: "Collection of capability demonstrations")
struct CapabilityDemoCollection {
  @Guide(
    description: "List of capability demos covering different categories",
    .count(8)
  )
  var demos: [CapabilityDemo]
}

// MARK: - Playground 測試

#Playground("Generate Capability Demos") {
  let session = LanguageModelSession(
    instructions: """
      Generate diverse prompt examples for each Foundation Models capability.
      Focus on practical iOS app scenarios.
      Each prompt should be distinct and demonstrate the capability clearly.
      Cover all 8 capability categories.
      """
  )

  let response = try await session.respond(
    to:
      "Generate one demo prompt for each capability category, focusing on realistic iOS app use cases.",
    generating: CapabilityDemoCollection.self
  )

  let newSession = LanguageModelSession(model: SystemLanguageModel.default)

  for demo in response.content.demos {
    print("[\(demo.category.rawValue)]")
    print("Prompt: \(demo.prompt)")
    print("Expected: \(demo.expectedOutput)")
    print("App Use: \(demo.appUseCase)")
    print("---")

    let newResponse = try await newSession.respond(to: demo.prompt)
  }
}
