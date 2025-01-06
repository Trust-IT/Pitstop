//
//  GenericAlert.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 28/12/24.
//

import SwiftUI

struct AlertConfig {
    fileprivate var enableBackgroundBlur: Bool = true
    fileprivate var disableOutsideTap: Bool = true
    fileprivate var transitionType: TransitionType = .slide
    fileprivate var slideEdge: Edge = .bottom
    fileprivate var show: Bool = false
    fileprivate var showView: Bool = false

    init(
        enableBackgroundBlur: Bool = true,
        disableOutsideTap: Bool = true,
        transitionType: TransitionType = .slide,
        slideEdge: Edge = .bottom
    ) {
        self.enableBackgroundBlur = enableBackgroundBlur
        self.disableOutsideTap = disableOutsideTap
        self.transitionType = transitionType
        self.slideEdge = slideEdge
    }

    enum TransitionType {
        case slide
        case opacity
    }

    mutating
    func present() {
        show = true
    }

    mutating func dismiss() {
        show = false
    }
}

struct AlertView<Content: View>: View {
    @Binding var config: AlertConfig
    var tag: Int
    @ViewBuilder var content: () -> Content

    @State private var showView: Bool = false

    var body: some View {
        GeometryReader(content: { _ in
            ZStack {
                if config.enableBackgroundBlur {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                } else {
                    Rectangle()
                        .fill(.primary.opacity(0.25))
                }
            }
            .ignoresSafeArea()
            .contentShape(.rect)
            .onTapGesture {
                if !config.disableOutsideTap {
                    config.dismiss()
                }
            }
            .opacity(showView ? 1 : 0)

            if showView, config.transitionType == .slide {
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.move(edge: config.slideEdge))
            } else {
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(showView ? 1 : 0)
            }
        })
        .onAppear {
            config.showView = true
        }
        .onChange(of: config.showView) { _, newValue in
            withAnimation(.smooth(duration: 0.35, extraBounce: 0)) {
                showView = newValue
            }
        }
    }
}

extension View {
    /// Present an alert with the given configuration.
    /// - Note: This modifier doesn't carry the current context of the view. Which means that you need to explicitly pass the context to the alert view.
    @ViewBuilder
    func alert<Content: View>(
        config: Binding<AlertConfig>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(AlertModifier(config: config, alertContent: content))
    }
}

// MARK: View Modifier

private struct AlertModifier<AlertContent: View>: ViewModifier {
    @Binding var config: AlertConfig
    @ViewBuilder var alertContent: () -> AlertContent

    @Environment(SceneDelegate.self) private var sceneDelegate

    @State private var viewTag: Int = 0

    func body(content: Content) -> some View {
        content
            .onChange(of: config.show, initial: false) { _, newValue in
                if newValue {
                    sceneDelegate.alert(config: $config, content: alertContent) { tag in
                        viewTag = tag
                    }
                } else {
                    guard let alertWindow = sceneDelegate.overlayWindow else { return }
                    if config.showView {
                        withAnimation(.smooth(duration: 0.35, extraBounce: 0)) {
                            config.showView = false
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            if sceneDelegate.alerts.isEmpty {
                                alertWindow.rootViewController = nil
                                alertWindow.isHidden = true
                                alertWindow.isUserInteractionEnabled = false
                            } else {
                                if let first = sceneDelegate.alerts.first {
                                    alertWindow.rootViewController?.view.subviews.forEach { view in
                                        view.removeFromSuperview()
                                    }

                                    alertWindow.rootViewController?.view.addSubview(first)
                                    sceneDelegate.alerts.removeFirst()
                                }
                            }
                        }
                    } else {
                        /// Remove the view from the Array with the help of View Tag
                        sceneDelegate.alerts.removeAll(where: { $0.tag == viewTag })
                    }
                }
            }
    }
}
