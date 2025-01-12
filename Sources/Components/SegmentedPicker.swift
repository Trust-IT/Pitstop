//
//  SegmentedPicker.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 02/01/25.
//

import SwiftUI

struct SegmentedPicker<T>: View where
    T: Hashable & CaseIterable & RawRepresentable & Identifiable,
    T.RawValue == String {
    @Namespace var animation
    @Binding var currentTab: T
    let style: SegmentedPickerStyle
    let onTap: () -> Void

    init(
        currentTab: Binding<T>,
        style: SegmentedPickerStyle = .defaultStyle,
        onTap: @escaping () -> Void = {}
    ) {
        _currentTab = currentTab
        self.style = style
        self.onTap = onTap
    }

    var body: some View {
        HStack(spacing: 10) {
            ForEach(Array(T.allCases), id: \.id) { tab in
                tabView(for: tab)
            }
        }
    }

    private func tabView(for tab: T) -> some View {
        Text(tab.rawValue.capitalized)
            .fixedSize()
            .frame(maxWidth: .infinity)
            .padding(10)
            .font(Typography.headerS)
            .foregroundColor(currentTab == tab ? style.selectedColor : style.unselectedColor)
            .background {
                if currentTab == tab {
                    Capsule()
                        .fill(style.capsuleBackground)
                        .matchedGeometryEffect(id: "pickerTab", in: animation)
                }
            }
            .containerShape(Capsule())
            .onTapGesture {
                withAnimation(.easeInOut) {
                    currentTab = tab
                }
                let haptic = UIImpactFeedbackGenerator(style: .soft)
                haptic.impactOccurred()
                onTap()
            }
    }
}

struct SegmentedPickerStyle {
    let capsuleBackground: Color
    let selectedColor: Color
    let unselectedColor: Color

    static let defaultStyle = SegmentedPickerStyle(
        capsuleBackground: Palette.greyLight,
        selectedColor: Palette.black,
        unselectedColor: Palette.black.opacity(0.7)
    )

    static let black = SegmentedPickerStyle(
        capsuleBackground: Palette.black,
        selectedColor: Palette.white,
        unselectedColor: Palette.black
    )
}

#Preview {
    @Previewable @State var tabs: NewReportTab = .fuel
    SegmentedPicker(currentTab: $tabs, onTap: {})
}
