import FoundationModels
import Playgrounds

#Playground {
  let session = LanguageModelSession(
    model: SystemLanguageModel.default,
    tools: [WeatherConditionTool()],  // 模型會根據語意來判斷需要天氣資料，而自動呼叫工具
    instructions: "描述當地天氣資訊"
  )
  let response = try await session.respond(to: "全糖市")
  print(response.content)  // "目前全糖市的氣溫是16度，有30%的機會會下雨，濕度是70%。"
  let transcript = session.transcript  // 顯示 session 呼叫過程
  print(transcript)
}
