//
//  Color.swift
//  CriptoApp (iOS)
//
//  Created by Enrique Miguel Bonilla Untiveros on 30/05/22.
//

import SwiftUI

extension Color {
    
    static let theme = ColorTheme()
    static let launch = ColorTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
}

struct LaunchTheme {
    let accent = Color("LaunchAccentColor")
    let background = Color("LaunchBackgroundColor")
}
