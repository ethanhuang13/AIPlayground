import FoundationModels
import Playgrounds

@Generable
private struct WeatherCondition {
  var temperature: Double
  var chanceOfRain: Double
  var humidity: Double
}

private struct WeatherConditionTool: Tool {
  let name = "weatherCondition"
  let description = "Get current weather conditions for a location"

  @Generable
  struct Arguments {
    let locationName: String
  }

  func call(arguments: Arguments) async throws -> some PromptRepresentable {
    // 示範用的假資料。實際上這裡可能會呼叫外部 API
    let weatherCondition = WeatherCondition(
      temperature: 16,
      chanceOfRain: 0.3,
      humidity: 0.7,
    )
    return weatherCondition
  }
}

#Playground {
  let session = LanguageModelSession(
    tools: [WeatherConditionTool()],  // 模型會根據語意來判斷需要天氣資料，而自動呼叫工具
    instructions: "描述當地天氣資訊"
  )
  let response = try await session.respond(to: "全糖市")
  print(response.content) // "目前全糖市的氣溫是16度，有30%的機會會下雨，濕度是70%。"
  let transcript = session.transcript  // 顯示 session 呼叫過程
}
