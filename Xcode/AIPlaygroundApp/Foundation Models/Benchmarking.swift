import FoundationModels
import OSLog
import SwiftUI

@Observable
@MainActor
class BenchmarkingGenerator<G: Generable> {
  private(set) var response: [G.PartiallyGenerated] = []
  private var session: LanguageModelSession
  private var prewarmed: Bool
  private let logger = Logger(subsystem: "Benchmarking", category: "Generator")

  var beginDate: Date = .distantPast
  var firstTokenDate: Date = .distantPast
  var endDate: Date = .distantPast

  var isResponding: Bool {
    session.isResponding
  }

  var firstTokenDuration: TimeInterval {
    guard firstTokenDate > beginDate else { return 0 }
    return firstTokenDate.timeIntervalSince(beginDate)
  }

  var totalDuration: TimeInterval {
    guard endDate > beginDate else { return 0 }
    return endDate.timeIntervalSince(beginDate)
  }

  init(instructions: String, prewarm: Bool) {
    session = LanguageModelSession(
      model: SystemLanguageModel.default,
      instructions: instructions
    )

    self.prewarmed = prewarm
    if prewarm {
      session.prewarm()
    }

    logger.log("Init")
  }

  func generate(to prompt: Prompt, streaming: Bool) async throws {
    self.beginDate = Date()

    logger.log(
      "Begin \(streaming ? "streaming" : "one-shot") \((self.prewarmed ? "prewarmed" : "without prewarm"))"
    )

    if streaming {
      let stream = session.streamResponse(
        to: prompt,
        generating: [G].self,
        options: GenerationOptions(sampling: .greedy)
      )

      for try await partialResponse in stream {
        if self.response.isEmpty {
          self.firstTokenDate = Date()
          logger.log("First token in \(self.firstTokenDuration)")
        }

        self.response = partialResponse.content
      }

      self.endDate = Date()
      logger
        .log("End streaming in \(self.totalDuration)")
    } else {
      self.response =
        try await session
        .respond(
          to: prompt,
          generating: [G].self,
          options: GenerationOptions(sampling: .greedy)
        )
        .content
        .asPartiallyGenerated()

      self.endDate = Date()
      logger.log("End one-shot in \(self.totalDuration)")
    }
  }
}

struct BenchmarkingView<G: GenerableView>: View {
  private let instructions: String
  private let prompt: String
  @State private var generator: BenchmarkingGenerator<G>
  @State private var prewarm: Bool = false

  init(instructions: String, prompt: String, prewarm: Bool) {
    self.instructions = instructions
    self.prompt = prompt
    self.prewarm = prewarm
    self.generator = BenchmarkingGenerator(
      instructions: instructions,
      prewarm: prewarm
    )
  }

  func resetGenerator() {
    self.generator = BenchmarkingGenerator(
      instructions: instructions,
      prewarm: prewarm
    )
  }

  var body: some View {
    NavigationStack {
      List {
        Section {
          Label(
            title: { Text(instructions) },
            icon: { Image(systemName: "location.north.fill") }
          )
          Label(
            title: { Text(prompt) },
            icon: { Image(systemName: "hand.point.right") }
          )

          if generator.firstTokenDuration > 0 {
            Label(
              title: {
                Text("First token: \(generator.firstTokenDuration) seconds")
              },
              icon: {
                Image(systemName: "textformat.superscript")
              }
            )
          }

          if generator.totalDuration > 0 {
            Label(
              title: {
                Text("Total time: \(generator.totalDuration) seconds")
              },
              icon: {
                Image(systemName: "textformat.characters.arrow.left.and.right")
              }
            )
          }
        }

        Section {
          if generator.response.isEmpty {
            noContentView
          } else {
            list
          }
        }
      }
      .toolbar {
        ToolbarItemGroup(placement: .automatic) {
          resetButton
          oneShotButton
          streamButton
          prewarmToggle
        }
      }
      .onChange(of: prewarm) { _, _ in
        resetGenerator()
      }
    }
  }

  @ViewBuilder
  private var resetButton: some View {
    if generator.response.isEmpty == false && generator.isResponding == false {
      Button {
        resetGenerator()
      } label: {
        Image(systemName: "arrow.clockwise")
      }
    }
  }

  @ViewBuilder
  private var oneShotButton: some View {
    Button {
      resetGenerator()

      Task {
        try await generator.generate(
          to: Prompt { prompt },
          streaming: false
        )
      }
    } label: {
      Label("生成（單次）", systemImage: "1.circle")
    }
    .disabled(generator.isResponding)
  }

  @ViewBuilder
  private var streamButton: some View {
    Button {
      resetGenerator()

      Task {
        try await generator.generate(
          to: Prompt { prompt },
          streaming: true
        )
      }
    } label: {
      Label("生成（串流）", systemImage: "water.waves")
    }
    .disabled(generator.isResponding)
  }

  @ViewBuilder
  private var prewarmToggle: some View {
    Toggle(isOn: $prewarm) {
      Label("Prewarm", systemImage: "flame.fill")
    }
    .disabled(generator.isResponding)
  }

  @ViewBuilder
  private var noContentView: some View {
    if generator.isResponding {
      ProgressView()
    } else {
      prewarmToggle
      oneShotButton
      streamButton
    }
  }

  @ViewBuilder
  private var list: some View {
    ForEach(generator.response) { item in
      item
    }
  }
}

protocol GenerableView: Generable
where PartiallyGenerated: View & Identifiable {}

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

#Preview {
  BenchmarkingView<CatProfile>(
    instructions: """
      User locale: zh-Hant-tw
      這是一款養貓模擬遊戲。提供 5 隻貓作為一開始的建議選項
      """,
    prompt: "我不喜歡太黏人的貓",
    prewarm: true
  )
}
