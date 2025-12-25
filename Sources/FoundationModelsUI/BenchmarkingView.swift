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
  private let modelName: String?
  private let model: any LanguageModel
  private let instructions: String
  private let prompt: String
  @State private var generator: BenchmarkingGenerator<G>
  @State private var shouldPrewarm: Bool = false
  @State private var errorMessage: String? = nil

  public init(
    modelName: String? = nil,
    model: any LanguageModel = SystemLanguageModel.default,
    instructions: String,
    prompt: String,
    shouldPrewarm: Bool = false
  ) {
    self.modelName = modelName
    self.model = model
    self.instructions = instructions
    self.prompt = prompt

    let shouldPrewarm =
      (model is SystemLanguageModel)
      ? shouldPrewarm
      : false

    _generator = State(
      initialValue: BenchmarkingGenerator(
        model: model,
        instructions: instructions,
        shouldPrewarm: shouldPrewarm
      )
    )
  }

  func resetGenerator() {
    errorMessage = nil
    self.generator = BenchmarkingGenerator(
      model: model,
      instructions: instructions,
      shouldPrewarm: shouldPrewarm
    )
  }

  public var body: some View {
    NavigationStack {
      List {
        Section {
          modelNameView
          instructionsView
          promptView
          errorMessageView
          firstResponseDurationView
          totalDurationView
          resetButton
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
  private var modelNameView: some View {
    if let modelName {
      Label(modelName, systemImage: "textformat")
        .textSelection(.enabled)
    }
  }

  @ViewBuilder
  private var instructionsView: some View {
    Label(instructions, systemImage: "location.north.fill")
      .textSelection(.enabled)
  }

  @ViewBuilder
  private var promptView: some View {
    Label(prompt, systemImage: "hand.point.right")
      .textSelection(.enabled)
  }

  @ViewBuilder
  private var errorMessageView: some View {
    if let errorMessage {
      Label {
        Text(errorMessage)
          .textSelection(.enabled)
      } icon: {
        Image(systemName: "xmark.octagon.fill")
      }
    }
  }

  @ViewBuilder
  private var firstResponseDurationView: some View {
    if generator.firstResponseDuration > 0 {
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
  }

  @ViewBuilder
  private var totalDurationView: some View {
    if generator.totalDuration > 0 {
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
  }

  @ViewBuilder
  private var resetButton: some View {
    if generator.response != nil
      && generator.isResponding == false
    {
      Button {
        resetGenerator()
      } label: {
        Label("Reset", systemImage: "arrow.clockwise")
      }
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
    .disabled((model is SystemLanguageModel) == false)
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
