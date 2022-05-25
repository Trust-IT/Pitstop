//
//  AddReportView.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 06/05/22.
//

import SwiftUI

struct AddReportView: View {
        
    @StateObject var utilityVM : UtilityViewModel = .init()
    @StateObject var addExpVM : AddExpenseViewModel = .init()
    @StateObject var categoryVM = CategoryViewModel()
    @StateObject var dataVM : DataViewModel
    
    @State private var showDate = false
    
    //Custom picker tabs
    @State private var pickerTabs = ["Expense", "Odometer", "Reminder"]
    
    //Matching geometry namespace
    @Namespace var animation
    
    //Focus keyboard
    @FocusState var focusedField: FocusField?
    
    //To dismiss the modal
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView{
            VStack {
                
                //MARK: Custom TextField
                if(addExpVM.currentPickerTab == "Expense"){
                    NumericFieldComponent(submitField: $addExpVM.price, placeholder: "4", attribute:utilityVM.currency, keyboardType: .decimalPad,focusedField: $focusedField, defaultFocus: .priceTab)
                        .padding(.top,15)
                }
                else if (addExpVM.currentPickerTab == "Odometer"){
                    NumericFieldComponent(submitField: $addExpVM.odometer, placeholder: "0", attribute: utilityVM.unit, keyboardType: .decimalPad,focusedField: $focusedField,defaultFocus: .odometerTab)
                        .padding(.top,15)
                }
                else{
                    TextFieldComponent(submitField: $addExpVM.reminderTab, placeholder: "-", attribute: "ㅤ", keyboardType: .default,focusedField: $focusedField,defaultFocus: .reminderTab)
                        .padding(.top,15)
                }
                
                
                //MARK: Custom segmented picker
                CustomSegmentedPicker()
                    .padding(.horizontal,32)
                    .padding(.top, -10.0)
                
                //MARK: List
                if(addExpVM.currentPickerTab == "Expense"){
                    ExpenseListView(addExpVM: addExpVM,utilityVM: utilityVM, dataVM: dataVM, categoryVM: categoryVM, focusedField: $focusedField)
                }
                else if (addExpVM.currentPickerTab == "Odometer"){
                    OdometerListView(addExpVM: addExpVM,utilityVM: utilityVM, focusedField: $focusedField)
                }
                else{
                    ReminderListView(addExpVM : addExpVM, utilityVM: utilityVM, focusedField: $focusedField)
                }
            }
            .background(Palette.greyBackground)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                            Text("Cancel")
                                .font(Typography.headerM)
                    })
                    .accentColor(Palette.greyHard),
                trailing:
                    Button(action: {
                        addExpVM.createExpense()
                        dataVM.addExpense(expense: addExpVM.expenseS)
                        dataVM.addNewExpensePriceToTotal(expense: addExpVM.expenseS)
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Save")
                            .font(Typography.headerM)
                    })
                    .disabled(addExpVM.price == 0 && addExpVM.odometer == 0 && addExpVM.reminderTab.isEmpty)
                    .opacity(addExpVM.price == 0 && addExpVM.odometer == 0 && addExpVM.reminderTab.isEmpty ? 0.6 : 1)
            )
            .toolbar {
                /// Keyboard focus
                ToolbarItem(placement: .keyboard) {
                    HStack{
                        Button(action: {
                            focusedField = nil
                        }, label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                                .resizable()
                                .foregroundColor(Palette.black)
                        })
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("New report")
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
        }
    }
    
    @ViewBuilder
    func CustomSegmentedPicker() -> some View{
        HStack(spacing:10){
            ForEach(pickerTabs,id:\.self){ tab in
                Text(tab)
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .font(Typography.headerS)
                    .foregroundColor(Palette.black)
                    .background{
                        if addExpVM.currentPickerTab == tab {
                            Capsule()
                                .fill(Palette.greyLight)
                                .matchedGeometryEffect(id: "pickerTab", in: animation)
                        }
                    }
                    .containerShape(Capsule())
                    .onTapGesture {
                        withAnimation(.easeInOut){
                            addExpVM.resetTabFields(tab: addExpVM.currentPickerTab)
                            addExpVM.currentPickerTab = tab
                            let haptic = UIImpactFeedbackGenerator(style: .soft)
                            haptic.impactOccurred()
                        }
                    }
            }
        }
    }
}

//struct AddReportView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddReportView()
//    }
//}

struct ListCategoryComponent: View {
    
    var title : String
    var iconName : String
    var color : Color
    
    var body: some View {
        HStack{
            ZStack{
                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundColor(color)
                Image(iconName)
                    .resizable()
                    .frame(width: 16, height: 16)
                
            }
            Text(title)
                .font(Typography.headerM)
        }
    }
}

struct TextFieldComponent: View {
    
    @Binding var submitField : String
    var placeholder : String
    var attribute : String
    var keyboardType : UIKeyboardType
    
    var focusedField : FocusState<FocusField?>.Binding
    var defaultFocus : FocusField
    
    var body: some View {
        HStack{
            Spacer()
            TextField(placeholder,text: $submitField)
                .focused(focusedField, equals: defaultFocus)
                .font(Typography.headerXXL)
                .foregroundColor(Palette.black)
                .keyboardType(keyboardType)
                .fixedSize(horizontal: true, vertical: true)
            
            Text(attribute)
                .font(Typography.headerXXL)
                .foregroundColor(Palette.black)
            Spacer()
        }
    }
}

struct NumericFieldComponent: View {
    
    let formatter: NumberFormatter = {
          let formatter = NumberFormatter()
          formatter.numberStyle = .decimal
          return formatter
      }()
    
    @Binding var submitField : Float
    var placeholder : String
    var attribute : String
    var keyboardType : UIKeyboardType
    
    var focusedField : FocusState<FocusField?>.Binding
    var defaultFocus : FocusField
    
    var body: some View {
        HStack{
            Spacer()
            TextField(placeholder,value: $submitField,formatter: formatter)
                .focused(focusedField, equals: defaultFocus)
                .font(Typography.headerXXL)
                .foregroundColor(Palette.black)
                .keyboardType(keyboardType)
                .fixedSize(horizontal: true, vertical: true)
            
            Text(attribute)
                .font(Typography.headerXXL)
                .foregroundColor(Palette.black)
            Spacer()
        }
    }
}


enum FocusField: Hashable {
    case priceTab
    case odometerTab
    case reminderTab
    case odometer
    case liter
    case priceLiter
    case note
    
}
