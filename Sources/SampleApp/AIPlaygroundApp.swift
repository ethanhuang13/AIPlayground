import FoundationModelsUI
import SwiftUI

#if AnyLanguageModel
  import AnyLanguageModel
#else
  import FoundationModels
#endif

@main
struct AIPlaygroundApp: App {
  var body: some Scene {
    WindowGroup {
      WeakSelfPodcastBenchmarkingView()
    }
  }
}
