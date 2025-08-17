//
//  View.swift
//  Common
//
//  Created by koreamango on 8/17/25.
//

import SwiftUI

@available(iOS 16.0, *)
extension View {
    public func snapshot() -> UIImage? {
        let renderer = ImageRenderer(content: self)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage
    }
}
