import FoundationModelsUI
import MLXLLM
import SwiftUI

#if AnyLanguageModel
  import AnyLanguageModel
#else
  import FoundationModels
#endif

struct MLXView: View {
  var body: some View {
    // LLMRegistry from MLXLLM library list many available models on Hugging Face.
    // We can use their name as modelId to initialize MLXLanguageModel
    // Cmd + click `LLMRegistry` to see the list
    let llm = LLMRegistry
      .qwen205b4bit
    //      .llama3_2_1B_4bit
    //      .gemma3_1B_qat_4bit
    //      .qwen2_5_1_5b

    let modelId = llm.name
    let defaultPrompt = llm.defaultPrompt

    let mlxModel = MLXLanguageModel(
      modelId: modelId,
      hub: nil,  // Hugging Face API client
      directory: nil
      // The model will be downloaded automatically
      // By default, MLXLMCommon's `ModelFactory` download the model files to:
      // Mac app: ~/Library/Containers/<bundle-id>/Data/Library/Caches/models/
      // iOS app: <App Container>/Library/Caches/models/
      // HubApi(downloadBase: FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first)
    )

    BenchmarkingView<String>(
      modelName: modelId,
      model: mlxModel,
      instructions: "",
      prompt: defaultPrompt
    )
  }
}

#Preview {
  MLXView()
}
