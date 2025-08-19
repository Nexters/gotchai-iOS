//
//  BadgeCardView.swift
//  Main
//
//  Created by koreamango on 8/17/25.
//

import SwiftUI
import DesignSystem

struct BadgeCardView: View {
    let badge: ResultBadge?
    let badgeLinearBackground: [Gradient.Stop]
    let badgeRadialBackground: [Gradient.Stop]

    var body: some View {
        
        Group {
            if let badge = badge {
                let badgeCardColor = GradientHelper.getBadgeColors(for: badge.tier)
                
                badgeCard(badge: badge, colors: badgeCardColor)
                
            } else {
                VStack {
                    ProgressView().frame(maxHeight: .infinity)
                }
            }
        }
        .padding([.horizontal, .top], 34)
        .padding(.bottom, 27)
        .frame(maxWidth: .infinity, minHeight: 481)
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
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
    
    
    @ViewBuilder
    private func badgeCard(badge: ResultBadge, colors: BadgeColor) -> some View {
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
            .foregroundStyle(Color(hex: colors.subColor))
            .padding(.top, 26)
            
            Text(badge.badgeName)
                .fontStyle(.title_3)
                .foregroundStyle(Color(hex: colors.titleColor))
            
            Text(badge.description)
                .fontStyle(.body_4)
                .foregroundStyle(Color(.gray_white).opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.top, 16)
            
            Image(colors.image, bundle: .module)
                .padding(.top, 36)
        }
    }
}
