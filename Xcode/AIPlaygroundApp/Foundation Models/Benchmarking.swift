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

  var isResponding: Bool {
    session.isResponding
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
    let begin = Date()
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
          logger.log("First token in \(Date().timeIntervalSince(begin))")
        }

        self.response = partialResponse.content
      }

      logger.log("End streaming in \(Date().timeIntervalSince(begin))")
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

      logger.log("End one-shot in \(Date().timeIntervalSince(begin))")
    }
  }
}

struct BenchmarkingView<G: GenerableView>: View {
  private let instructions: String
  private let prompt: Prompt
  @State private var generator: BenchmarkingGenerator<G>
  @State private var prewarm: Bool = false

  init(instructions: String, prompt: Prompt, prewarm: Bool) {
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
        if generator.response.isEmpty {
          noContentView
        } else {
          list
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
          to: prompt,
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
          to: prompt,
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
where PartiallyGenerated: View & Identifiable {
  associatedtype PartiallyGenerated
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

#Preview {
  BenchmarkingView<CatProfile>(
    instructions: """
      User locale: zh-Hant-tw
      這是一款養貓模擬遊戲。提供 5 隻貓作為一開始的建議選項
      """,
    prompt: Prompt { "我不喜歡太黏人的貓" },
    prewarm: true
  )
}
