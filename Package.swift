// swift-tools-version:4.0

import PackageDescription

let package = Package(
  name: "RxSwiftForms",
  products: [
    .library(name: "RxSwiftForms", targets: ["RxSwiftForms"]),
  ],
  dependencies: [
    .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "4.0.0")),
  ],
  targets: [
    .target(name: "RxSwiftForms", dependencies: ["RxSwift", "RxCocoa"]),
    .testTarget(name: "RxSwiftFormsTests", dependencies: ["RxSwiftForms"]),
  ]
)
