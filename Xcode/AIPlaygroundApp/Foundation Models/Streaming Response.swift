import FoundationModels
import SwiftUI

@Observable
@MainActor
private class CatProfileGenerator {
  private var session: LanguageModelSession
  private(set) var catProfiles: [CatProfile.PartiallyGenerated] = []

  var isResponding: Bool {
    session.isResponding
  }

  init() {
    session = LanguageModelSession(
      model: SystemLanguageModel.default,
      instructions: """
        User locale: zh-Hant-tw
        這是一款養貓模擬遊戲。提供 5 隻貓作為一開始的建議選項
        """
    )
  }

  func generate() {
    Task {
      let stream = session.streamResponse(
        to: "我不喜歡太黏人的貓",  // user input
        generating: [CatProfile].self,
        options: GenerationOptions(sampling: .greedy)
      )

      for try await partialResponse in stream {
        self.catProfiles = partialResponse.content
      }
    }
  }
}

private struct CatSelectionView: View {
  @State private var generator = CatProfileGenerator()

  var body: some View {
    VStack {
      if generator.catProfiles.isEmpty {
        Label("你想要怎樣的貓呢？", systemImage: "cat.fill")
        if generator.isResponding {
          ProgressView()
        } else {
          Button {
            generator.generate()
          } label: {
            Label("隨機推薦", systemImage: "sparkles")
          }
          .buttonStyle(.glass)
        }
      } else {
        List {
          // partialGenerated 自動提供 id 屬性，方便給 SwiftUI 的 ForEach 使用
          ForEach(generator.catProfiles) { profile in
            if let name = profile.name {
              VStack(alignment: .leading) {
                HStack {
                  Text(name)
                    .font(.title)
                  if let age = profile.age {
                    Text("\(age) 歲")
                  }
                }
                if let personality = profile.personality {
                  Text("性格：\(personality.rawValue)")
                }
                if let expertise = profile.expertise {
                  Text("專長：\(expertise)")
                }
              }
            }
          }
        }
      }
    }
  }
}

#Preview {
  CatSelectionView()
}
