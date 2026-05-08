//
//  HomeStyleView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 12/05/22.
//

import ChassisUI
import NavigatorUI
import SwiftUI

struct HomeStyleView: View {
    @Environment(AppState.self) var appState: AppState

    @State var offset: CGFloat = 0
    @State var topEdge: CGFloat
    let maxHeight: CGFloat

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                GeometryReader { _ in
                    HeaderContent(offset: $offset, maxHeight: maxHeight)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .opacity(fadeOutOpacity())
                        .frame(height: getHeaderHeight(), alignment: .bottom)
                        .background(appState.currentTheme.colors.background)
                }
                .frame(height: maxHeight)
                .overlay(alignment: .top) {
                    TopBarView(offset: offset, maxHeight: maxHeight, topEdge: topEdge)
                        .frame(height: 60)
                        .padding(.top, topEdge + 10)
                }
                .offset(y: -offset)
                .zIndex(1)

                ZStack {
                    BottomContentView()
                        .background(
                            UnevenRoundedRectangle(
                                topLeadingRadius: getCornerRadius(),
                                topTrailingRadius: getCornerRadius()
                            )
                            .foregroundStyle(Palette.greyBackground)
                        )
                }
                .background(appState.currentTheme.colors.background)
                .zIndex(0)
            }
        }
        .contentMargins(.bottom, maxHeight - minHeaderHeight, for: .scrollContent)
        .onScrollGeometryChange(for: CGFloat.self) { geo in
            geo.contentOffset.y + geo.contentInsets.top
        } action: { _, newValue in
            offset = -newValue
        }
        .background(Palette.greyBackground)
        .ignoresSafeArea(.all, edges: .top)
    }

    // safe area + 10pt bar top padding + 60pt bar height + 20pt bottom breathing room
    var minHeaderHeight: CGFloat { topEdge + 90 }

    func getHeaderHeight() -> CGFloat {
        let topHeight = maxHeight + offset
        return topHeight > minHeaderHeight ? topHeight : minHeaderHeight
    }

    func getCornerRadius() -> CGFloat {
        let progress = -offset / (maxHeight - minHeaderHeight)
        let value = 1 - progress
        let radius = value * 35
        return offset < 0 ? radius : 35
    }

    func fadeOutOpacity() -> CGFloat {
        let progress = -offset / 70
        let opacity = 1 - progress
        return max(0, min(1, opacity))
    }
}

#Preview {
    @Previewable @State var vehicleManager = PreviewSupport.vehicleManager
    ManagedNavigationStack { _ in
        GeometryReader { proxy in
            let topEdge = proxy.safeAreaInsets.top
            HomeStyleView(topEdge: topEdge, maxHeight: proxy.size.height / 3.8)
                .environment(vehicleManager)
                .environment(AppState())
        }
    }
}
