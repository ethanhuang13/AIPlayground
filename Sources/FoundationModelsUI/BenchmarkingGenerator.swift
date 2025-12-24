import OSLog
import SwiftUI

#if AnyLanguageModel
  import AnyLanguageModel
#else
  import FoundationModels
#endif

private let logger = Logger(
  subsystem: "FoundationModelsUI",
  category: "BenchmarkingGenerator"
)

@Observable
@MainActor
public class BenchmarkingGenerator<G: Generable> {
  private(set) var response: G.PartiallyGenerated?
  private var session: LanguageModelSession
  private var shouldPrewarm: Bool

  private(set) var beginDate: Date = .distantPast
  private(set) var firstResponseDate: Date = .distantPast
  private(set) var endDate: Date = .distantPast

  public var isResponding: Bool {
    session.isResponding
  }

  public var firstResponseDuration: TimeInterval {
    guard firstResponseDate > beginDate else { return 0 }
    return firstResponseDate.timeIntervalSince(beginDate)
  }

  public var totalDuration: TimeInterval {
    guard endDate > beginDate else { return 0 }
    return endDate.timeIntervalSince(beginDate)
  }

  public init(
    model: any LanguageModel,
    instructions: String,
    shouldPrewarm: Bool
  ) {
    session = LanguageModelSession(
      model: model,
      instructions: instructions
    )

    self.shouldPrewarm = shouldPrewarm
    if shouldPrewarm {
      session.prewarm()
    }

    logger.log("Init")
  }

  public func generate(to prompt: Prompt, streaming: Bool) async throws {
    self.beginDate = Date()

    logger.log(
      "Begin \(streaming ? "streaming" : "one-shot") \((self.shouldPrewarm ? "prewarmed" : "without prewarm"))"
    )

    if streaming {
      let stream = session.streamResponse(
        to: prompt,
        generating: G.self,
        options: GenerationOptions(sampling: .greedy)
      )

      var isFirstResponse = true
      for try await partialResponse in stream {
        if isFirstResponse {
          isFirstResponse = false
          self.firstResponseDate = Date()
          logger.log("First response in \(self.firstResponseDuration)")
        }

        self.response = partialResponse.content
      }

      self.endDate = Date()
      logger.log("Finish streaming in \(self.totalDuration)")
    } else {
      self.response =
        try await session
        .respond(
          to: prompt,
          generating: G.self,
          options: GenerationOptions(sampling: .greedy)
        )
        .content
        .asPartiallyGenerated()

      self.endDate = Date()
      logger.log("Finish one-shot in \(self.totalDuration)")
    }
  }
}
