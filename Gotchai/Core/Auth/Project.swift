import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Auth",
    settings: .projectSettings,
    targets: [
        .target(
            name: "Auth",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.gotchai.auth",
            infoPlist: "Info.plist",
            sources: ["Sources/**"],
            entitlements: "../../App/Gotchai.entitlements",
            dependencies: [
                .external(name: "KakaoSDKCommon"),
                .external(name: "KakaoSDKAuth"),
                .external(name: "KakaoSDKUser"),
                .project(target: "TCA", path: .relativeToRoot("Gotchai/Core/Third/TCA")),
                .project(target: "CustomNetwork", path: .relativeToRoot("Gotchai/Core/CustomNetwork")),
                .project(target: "Common", path: .relativeToRoot("Gotchai/Core/Common")),
            ]
        )
    ]
)
