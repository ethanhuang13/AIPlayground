import FoundationModels

struct CalculationTool: Tool {
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
