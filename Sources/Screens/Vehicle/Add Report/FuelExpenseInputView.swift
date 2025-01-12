//
//  FuelExpenseInputView.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 02/01/25.
//

import SwiftData
import SwiftUI

struct FuelExpenseInputView: View {
    let vehicleFuels: [FuelType]
    var fuelInputFocus: FocusState<FuelInputFocusField?>.Binding
    @Binding var fuelExpense: FuelExpense

    var body: some View {
        CustomList {
            CategoryInputView(
                categoryInfo: .init(
                    title: "Odometer",
                    icon: .odometer,
                    color: Palette.colorBlue
                ),
                type: .field(
                    value: $fuelExpense.odometer,
                    unit: "km",
                    placeholder: "0",
                    keyboardType: .numberPad,
                    focusType: FuelInputFocusField.odometer
                )
            )
            NavigationLink(
                destination: CategoryPicker(
                    selectedCategory: $fuelExpense.fuelType,
                    categories: vehicleFuels
                )
            ) {
                HStack {
                    CategoryRow(input: .init(title: "Fuel type", icon: .fuelType, color: Palette.colorOrange))
                    Spacer()
                    Text(fuelExpense.fuelType.rawValue)
                        .fixedSize()
                        .font(Typography.headerM)
                        .foregroundColor(Palette.greyMiddle)
                }
            }
            CategoryInputView<FuelInputFocusField>(
                categoryInfo: .init(
                    title: "Day",
                    icon: .day,
                    color: Palette.colorGreen
                ),
                type: .date(value: $fuelExpense.date)
            )
            CategoryInputView(
                categoryInfo: .init(
                    title: "Liters",
                    icon: fuelExpense.quantity.isZero ? .liters : .literColored,
                    color: fuelExpense.quantity.isZero ? Palette.greyLight : Palette.colorOrange
                ),
                type: .field(
                    value: $fuelExpense.quantity,
                    unit: "L",
                    placeholder: "0",
                    keyboardType: .decimalPad,
                    focusType: FuelInputFocusField.quantity
                )
            )
            CategoryInputView(
                categoryInfo: .init(
                    title: "Price/Liter",
                    icon: fuelExpense.pricePerUnit.isZero ? .priceLiter : .priceLiterColored,
                    color: fuelExpense.pricePerUnit.isZero ? Palette.greyLight : Palette.colorOrange
                ),
                type: .field(
                    value: $fuelExpense.pricePerUnit,
                    unit: "€",
                    placeholder: "0",
                    keyboardType: .decimalPad,
                    focusType: FuelInputFocusField.pricePerUnit
                )
            )
        }
    }
}

// struct CategoryInputView: View {
//    let categoryInfo: CategoryRow.Input
//    let type: InputType
//
//    var body: some View {
//        HStack {
//            switch type {
//            case let .field(value, unit, placeholder, keyboardType):
//                    CategoryRow(input: categoryInfo)
//                    Spacer()
//                    TextField(placeholder, value: value, formatter: NumberFormatter.twoDecimalPlaces)
//                        .font(Typography.headerM)
//                        .foregroundColor(Palette.black)
//                        .keyboardType(keyboardType)
//                        .fixedSize(horizontal: true, vertical: true)
//                    Text(unit)
//                        .font(Typography.headerM)
//                        .foregroundColor(Palette.black)
//            case let .date(value):
//                DatePicker(selection: value, in: ...Date(), displayedComponents: [.date]) {
//                    CategoryRow(input: categoryInfo)
//                }
//            }
//        }
//    }
//
//    enum InputType {
//        case field(value: Binding<Float>, unit: String, placeholder: String, keyboardType: UIKeyboardType)
//        case date(value: Binding<Date>)
//    }
// }

struct CategoryInputView<T>: View where T: Hashable {
    @FocusState private var focusedField: T?

    let categoryInfo: CategoryRow.Input
    let type: InputType

    var body: some View {
        HStack {
            switch type {
            case let .field(value, unit, placeholder, keyboardType, focus):
                Group {
                    CategoryRow(input: categoryInfo)
                    Spacer()
                    TextField(placeholder, value: value, formatter: NumberFormatter.twoDecimalPlaces)
                        .focused($focusedField, equals: focus)
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                        .keyboardType(keyboardType)
                        .fixedSize(horizontal: true, vertical: true)
                    Text(unit)
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
                .onTapGesture {
                    focusedField = focus
                }
            case let .date(value):
                DatePicker(selection: value, in: ...Date(), displayedComponents: [.date]) {
                    CategoryRow(input: categoryInfo)
                }
            }
        }
    }

    enum InputType {
        case field(
            value: Binding<Float>,
            unit: String,
            placeholder: String,
            keyboardType: UIKeyboardType,
            focusType: T
        )
        case date(value: Binding<Date>)
    }
}
