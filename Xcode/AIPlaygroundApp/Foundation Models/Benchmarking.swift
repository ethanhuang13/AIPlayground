import FoundationModels
import OSLog
import SwiftUI

private let logger = Logger(
  subsystem: "Foundation Models AIPlayground",
  category: "Benchmarking"
)

@Observable
@MainActor
class BenchmarkingGenerator<G: Generable> {
  private(set) var response: G.PartiallyGenerated?
  private var session: LanguageModelSession
  private var shouldPrewarm: Bool

  var beginDate: Date = .distantPast
  var firstResponseDate: Date = .distantPast
  var endDate: Date = .distantPast

  var isResponding: Bool {
    session.isResponding
  }

  var firstResponseDuration: TimeInterval {
    guard firstResponseDate > beginDate else { return 0 }
    return firstResponseDate.timeIntervalSince(beginDate)
  }

  var totalDuration: TimeInterval {
    guard endDate > beginDate else { return 0 }
    return endDate.timeIntervalSince(beginDate)
  }

  init(instructions: String, shouldPrewarm: Bool) {
    session = LanguageModelSession(
      model: SystemLanguageModel.default,
      instructions: instructions
    )

    self.shouldPrewarm = shouldPrewarm
    if shouldPrewarm {
      session.prewarm()
    }

    logger.log("Init")
  }

  func generate(to prompt: Prompt, streaming: Bool) async throws {
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

protocol GenerableView: Generable where PartiallyGenerated: View {}

struct BenchmarkingView<G: GenerableView>: View {
  private let instructions: String
  private let prompt: String
  @State private var generator: BenchmarkingGenerator<G>
  @State private var shouldPrewarm: Bool = false

  init(instructions: String, prompt: String, shouldPrewarm: Bool) {
    self.instructions = instructions
    self.prompt = prompt
    _shouldPrewarm = State(initialValue: shouldPrewarm)
    _generator = State(
      initialValue: BenchmarkingGenerator(
        instructions: instructions,
        shouldPrewarm: shouldPrewarm
      )
    )
  }

  func resetGenerator() {
    self.generator = BenchmarkingGenerator(
      instructions: instructions,
      shouldPrewarm: shouldPrewarm
    )
  }

  var body: some View {
    NavigationStack {
      List {
        Section {
          instructionsView
          promptView
          if generator.firstResponseDuration > 0 {
            firstResponseDurationView
          }
          if generator.totalDuration > 0 {
            totalDurationView
          }
          if generator.response != nil
            && generator.isResponding == false
          {
            resetButton
          }
        }

        Section {
          if let generatedContentView = generator.response {
            generatedContentView
          } else {
            noContentView
          }
        }
      }
      .onChange(of: shouldPrewarm) { _, _ in
        resetGenerator()
      }
    }
  }

  @ViewBuilder
  private var instructionsView: some View {
    Label(
      title: { Text(instructions) },
      icon: { Image(systemName: "location.north.fill") }
    )
  }

  @ViewBuilder
  private var promptView: some View {
    Label(
      title: { Text(prompt) },
      icon: { Image(systemName: "hand.point.right") }
    )
  }

  @ViewBuilder
  private var firstResponseDurationView: some View {
    Label(
      title: {
        Text(
          "First response: \(generator.firstResponseDuration, format: .number.precision(.fractionLength(3))) seconds"
        )
      },
      icon: {
        Image(systemName: "textformat.superscript")
      }
    )
  }

  @ViewBuilder
  private var totalDurationView: some View {
    Label(
      title: {
        Text(
          "Total time: \(generator.totalDuration, format: .number.precision(.fractionLength(3))) seconds"
        )
      },
      icon: {
        Image(systemName: "textformat.characters.arrow.left.and.right")
      }
    )
  }

  @ViewBuilder
  private var resetButton: some View {
    Button {
      resetGenerator()
    } label: {
      Label("Reset", systemImage: "arrow.clockwise")
    }
  }

  @ViewBuilder
  private var noContentView: some View {
    if generator.isResponding {
      ProgressView()
        .progressViewStyle(.circular)
    } else {
      prewarmToggle
      oneShotButton
      streamButton
    }
  }

  @ViewBuilder
  private var prewarmToggle: some View {
    Toggle(isOn: $shouldPrewarm) {
      Label("Prewarm", systemImage: "flame.fill")
    }
    .disabled(generator.isResponding)
  }

  @ViewBuilder
  private var oneShotButton: some View {
    Button {
      Task {
        do {
          try await generator.generate(
            to: Prompt { prompt },
            streaming: false
          )
        } catch {
          logger.error("\(error)")
          // TODO: Show error messages on UI
        }
      }
    } label: {
      Label("One-shot", systemImage: "1.circle")
    }
    .disabled(generator.isResponding)
  }

  @ViewBuilder
  private var streamButton: some View {
    Button {
      Task {
        do {
          try await generator.generate(
            to: Prompt { prompt },
            streaming: true
          )
        } catch {
          logger.error("\(error)")
          // TODO: Show error messages on UI
        }
      }
    } label: {
      Label("Stream Response", systemImage: "water.waves")
    }
    .disabled(generator.isResponding)
  }
}

extension CatProfile: GenerableView {}
extension CatProfile.PartiallyGenerated: View {
  var body: some View {
    if let name = self.name {
      VStack(alignment: .leading) {
        HStack {
          Text(name)
            .font(.title)
          if let age = self.age {
            Text("\(age) 歲")
          }
        }
        if let personality = self.personality {
          Text("性格：\(personality.rawValue)")
        }
        if let expertise = self.expertise {
          Text("專長：\(expertise)")
        }
      }
    }
  }
}

#Preview("CatProfile") {
  BenchmarkingView<CatProfile>(
    instructions: """
      User locale: zh-Hant-tw
      這是一款養貓模擬遊戲。生成一隻貓作為建議選項
      """,
    prompt: "我不喜歡太黏人的貓",
    shouldPrewarm: false
  )
}

@Generable
struct CatProfiles: GenerableView {
  @Guide(description: "貓", .count(5))
  var catProfiles: [CatProfile]
}

extension CatProfiles.PartiallyGenerated: View {
  var body: some View {
    if let catProfiles {
      ForEach(catProfiles) { catProfile in
        catProfile
      }
    }
  }
}

#Preview("CatProfiles") {
  BenchmarkingView<CatProfiles>(
    instructions: """
      User locale: zh-Hant-tw
      這是一款養貓模擬遊戲。生成多隻貓作為建議選項
      """,
    prompt: "我不喜歡太黏人的貓",
    shouldPrewarm: false
  )
}
