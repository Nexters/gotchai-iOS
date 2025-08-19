//
//  GradientHelper.swift
//  Main
//
//  Created by 가은 on 8/12/25.
//

import SwiftUI

enum GradientTheme: String {
    case gold = "GOLD"
    case silver = "SILVER"
    case bronze = "BRONZE"
}

struct ColorPalette {
    let mainBackground: [String]
    let naviBackground: [String]
    let badgeLinearBackground: [String]
    let badgeRadialBackground: [String]
}

struct AllGradientStops {
    let mainBackground: [Gradient.Stop]
    let naviBackground: [Gradient.Stop]
    let badgeLinearBackground: [Gradient.Stop]
    let badgeRadialBackground: [Gradient.Stop]
}

struct GradientHelper {
    private static let mainLocations: [CGFloat] = [0.0, 0.1, 0.16, 0.33, 0.62]
    private static let mainOpacities: [Double] = [1.0, 1.0, 1.0, 1.0, 1.0]
    
    private static let naviLocations: [CGFloat] = [0.0, 1.0]
    private static let naviOpacities: [Double] = [1.0, 0.0]
    
    private static let badgeLinearLocations: [CGFloat] = [0.0, 1.0]
    private static let badgeLinearOpacities: [Double] = [1.0, 1.0]
    
    private static let badgeRadialLocations: [CGFloat] = [0.0, 0.3, 0.5]
    private static let badgeRadialOpacities: [Double] = [0.7, 0.2, 0.0]
    
    static func getGradientStops(for theme: GradientTheme) -> AllGradientStops {
        let colors = getColors(for: theme)
        
        let mainStops = generateStops(hexColors: colors.mainBackground, locations: mainLocations, opacities: mainOpacities)
        let naviStops = generateStops(hexColors: colors.naviBackground, locations: naviLocations, opacities: naviOpacities)
        let badgeLinearStops = generateStops(hexColors: colors.badgeLinearBackground, locations: badgeLinearLocations, opacities: badgeLinearOpacities)
        let badgeRadialStops = generateStops(hexColors: colors.badgeRadialBackground, locations: badgeRadialLocations, opacities: badgeRadialOpacities)
        
        return AllGradientStops(
            mainBackground: mainStops,
            naviBackground: naviStops,
            badgeLinearBackground: badgeLinearStops,
            badgeRadialBackground: badgeRadialStops
        )
    }
    
    private static func generateStops(
        hexColors: [String],
        locations: [CGFloat],
        opacities: [Double]) -> [Gradient.Stop]
    {
        // 배열 크기가 다를 경우 오류 방지
        guard hexColors.count == locations.count, hexColors.count == opacities.count else { return [] }
        
        return zip(zip(hexColors, locations), opacities).map { colorLocation, opacity in
            let (hex, location) = colorLocation
            return .init(color: Color(hex: hex).opacity(opacity), location: location)
        }
    }
    
    static func getColors(for theme: GradientTheme) -> ColorPalette {
        switch theme {
        case .gold:
            return ColorPalette(
                mainBackground: ["615920", "433F21", "373521", "2B2A22", "1D1E22"],
                naviBackground: ["625921", "4F4A21"],
                badgeLinearBackground: ["DEDFD0", "9EA481"],
                badgeRadialBackground: ["FAE34F", "FAE34F", "FAE34F"])
        case .silver:
            return ColorPalette(
                mainBackground: ["37424E", "2F3741", "2B313A", "25282F", "1D1E22"],
                naviBackground: ["36424E", "2F3740"],
                badgeLinearBackground: ["CFD4EB", "5B648E"],
                badgeRadialBackground: ["7489EF", "7489EF", "7489EF"])
        case .bronze:
            return ColorPalette(
                mainBackground: ["664F32", "4F402D", "3F352A", "272524", "1D1E22"],
                naviBackground: ["665032", "4C3E2C"],
                badgeLinearBackground: ["EEDDCD", "785635"],
                badgeRadialBackground: ["E79649", "E79649", "E79649"])
        }
    }
}

struct BadgeColor {
    var titleColor: String
    var subColor: String
    var image: String
}

// 티어 별 배지 카드 컴포넌트 컬러
extension GradientHelper {
    static func getBadgeColors(for theme: GradientTheme) -> BadgeColor {
        switch theme {
        case .gold:
            return BadgeColor(
                titleColor: "FFEC87",
                subColor: "BDAB47",
                image: "logo_gold"
            )
        case .silver:
            return BadgeColor(
                titleColor: "6D8DC4",
                subColor: "BED6FF",
                image: "logo_silver"
            )
        case .bronze:
            return BadgeColor(
                titleColor: "FFC289",
                subColor: "B9804B",
                image: "logo_bronze"
            )
        }
    }
}
