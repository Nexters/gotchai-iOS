//
//  BadgeCardView.swift
//  Main
//
//  Created by koreamango on 8/17/25.
//

import SwiftUI
import DesignSystem

struct BadgeCardView: View {
    let badge: ResultBadge
    let badgeLinearBackground: [Gradient.Stop]
    let badgeRadialBackground: [Gradient.Stop]

    private let badgeAspect: CGFloat = 321.0 / 481.0

    var body: some View {
        let badgeCardColor = GradientHelper.getBadgeColors(for: badge.tier)

        return ZStack {
            Color(.gray_950)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                if let uiImage = badge.image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 213, height: 213)
                        .clipShape(Circle())
                }

                Text(
                    badge.correctCount == 7 ? "모두 맞춘 당신은" : "7개 중 \(badge.correctCount)개를 맞춘 당신은"
                )
                .fontStyle(.body_1)
                .foregroundStyle(Color(hex: badgeCardColor.subColor))
                .padding(.top, 26)
                Text(badge.badgeName)
                    .fontStyle(.title_3)
                    .foregroundStyle(Color(hex: badgeCardColor.titleColor))
                Text(badge.description)
                    .fontStyle(.body_4)
                    .foregroundStyle(Color(.gray_white).opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)
                Image(badgeCardColor.image, bundle: .module)
                    .padding(.top, 36)
            }
            .padding([.horizontal, .top], 34)
            .padding(.bottom, 27)
            .frame(maxWidth: .infinity, minHeight: 400)
            .aspectRatio(badgeAspect, contentMode: .fit)
            .gradientBackground(
                stops: badgeLinearBackground,
                startPoint: .topLeading,
                endPoint: .bottomTrailing,
                cornerRadius: 24,
                strokeColor: Color(.gray_white).opacity(0.2),
                backgroundOpacity: 0.2
            )
            .background(
                RadialGradient(
                    gradient: Gradient(stops: badgeRadialBackground),
                    center: .bottom,
                    startRadius: 0,
                    endRadius: 400
                ).opacity(0.2)
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

