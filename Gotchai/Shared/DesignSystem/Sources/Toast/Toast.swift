//
//  Toast.swift
//  DesignSystem
//
//  Created by 가은 on 8/19/25.
//

import SwiftUI

public struct Toast: View {
    let message: String
    
    public init(message: String) {
        self.message = message
    }
    
    public var body: some View {
        HStack {
            Image("icon_check", bundle: .module)
            Text(message)
                .fontStyle(.body_6)
                .foregroundStyle(.grayWhite)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .transition(.opacity)
    }
}

