//
//  CustomList.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 19/05/23.
//

import SwiftUI

struct CustomList<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        List {
            content()
                .padding(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
                .setRowSeparatorStyle()
        }
        .scrollContentBackground(.hidden)
    }
}
