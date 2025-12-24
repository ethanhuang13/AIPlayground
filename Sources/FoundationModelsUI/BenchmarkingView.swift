import OSLog
import SwiftUI

#if AnyLanguageModel
  import AnyLanguageModel
#else
  import FoundationModels
#endif

private let logger = Logger(
  subsystem: "FoundationModelsUI",
  category: "BenchmarkingView"
)

public struct BenchmarkingView<G: GenerableView>: View {
  private let instructions: String
  private let prompt: String
  @State private var generator: BenchmarkingGenerator<G>
  @State private var shouldPrewarm: Bool = false
  @State private var errorMessage: String? = nil

  public init(instructions: String, prompt: String, shouldPrewarm: Bool) {
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
    errorMessage = nil
    self.generator = BenchmarkingGenerator(
      instructions: instructions,
      shouldPrewarm: shouldPrewarm
    )
  }

  public var body: some View {
    NavigationStack {
      List {
        Section {
          instructionsView
          promptView
          if let errorMessage {
            Label {
              Text(errorMessage)
            } icon: {
              Image(systemName: "xmark.octagon.fill")
            }
          }
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
          errorMessage = "\(error)"
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
          errorMessage = "\(error)"
        }
      }
    } label: {
      Label("Stream Response", systemImage: "water.waves")
    }
    .disabled(generator.isResponding)
  }
}
