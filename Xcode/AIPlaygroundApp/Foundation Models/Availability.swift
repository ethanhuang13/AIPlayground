// Modified from https://developer.apple.com/events/resources/code-along-205/
// 1.3: Handling model availability

import FoundationModels
import Playgrounds

#Playground("availability") {
  let model = SystemLanguageModel.default

  // The availability property provides detailed information on the model's state.
  switch model.availability {
  case .available:
    print("Foundation Models is available and ready to go!")

  case .unavailable(.deviceNotEligible):
    print("The model is not available on this device.")

  case .unavailable(.appleIntelligenceNotEnabled):
    print("Apple Intelligence is not enabled in Settings.")

  case .unavailable(.modelNotReady):
    print("The model is not ready yet. Please try again later.")

  case .unavailable(let other):
    print("The model is unavailable for an unknown reason.")
  }
}

#Playground("isAvailable") {
  let model = SystemLanguageModel.default

  print("The model is \(model.isAvailable ? "available" : "unavailable").")
}
