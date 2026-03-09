import SwiftUI

struct ChipOption<Value: Hashable>: Identifiable {
    let value: Value
    let label: String

    var id: String { label }
}

struct SelectionChips<Value: Hashable>: View {
    let options: [ChipOption<Value>]
    @Binding var selection: Value

    private let columns = [GridItem(.adaptive(minimum: 120), spacing: AppTheme.Spacing.sm)]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: AppTheme.Spacing.sm) {
            ForEach(options) { option in
                let isActive = option.value == selection
                Button {
                    selection = option.value
                } label: {
                    Text(option.label)
                        .font(AppTheme.Typography.label)
                        .foregroundStyle(isActive ? AppTheme.Colors.accent : AppTheme.Colors.text)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .background(isActive ? Color(red: 0.88, green: 0.92, blue: 1.0) : Color.white)
                        .overlay(
                            Capsule()
                                .stroke(isActive ? AppTheme.Colors.accent : AppTheme.Colors.border, lineWidth: 1)
                        )
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct MultiSelectionChips<Value: Hashable>: View {
    let options: [ChipOption<Value>]
    @Binding var selection: Set<Value>

    private let columns = [GridItem(.adaptive(minimum: 140), spacing: AppTheme.Spacing.sm)]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: AppTheme.Spacing.sm) {
            ForEach(options) { option in
                let isActive = selection.contains(option.value)
                Button {
                    if isActive {
                        selection.remove(option.value)
                    } else {
                        selection.insert(option.value)
                    }
                } label: {
                    Text(option.label)
                        .font(AppTheme.Typography.label)
                        .foregroundStyle(isActive ? AppTheme.Colors.accent : AppTheme.Colors.text)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .background(isActive ? Color(red: 0.88, green: 0.92, blue: 1.0) : Color.white)
                        .overlay(
                            Capsule()
                                .stroke(isActive ? AppTheme.Colors.accent : AppTheme.Colors.border, lineWidth: 1)
                        )
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
    }
}
