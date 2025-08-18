import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Gotchai",
    settings: .projectSettings,
    targets: [
        .target(
            name: "Gotchai",
            destinations: .iOS,
            product: .app,
            bundleId: "com.gotchai.Gotchai",
            infoPlist: .extendingDefault(with: [
                "META_KEY": "$(META_KEY)",
                "KAKAO_NATIVE_APP_KEY": "$(KAKAO_NATIVE_APP_KEY)",
                "BASE_SCHEME": "$(BASE_SCHEME)",
                "BASE_HOST": "$(BASE_HOST)",
                "UILaunchScreen": [
                    "UIImageName": "launch_logo",
                    "UIColorName": "launch_color"
                ],
                "NSPhotoLibraryAddUsageDescription": "배지를 사진 앨범에 저장하려고 합니다."
                "CFBundleShortVersionString": "$(MARKETING_VERSION)",
                "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)"
            ]),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: .file(path: .relativeToRoot("Gotchai/App/Gotchai.entitlements")),
            dependencies: [
                .project(target: "Onboarding", path: .relativeToRoot("Gotchai/Feature/Onboarding")),
                .project(target: "Profile", path: .relativeToRoot("Gotchai/Feature/Profile")),
                .project(target: "Main", path: .relativeToRoot("Gotchai/Feature/Main")),
                .project(target: "SignIn", path: .relativeToRoot("Gotchai/Feature/SignIn")),
                .project(target: "Setting", path: .relativeToRoot("Gotchai/Feature/Setting"))
            ]
        )
    ]
)
