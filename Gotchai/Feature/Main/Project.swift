import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Main",
    settings: .projectSettings,
    targets: [
        .target(
            name: "Main",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.gotchai.main",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "TCA", path: .relativeToRoot("Gotchai/Core/Third/TCA")),
                .project(target: "DesignSystem", path: "../../Shared/DesignSystem"),
                .project(target: "Profile", path: .relativeToRoot("Gotchai/Feature/Profile")),
                .project(target: "CustomNetwork", path: .relativeToRoot("Gotchai/Core/CustomNetwork")),
                .external(name: "Kingfisher")
            ]
        )
    ]
)
