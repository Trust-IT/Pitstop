//
//  ReminderListView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 09/05/22.
//

import SwiftUI

struct ReminderListView: View {
    
    @ObservedObject var dataVM: DataViewModel
    @ObservedObject var addExpVM : AddExpenseViewModel
    @ObservedObject var utilityVM : UtilityViewModel
    @ObservedObject var reminderVM: AddReminderViewModel
    @ObservedObject var categoryVM : CategoryViewModel
    var focusedField : FocusState<FocusField?>.Binding
    
    @State private var checkmark = false
    
    var body: some View {
        List{
            
            //MARK: CATEGORY
//            Picker(selection: $addExpVM.selectedCategoryReminder, content: {
//                ForEach(addExpVM.categoryReminder, id: \.self) {
//                    Text($0)
//                        .font(Typography.headerM)
//                }
//            },label:{
//                ListCategoryComponent(title: "Category", iconName: "category", color: Palette.colorYellow)
//            })
            HStack{
                ListCategoryComponent(title: "Category", iconName: "category", color: Palette.colorYellow)
                Spacer()
                NavigationLink(destination: CustomCategoryPicker(dataVM: dataVM, addExpVM: addExpVM, reminderVM: reminderVM, categoryVM: categoryVM, checkmark: $checkmark)){
                Spacer()
                Text(reminderVM.selectedCategory)
                    .font(Typography.headerM)
                    .foregroundColor(Palette.greyMiddle)
                }
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            //MARK: BASED ON PICKER
            Picker(selection: $addExpVM.selectedBased, content: {
                ForEach(addExpVM.basedTypes, id: \.self) {
                    Text($0)
                        .font(Typography.headerM)
                }
            },label:{
                ListCategoryComponent(title: "Based on", iconName: "basedOn", color: Palette.colorOrange)
            })
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            //MARK: REMIND DATE
            if (addExpVM.selectedBased == "Date"){
                DatePicker(selection: $reminderVM.date,in:Date()...) {
                    ListCategoryComponent(title: "Remind me on", iconName: "remindMe", color: Palette.colorGreen)
                }
                .datePickerStyle(.compact)
                .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            }
            //MARK: REMIND DISTANCE
            else{
                HStack{
                    ListCategoryComponent(title: "Remind me in", iconName: "remindMe", color: Palette.colorGreen)
                    Spacer()
                    TextField("1000",value: $reminderVM.distance,formatter: NumberFormatter())
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                        .textFieldStyle(.plain)
                        .keyboardType(.decimalPad)
                        .fixedSize(horizontal: true, vertical: true)
                    Text(utilityVM.unit)
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
                .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            }
            //MARK: REPEAT
            Picker(selection: $addExpVM.selectedRepeat, content: {
                ForEach(addExpVM.repeatTypes, id: \.self) {
                    Text($0)
                        .font(Typography.headerM)
                }
            }, label:{
                ListCategoryComponent(title: "Repeat", iconName: "repeat", color: Palette.colorViolet)
            })
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
            //MARK: NOTE
            HStack{
                ZStack{
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundColor(reminderVM.note.isEmpty ? Palette.greyLight : Palette.colorViolet)
                    Image(reminderVM.note.isEmpty ? "note" : "noteColored")
                        .resizable()
                        .frame(width: 16, height: 16)
                }
                TextField("Note",text: $reminderVM.note)
                    .disableAutocorrection(true)
                    .focused(focusedField, equals: .note)
                    .font(Typography.headerM)
            }
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        }
        .padding(.top,-10)
        .onAppear {
            /// Setting the keyboard focus on the price when opening the modal
            if(reminderVM.title.isEmpty){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {  /// Anything over 0.5 delay seems to work
                    focusedField.wrappedValue = .reminderTab
                }
            }
        }
    }
}
