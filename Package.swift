// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let osVersion = "26.1"

// MARK: - Third party dependencies

let anyLanguageModel = SourceControlDependency(
  package: .package(
    url: "https://github.com/mattt/AnyLanguageModel",
    exact: "0.5.2"
  ),
  productName: "AnyLanguageModel"
)

// MARK: - Modules. Ordered by dependency hierarchy.

let foundationModelsUI = SingleTargetLibrary(
  name: "FoundationModelsUI"
)

let app = SingleTargetLibrary(
  name: "AIPlayground",
  dependencies: [
    foundationModelsUI.targetDependency,
//    anyLanguageModel.targetDependency,
  ]
)

let package = Package(
  name: "AIPlayground",
  platforms: [.macOS(osVersion), .iOS(osVersion)],
  products: [
    foundationModelsUI.product,
    app.product,
  ],
  dependencies: [
    //    anyLanguageModel.package
  ],
  targets: [
    foundationModelsUI.target,
    app.target
  ]
)

// MARK: - Helpers

/// Third party dependencies.
struct SourceControlDependency {
  var package: Package.Dependency
  var productName: String

  init(package: Package.Dependency, productName: String) {
    self.package = package
    self.productName = productName
  }

  var targetDependency: Target.Dependency {
    var packageName: String

    switch package.kind {
    case .fileSystem(let name, let path):
      guard let name = name ?? URL(string: path)?.lastPathComponent else {
        fatalError("No package name found. Path: \(path)")
      }
      packageName = name
    case .sourceControl(let name, let location, _):
      guard let name = name ?? URL(string: location)?.lastPathComponent else {
        fatalError("No package name found. Location: \(location)")
      }
      packageName = name
    default:
      fatalError("Unsupported dependency kind: \(package.kind)")
    }

    return .product(
      name: productName,
      package: packageName,
      moduleAliases: nil,
      condition: nil
    )
  }
}

/// Local modules.
@MainActor
struct SingleTargetLibrary {
  var name: String
  var dependencies: [Target.Dependency] = []

  var product: Product {
    .library(name: name, targets: [name])
  }

  var target: Target {
    .target(name: name, dependencies: dependencies)
  }

  var targetDependency: Target.Dependency {
    .target(name: name)
  }

  var testTarget: Target {
    .testTarget(
      name: name + "Tests",
      dependencies: [targetDependency]
    )
  }
}
