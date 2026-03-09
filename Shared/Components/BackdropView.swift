import SwiftUI

enum BackdropVariant {
    case home
    case onboarding
    case member
    case trainer
    case plan
    case pricing

    var gradient: LinearGradient {
        switch self {
        case .home:
            return LinearGradient(colors: [Color(red: 0.99, green: 0.96, blue: 0.93), Color(red: 0.95, green: 0.97, blue: 1.0)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .onboarding:
            return LinearGradient(colors: [Color(red: 0.93, green: 0.97, blue: 1.0), Color(red: 0.97, green: 0.95, blue: 1.0)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .member:
            return LinearGradient(colors: [Color(red: 0.99, green: 0.94, blue: 0.97), Color(red: 0.95, green: 0.98, blue: 0.99)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .trainer:
            return LinearGradient(colors: [Color(red: 0.93, green: 0.99, blue: 0.98), Color(red: 0.96, green: 0.95, blue: 1.0)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .plan:
            return LinearGradient(colors: [Color(red: 0.95, green: 0.97, blue: 1.0), Color(red: 0.98, green: 0.96, blue: 0.95)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .pricing:
            return LinearGradient(colors: [Color(red: 1.0, green: 0.96, blue: 0.91), Color(red: 0.99, green: 0.98, blue: 0.95)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

struct BackdropView<Content: View>: View {
    let variant: BackdropVariant
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            variant.gradient
                .ignoresSafeArea()

            Circle()
                .fill(Color(red: 0.49, green: 0.76, blue: 0.98).opacity(0.16))
                .frame(width: 260, height: 260)
                .offset(x: 120, y: -140)

            RoundedRectangle(cornerRadius: 44, style: .continuous)
                .fill(Color(red: 0.98, green: 0.73, blue: 0.46).opacity(0.18))
                .frame(width: 220, height: 220)
                .rotationEffect(.degrees(32))
                .offset(x: -130, y: -120)

            Circle()
                .fill(Color(red: 0.50, green: 0.86, blue: 0.68).opacity(0.12))
                .frame(width: 210, height: 210)
                .offset(x: -120, y: 340)

            content()
        }
    }
}
