// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
  productTypes: [
    "ComposableArchitecture": .framework,
    "Alamofire": .framework,
    "Moya": .framework,
    "CombineMoya": .framework,
    "KakaoSDKCommon": .framework,
    "KakaoSDKAuth": .framework,
    "KakaoSDKUser": .framework,
    "Kingfisher": .framework
  ]
)
#endif

let package = Package(
    name: "Gotchai",
    dependencies: [
      .package(url: "https://github.com/kakao/kakao-ios-sdk", from: "2.24.5"),
      .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.17.0"),
      .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.0")),
      .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMajor(from: "8.5.0"))
    ],
    targets: []
)
