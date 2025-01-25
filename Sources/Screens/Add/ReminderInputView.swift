//
//  ReminderInputView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 09/05/22.
//

import SwiftData
import SwiftUI

struct ReminderInputView: View {
    @State private var selectedType: Reminder.Typology = .date
    @Bindable var reminder: Reminder

    var reminderInputFocus: FocusState<ReminderInputFocusField?>.Binding

    var body: some View {
        CustomList {
            // MARK: CATEGORY

            HStack {
                CategoryRow(input: .init(
                    title: String(localized: "Category"),
                    icon: .category,
                    color: Palette.colorYellow
                )
                )
                Spacer()
                NavigationLink(
                    destination: CategoryPicker(selectedCategory: $reminder.category)
                ) {
                    HStack {
                        Spacer()
                        Text(reminder.category.rawValue)
                            .fixedSize()
                            .font(Typography.headerM)
                            .foregroundColor(Palette.greyMiddle)
                    }
                }
            }

            // MARK: TYPOLOGY

            Picker(
                selection: $selectedType,
                content: {
                    ForEach(Reminder.Typology.allCases, id: \.self) {
                        Text($0.rawValue)
                            .font(Typography.headerM)
                    }
                },
                label: {
                    CategoryRow(input: .init(
                        title: String(localized: "Based on"),
                        icon: .basedOn,
                        color: Palette.colorOrange
                    ))
                }
            )

            switch selectedType {
            case .date:
                DatePicker(
                    selection: $reminder.date,
                    in: Date() ... Date().addingYears(3)!
                ) {
                    CategoryRow(input: .init(
                        title: String(localized: "Remind me on"),
                        icon: .remindMe,
                        color: Palette.colorGreen
                    ))

                    .padding(.bottom, 10)
                }
                .datePickerStyle(.compact)
//            default:
//                HStack {
//                    CategoryRow(title: String(localized: "Remind me in"), icon: .remindMe, color: Palette.colorGreen)
//                    Spacer()
//                    TextField("1000", value: $reminderVM.distance, formatter: NumberFormatter())
//                        .font(Typography.headerM)
//                        .foregroundColor(Palette.black)
//                        .textFieldStyle(.plain)
//                        .keyboardType(.decimalPad)
//                        .fixedSize(horizontal: true, vertical: true)
//                    Text(utilityVM.unit)
//                        .font(Typography.headerM)
//                        .foregroundColor(Palette.black)
//                }
            }

            // TODO: Implement REPEAT

//            Picker(selection: $addExpVM.selectedRepeat, content: {
//                ForEach(addExpVM.repeatTypes, id: \.self) {
//                    Text($0)
//                        .font(Typography.headerM)
//                }
//            }, label:{
//                ListCategoryComponent(title: "Repeat", iconName: "Repeat", color: Palette.colorViolet)
//            })
//            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))

            // MARK: NOTE

            HStack {
                ZStack {
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundColor(reminder.note.isEmpty ? Palette.greyLight : Palette.colorViolet)
                    Image(reminder.note.isEmpty ? .note : .noteColored)
                        .resizable()
                        .frame(width: 16, height: 16)
                }
                TextField(String(localized: "Note"), text: $reminder.note)
                    .disableAutocorrection(true)
                    .focused(reminderInputFocus, equals: .note)
                    .font(Typography.headerM)
            }
        }
        .padding(.top, -10)
        .onAppear {
            /// Setting the keyboard focus on the price when opening the modal
            reminderInputFocus.wrappedValue = .reminderTitle
        }
    }
}
