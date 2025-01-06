//
//  HomeStyleView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 12/05/22.
//

import Foundation
import SwiftUI

struct HomeStyleView: View {
    @EnvironmentObject var utilityVM: UtilityViewModel
    // Scroll animation vars
    @State var offset: CGFloat = 0
    @State var topEdge: CGFloat
    let maxHeight = UIScreen.main.bounds.height / 3.8

    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    GeometryReader { _ in
                        // HEADER CONTENT
                        HeaderContent(offset: $offset, maxHeight: maxHeight)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .opacity(fadeOutOpacity()) // Directly apply opacity
                            .frame(height: getHeaderHeight(), alignment: .bottom)
                            .background(utilityVM.currentTheme.colors.background)
                            .overlay(
                                // TOP NAV BAR
                                TopNav(offset: offset, maxHeight: maxHeight, topEdge: topEdge)
                                    .padding(.horizontal)
                                    .frame(height: 60)
                                    .padding(.top, topEdge + 10),
                                alignment: .top
                            )
                    }
                    .frame(height: maxHeight)
                    .offset(y: -offset)
                    .zIndex(1)

                    // BOTTOM CONTENT VIEW
                    ZStack {
                        BottomContentView()
                            .background(
                                Palette.greyBackground,
                                in: CustomCorner(corners: [.topLeft, .topRight], radius: getCornerRadius())
                            )
                    }
                    .background(utilityVM.currentTheme.colors.background)
                    .padding(.top, -15)
                    .zIndex(0)
                }
                .modifier(OffsetModifier(offset: $offset))
            }
            .background(Palette.greyBackground)
            .coordinateSpace(name: "SCROLL")
        }
    }

    // Helper Functions
    func getHeaderHeight() -> CGFloat {
        let topHeight = maxHeight + offset
        return topHeight > (60 + topEdge) ? topHeight : (60 + topEdge)
    }

    func getCornerRadius() -> CGFloat {
        let progress = -offset / (maxHeight - (60 + topEdge))
        let value = 1 - progress
        let radius = value * 35
        return offset < 0 ? radius : 35
    }

    func fadeInOpacity() -> CGFloat {
        let progress = -(offset + 70) / (maxHeight - (60 + topEdge * 3.2))
        return max(0, min(1, progress)) // Clamp between 0 and 1
    }

    func fadeOutOpacity() -> CGFloat {
        let progress = -offset / 70
        let opacity = 1 - progress
        return max(0, min(1, opacity)) // Clamp between 0 and 1
    }
}

// struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//        VehicleView()
//    }
// }

struct OffsetModifier: ViewModifier {
    @Binding var offset: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy -> Color in

                    // getting value for coordinate space called scroll
                    let minY = proxy.frame(in: .named("SCROLL")).minY

                    DispatchQueue.main.async {
                        offset = minY
                    }

                    return Color.clear
                },
                alignment: .top
            )
    }
}

struct CustomCorner: Shape {
    var corners: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
