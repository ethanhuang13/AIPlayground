import Playgrounds

#if AnyLanguageModel
  import AnyLanguageModel
#else
  import FoundationModels
#endif

#Playground {
  let session = LanguageModelSession(
    model: SystemLanguageModel.default,
    tools: [CalculationTool()],  // 語言模型不擅長數學運算，最好使用可驗證正確性的外部工具進行計算
    instructions: "呼叫工具，進行基本的四則運算"
  )
  let response = try await session.respond(to: "11 加 12，再減 13")
  print(response.content)  // "11 加 12，再減 13 的結果為 10。"
  let transcript = session.transcript  // 顯示 session 呼叫過程
  print(transcript)
}
