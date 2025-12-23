import SwiftUI

#if AnyLanguageModel
  import AnyLanguageModel
#else
  import FoundationModels
#endif

public protocol GenerableView: Generable where PartiallyGenerated: View {}
