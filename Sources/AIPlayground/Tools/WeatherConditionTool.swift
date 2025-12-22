import FoundationModels

@Generable
struct WeatherCondition {
  var temperature: Double
  var chanceOfRain: Double
  var humidity: Double
}

struct WeatherConditionTool: Tool {
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
