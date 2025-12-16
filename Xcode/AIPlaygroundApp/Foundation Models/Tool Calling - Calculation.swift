import FoundationModels
import Playgrounds

private struct CalculationTool: Tool {
  let name = "arithmeticCalculator"
  let description = "Perform basic arithmetic operations on two numbers"

  @Generable
  struct Arguments {
    let argument1: Double
    let argument2: Double
    let mathOperation: BasicMathOperation

    @Generable
    enum BasicMathOperation {
      case add, subtract, multiply, divide
    }
  }

  func call(arguments: Arguments) async throws -> some PromptRepresentable {
    switch arguments.mathOperation {
    case .add:
      arguments.argument1 + arguments.argument2
    case .subtract:
      arguments.argument1 - arguments.argument2
    case .multiply:
      arguments.argument1 * arguments.argument2
    case .divide:
      arguments.argument1 / arguments.argument2
    }
    // 此範例省略除以 0 或溢位等錯誤處理
  }
}

#Playground {
  let session = LanguageModelSession(
    tools: [CalculationTool()],  // 語言模型不擅長數學運算，最好使用可驗證正確性的外部工具進行計算
    instructions: "呼叫工具，進行基本的四則運算"
  )
  let response = try await session.respond(to: "11 加 12，再減 13")
  print(response.content)  // 11 加 12 再減 13 的結果是 10。
  let transcript = session.transcript  // 顯示 session 呼叫過程
}
