import FoundationModels

@Generable(description: "貓的性格")
enum CatPersonality: String {
  case independent = "獨立"
  case curious = "好奇"
  case playful = "愛玩"
  case mischievous = "調皮"
  case clingy = "黏人"
  case unpredictable = "無法預測"
  case lazy = "懶惰"
}
