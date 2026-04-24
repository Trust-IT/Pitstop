//
//  SceneDelegate.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 28/12/24.
//

import OSLog
import SwiftUI

@Observable
class SceneDelegate: NSObject, UIWindowSceneDelegate {
    weak var windowScene: UIWindowScene?
    var overlayWindow: UIWindow?
    var tag: Int = 0
    // Stores multiple alerts
    var alerts: [UIView] = []

    func scene(
        _ scene: UIScene,
        willConnectTo _: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) {
        windowScene = scene as? UIWindowScene
        setupOverlayWindow()
    }

    private func setupOverlayWindow() {
        guard let windowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        window.isHidden = true
        window.isUserInteractionEnabled = false
        overlayWindow = window
    }

    func alert(
        config: Binding<AlertConfig>,
        @ViewBuilder content: @escaping () -> some View,
        viewTag: @escaping (Int) -> Void
    ) {
        guard let alertWindow = overlayWindow else { return }

        let viewcontroller = UIHostingController(rootView: AlertView(config: config, tag: tag, content: {
            content()
        })
        )
        viewcontroller.view.backgroundColor = .clear
        viewcontroller.view.tag = tag
        viewTag(tag)
        tag += 1

        if alertWindow.rootViewController == nil {
            alertWindow.rootViewController = viewcontroller
            alertWindow.isHidden = false
            alertWindow.isUserInteractionEnabled = true
        } else {
            Logger.navigation.warning("Existing alert is still present")
            viewcontroller.view.frame = alertWindow.rootViewController?.view.frame ?? .zero
            alerts.append(viewcontroller.view)
        }
    }
}
