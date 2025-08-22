//
//  Settings+Extension.swift
//  Tuist
//
//  Created by 가은 on 7/30/25.
//

import ProjectDescription

public extension Settings {
    static var projectSettings: Self {
        return .settings(
            base: [
                "IPHONEOS_DEPLOYMENT_TARGET": "17.0",
                "DEVELOPMENT_TEAM": "$(DEVELOPMENT_TEAM)",
                
                // version
                "MARKETING_VERSION": "1.0.1",
                "CURRENT_PROJECT_VERSION": "9"
            ],
            configurations: [
                .debug(name: "Debug", xcconfig: .relativeToRoot("Tuist/Configurations/Debug.xcconfig")),
                .release(name: "Release", xcconfig: .relativeToRoot("Tuist/Configurations/Release.xcconfig"))
            ]
        )
    }
}
