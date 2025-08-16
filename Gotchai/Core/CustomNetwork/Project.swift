import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "CustomNetwork",
    settings: .projectSettings,
    targets: [
        .target(
            name: "CustomNetwork",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.gotchai.customNetwork",
            sources: ["Sources/**"],
            dependencies: [
                .external(name: "Moya"),
                .external(name: "CombineMoya"),
                .project(target: "Common", path: .relativeToRoot("Gotchai/Core/Common")),
                .project(target: "TCA", path: .relativeToRoot("Gotchai/Core/Third/TCA")),
            ]
        )
    ]
)

