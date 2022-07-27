// swift-tools-version:5.6
import PackageDescription

let package = Package(
  name: "GlossButtonNode",
  platforms: [
    .iOS(.v13),
  ],
  products: [
    .library(name: "GlossButtonNode", targets: ["GlossButtonNode"]),
  ],
  dependencies: [
    .package(url: "https://github.com/FluidGroup/Texture.git", branch: "spm"),
    .package(url: "https://github.com/FluidGroup/TextureSwiftSupport.git", branch: "main"),
  ],
  targets: [
    .target(
      name: "GlossButtonNode",
      dependencies: [
        .product(name: "AsyncDisplayKit", package: "Texture"),
        .product(name: "TextureSwiftSupport", package: "TextureSwiftSupport")
      ],
      path: "GlossButtonNode"
    ),
  ],
  swiftLanguageVersions: [.v5]
)
