// File: Color+Gotchai.swift

import SwiftUI

public enum GotchaiColor: String {
  case gray_black
  case gray_white
  case gray_50
  case gray_100
  case gray_200
  case gray_300
  case gray_400
  case gray_500
  case gray_600
  case gray_700
  case gray_800
  case gray_850
  case gray_900
  case gray_950

  case primary_100
  case primary_200
  case primary_300
  case primary_400
  case primary_500
  case primary_600
  case primary_700
  case primary_800
  case primary_900
  case primary_950

  case sub_blue
  case sub_red
}

private let gotchaiToDesignSystemMap: [GotchaiColor: Color] = [
    .gray_black: DesignSystemAsset.Colors.grayBlack.swiftUIColor,
    .gray_white: DesignSystemAsset.Colors.grayWhite.swiftUIColor,
    .gray_50: DesignSystemAsset.Colors.gray50.swiftUIColor,
    .gray_100: DesignSystemAsset.Colors.gray100.swiftUIColor,
    .gray_200: DesignSystemAsset.Colors.gray200.swiftUIColor,
    .gray_300: DesignSystemAsset.Colors.gray300.swiftUIColor,
    .gray_400: DesignSystemAsset.Colors.gray400.swiftUIColor,
    .gray_500: DesignSystemAsset.Colors.gray500.swiftUIColor,
    .gray_600: DesignSystemAsset.Colors.gray600.swiftUIColor,
    .gray_700: DesignSystemAsset.Colors.gray700.swiftUIColor,
    .gray_800: DesignSystemAsset.Colors.gray800.swiftUIColor,
    .gray_850: DesignSystemAsset.Colors.gray850.swiftUIColor,
    .gray_900: DesignSystemAsset.Colors.gray900.swiftUIColor,
    .gray_950: DesignSystemAsset.Colors.gray950.swiftUIColor,

    .primary_100: DesignSystemAsset.Colors.primary100.swiftUIColor,
    .primary_200: DesignSystemAsset.Colors.primary200.swiftUIColor,
    .primary_300: DesignSystemAsset.Colors.primary300.swiftUIColor,
    .primary_400: DesignSystemAsset.Colors.primary400.swiftUIColor,
    .primary_500: DesignSystemAsset.Colors.primary500.swiftUIColor,
    .primary_600: DesignSystemAsset.Colors.primary600.swiftUIColor,
    .primary_700: DesignSystemAsset.Colors.primary700.swiftUIColor,
    .primary_800: DesignSystemAsset.Colors.primary800.swiftUIColor,
    .primary_900: DesignSystemAsset.Colors.primary900.swiftUIColor,
    .primary_950: DesignSystemAsset.Colors.primary950.swiftUIColor,

    .sub_blue: DesignSystemAsset.Colors.subBlue.swiftUIColor,
    .sub_red: DesignSystemAsset.Colors.subRed.swiftUIColor
]

public extension Color {
    init(_ gotchaiColor: GotchaiColor) {
        self = gotchaiToDesignSystemMap[gotchaiColor] ?? Color.clear
    }
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
            
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
