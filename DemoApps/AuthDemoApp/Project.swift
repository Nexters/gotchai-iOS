import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "AuthDemoApp",
    settings: .projectSettings,
    targets: [
        .target(
            name: "AuthDemoApp",
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.gotchai.authdemoapp",
            infoPlist: .extendingDefault(with: [
                "UILaunchStoryboardName": "Launch Screen"
            ]),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: .file(path: .relativeToRoot("DemoApps/AuthDemoApp/AuthDemoApp.entitlements")),
            dependencies: [
                .project(target: "Onboarding", path: .relativeToRoot("Gotchai/Feature/Onboarding")),
                .project(target: "Profile", path: .relativeToRoot("Gotchai/Feature/Profile")),
                .project(target: "Main", path: .relativeToRoot("Gotchai/Feature/Main")),
                .project(target: "SignIn", path: .relativeToRoot("Gotchai/Feature/SignIn"))
            ]
        )
    ]
)

