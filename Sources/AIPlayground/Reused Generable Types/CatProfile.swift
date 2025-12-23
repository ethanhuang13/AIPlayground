#if AnyLanguageModel
  import AnyLanguageModel
#else
  import FoundationModels
#endif

@Generable(description: "貓的基本資料")
struct CatProfile {
  @Guide(description: "中文名字")
  var name: String

  @Guide(description: "貓的年齡", .range(0...20))
  var age: Int

  @Guide(description: "性格")
  var personality: CatPersonality

  @Guide(description: "專長")
  var expertise: String
}
