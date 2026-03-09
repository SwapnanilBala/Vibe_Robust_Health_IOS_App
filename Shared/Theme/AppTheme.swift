import SwiftUI

enum AppTheme {
    enum Colors {
        static let background = Color(red: 0.96, green: 0.97, blue: 0.99)
        static let surface = Color.white
        static let text = Color(red: 0.07, green: 0.10, blue: 0.16)
        static let muted = Color(red: 0.42, green: 0.45, blue: 0.51)
        static let primary = Color(red: 0.05, green: 0.10, blue: 0.18)
        static let accent = Color(red: 0.15, green: 0.39, blue: 0.92)
        static let border = Color(red: 0.84, green: 0.87, blue: 0.91)
        static let success = Color(red: 0.06, green: 0.61, blue: 0.35)
        static let warning = Color(red: 0.80, green: 0.30, blue: 0.05)
    }

    enum Spacing {
        static let xs: CGFloat = 6
        static let sm: CGFloat = 10
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
    }

    enum Typography {
        static let display = Font.custom("Avenir Next", size: 34).weight(.heavy)
        static let title = Font.custom("Avenir Next", size: 18).weight(.semibold)
        static let body = Font.custom("Avenir Next", size: 15)
        static let label = Font.custom("Avenir Next", size: 13).weight(.medium)
        static let mono = Font.system(size: 14, weight: .medium, design: .monospaced)
    }
}
