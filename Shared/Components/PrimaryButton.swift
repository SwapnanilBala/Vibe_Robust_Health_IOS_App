import SwiftUI

enum PrimaryButtonVariant {
    case primary
    case secondary
}

struct PrimaryButton: View {
    let title: String
    var variant: PrimaryButtonVariant = .primary
    var disabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.Typography.title)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(background)
                .foregroundStyle(foreground)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(border, lineWidth: variant == .secondary ? 1 : 0)
                )
        }
        .buttonStyle(.plain)
        .opacity(disabled ? 0.6 : 1)
        .disabled(disabled)
    }

    private var background: Color {
        switch variant {
        case .primary:
            return AppTheme.Colors.primary
        case .secondary:
            return Color.white.opacity(0.8)
        }
    }

    private var foreground: Color {
        switch variant {
        case .primary:
            return .white
        case .secondary:
            return AppTheme.Colors.text
        }
    }

    private var border: Color {
        switch variant {
        case .primary:
            return .clear
        case .secondary:
            return AppTheme.Colors.border
        }
    }
}
