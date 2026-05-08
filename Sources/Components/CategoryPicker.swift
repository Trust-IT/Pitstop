//
//  CategoryPicker.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 02/01/25.
//

import ChassisUI
import SwiftUI

public struct CategoryPicker<T>: View where
    T: Hashable & CaseIterable & RawRepresentable & Identifiable,
    T.RawValue == String {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCategory: T
    var categories: [T]

    /// If no category is specified it will take all cases from the enum
    public init(selectedCategory: Binding<T>, categories: [T] = []) {
        if categories.isEmpty {
            self.categories = Array(T.allCases)
        } else {
            self.categories = categories
        }
        _selectedCategory = selectedCategory
    }

    public var body: some View {
        ZStack {
            Palette.greyBackground
                .ignoresSafeArea()
            CustomList {
                ForEach(categories, id: \.id) { category in
                    Button(action: {
                        withAnimation {
                            if selectedCategory != category {
                                selectedCategory = category
                            }
                        }
                        dismiss()
                    }, label: {
                        HStack {
                            Text(category.rawValue.capitalized)
                                .font(Typography.headerM)
                                .foregroundColor(Palette.black)
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                                .opacity(selectedCategory == category ? 1.0 : 0.0)
                        }
                    })
                }
            }
        }
    }
}
