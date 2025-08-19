import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "TuringTestDemoApp",
    settings: .projectSettings,
    targets: [
        .target(
            name: "TuringTestDemoApp",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.gotchai.turingtestdemoapp",
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Main", path: .relativeToRoot("Gotchai/Feature/Main")),
            ]
        )
    ]
)
