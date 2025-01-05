//
//  HomeViewModel.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 13/05/22.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var offset: CGFloat = 0
    @Published var topEdge: CGFloat = 0
    let maxHeight = UIScreen.main.bounds.height / 3.6

    // MARK: FRONTEND FUNCS

    // Opacity to let appear items in the top bar
    func fadeInOpacity() -> CGFloat {
        // to start after the main content vanished
        // we nee to eliminate 70 from the offset
        // to get starter..
        let progress = -(offset + 70) / (maxHeight - (60 + topEdge * 3.2))

        return progress
    }

    // Opacity to let items in top bar disappear on scroll
    func fadeOutOpacity() -> CGFloat {
        // 70 = Some rnadom amount of time to visible on scroll

        let progress = -offset / 70
        let opacity = 1 - progress

        return offset < 0 ? opacity : 1
    }
}
