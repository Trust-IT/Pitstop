//
//  LastEventsListView.swift
//  Hurricane
//
//  Created by Asya Tealdi on 23/05/22.
//

import SwiftUI


struct LastEventsListView: View {
    
    @ObservedObject var categoryVM = CategoryViewModel()
    @State private var pickerTabs = ["Overview", "Cost", "Fuel", "Odometer"]
    
    @State private var showEditExpense = false
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject var dataVM : DataViewModel
    @ObservedObject var utilityVM : UtilityViewModel
        
    @State var isfilterSelected = 0 // If  == 0 no filters selected
    
    
    var body: some View {
        NavigationView{
            ZStack{
                Palette.greyBackground
                    .ignoresSafeArea()
                VStack {
                    
                    //MARK: CATEGORIES FILTER
                    FiltersRow(dataVM: dataVM, isFilterSelected: $isfilterSelected)
                    ScrollView(.vertical, showsIndicators: false){
                        
                        if(dataVM.expenseList.isEmpty){
                            HStack{
                                Text("There are no events now")
                                    .font(Typography.TextM)
                                    .foregroundColor(Palette.greyMiddle)
                                Spacer()
                            }
                            .padding()
                        }
                        
                        
                        ForEach(dataVM.monthsAmount.sorted(by: <),id:\.self){ month in
                            
                            //MARK: MONTHS
                            ZStack{
                                Rectangle()
                                    .frame(height: UIScreen.main.bounds.height * 0.035)
                                    .foregroundColor(Palette.greyLight)
                                HStack{
                                    Text(month.capitalized)
                                        .foregroundColor(Palette.black)
                                        .font(Typography.ControlS)
                                    Spacer()
                                    if(isfilterSelected == 0){
                                        Text(String(format: "%2.f",dataVM.getMonthsExpense(expenses: dataVM.expenseList, month: month)) + String(utilityVM.currency))
                                            .foregroundColor(Palette.black)
                                            .font(Typography.ControlS)
                                    }
                                    else{
                                        Text(String(format: "%2.f",dataVM.getMonthsExpense(expenses: dataVM.expenseFilteredList, month: month)) + String(utilityVM.currency))
                                            .foregroundColor(Palette.black)
                                            .font(Typography.ControlS)
                                    }
                                }
                                .padding()
                            }
                            
//                          MARK: LIST
                            if (isfilterSelected == 0){
                            ForEach(dataVM.expenseList.filter {$0.date.toString(dateFormat: "MMMM") == month} .reversed(),id:\.self) { expense in
                                    CategoryComponent(
                                        category: Category.init(rawValue: Int(expense.category )) ?? .other,
                                        date: expense.date, cost: String(expense.price)
                                    )
                                    .onTapGesture {
                                        showEditExpense.toggle()
                                        utilityVM.expenseToEdit = ExpenseState.fromExpenseViewModel(vm: expense)
                                    }
                            }.onDelete(perform: dataVM.deleteExpense)
                            }
                            else{
                                ForEach(dataVM.expenseFilteredList.filter {$0.date.toString(dateFormat: "MMMM") == month}.reversed(),id:\.self) { expense in
                                    CategoryComponent(
                                        category: Category.init(rawValue: Int(expense.category )) ?? .other,
                                        date: expense.date, cost: String(expense.price)
                                    )
                                    .onTapGesture {
                                        showEditExpense.toggle()
                                        utilityVM.expenseToEdit = ExpenseState.fromExpenseViewModel(vm: expense)
                                    }
                                }
                            }
                        }

                        Spacer()
                    }
                }
            }
            .sheet(isPresented: $showEditExpense){
                EditEventView(
                    utilityVM: utilityVM,
                    dataVM : dataVM,
                    category: Category.init(rawValue: Int(utilityVM.expenseToEdit.category ?? 0 )) ?? .other
                )
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                            .font(Typography.headerM)
                    })
                    .accentColor(Palette.greyHard)
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Last Events")
                        .font(Typography.headerM)
                        .foregroundColor(Palette.black)
                }
            }
            .onAppear{
                dataVM.getExpensesCoreData(filter: nil, storage: { storage in
                    dataVM.expenseFilteredList = storage
                })
                dataVM.getTotalExpense(expenses: dataVM.expenseList)
                dataVM.getMonths(expenses: dataVM.expenseList)
            }
        }
    }
}

//struct LastEventsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        LastEventsListView()
//    }
//}


struct FiltersRow: View {
    
    @State private var parkingIsPressed = false
    @State private var otherIsPressed = false
    @State private var finesIsPressed = false
    @State private var fuelIsPressed = false
    @State private var insuranceIsPressed = false
    @State private var tollsIsPressed = false
    @State private var maintenanceIsPressed = false
    @State private var roadTaxIsPressed = false
    
    @StateObject var dataVM : DataViewModel
    
    @State var curretFilter: [Int] = [] // Array to store the filters used
    
    @Binding var isFilterSelected : Int
    //    @Binding var month: String
    
    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                
                Button("Fuel"){
                    impactMed.impactOccurred()
                    fuelIsPressed.toggle()
                    
                    
                    if(fuelIsPressed == true){
                        isFilterSelected += 1
                        curretFilter.append(Category.fuel.rawValue)
                        dataVM.expenseFilteredList = dataVM.expenseList.filter {curretFilter.contains(Int($0.category))}
                    }
                    else {
                        isFilterSelected -= 1
                        if let index = curretFilter.firstIndex(of: Category.fuel.rawValue){curretFilter.remove(at: index)}
                        dataVM.expenseFilteredList = dataVM.expenseList.filter { curretFilter.contains(Int($0.category))}
                    }
                    
                }
                .buttonStyle(FilterButton(isPressed: $fuelIsPressed))
                
                Button("Maintenance"){
                    impactMed.impactOccurred()
                    maintenanceIsPressed.toggle()
                    
                    
                    if(maintenanceIsPressed == true){
                        isFilterSelected += 1
                        curretFilter.append(Category.maintenance.rawValue)
                        dataVM.expenseFilteredList = dataVM.expenseList.filter { curretFilter.contains(Int($0.category))}
                    }
                    else {
                        isFilterSelected -= 1
                        if let index = curretFilter.firstIndex(of: Category.maintenance.rawValue){ curretFilter.remove(at: index) }
                        dataVM.expenseFilteredList = dataVM.expenseList.filter { curretFilter.contains(Int($0.category))}
                    }
                    
                }
                .buttonStyle(FilterButton(isPressed: $maintenanceIsPressed))
                
                Button("Tolls"){
                    impactMed.impactOccurred()
                    tollsIsPressed.toggle()
                    
                    if(tollsIsPressed == true){
                        isFilterSelected += 1
                        curretFilter.append(Category.tolls.rawValue)
                        dataVM.expenseFilteredList = dataVM.expenseList.filter { curretFilter.contains(Int($0.category))}
                    }
                    else {
                        isFilterSelected -= 1
                        if let index = curretFilter.firstIndex(of: Category.tolls.rawValue){ curretFilter.remove(at: index) }
                        dataVM.expenseFilteredList = dataVM.expenseList.filter { curretFilter.contains(Int($0.category))}
                    }
                }
                .buttonStyle(FilterButton(isPressed: $tollsIsPressed))
                
                
                Button("Insurance"){
                    impactMed.impactOccurred()
                    insuranceIsPressed.toggle()
                    if(insuranceIsPressed == true){
                        isFilterSelected += 1
                        curretFilter.append(Category.insurance.rawValue)
                        dataVM.expenseFilteredList = dataVM.expenseList.filter { curretFilter.contains(Int($0.category))}
                    }
                    else {
                        isFilterSelected -= 1
                        if let index = curretFilter.firstIndex(of: Category.insurance.rawValue){ curretFilter.remove(at: index) }
                        dataVM.expenseFilteredList = dataVM.expenseList.filter { curretFilter.contains(Int($0.category))}
                    }
                }
                .buttonStyle(FilterButton(isPressed: $insuranceIsPressed))
                
                Button("Road Tax"){
                    impactMed.impactOccurred()
                    roadTaxIsPressed.toggle()
                    if(roadTaxIsPressed == true){
                        isFilterSelected += 1
                        curretFilter.append(Category.roadTax.rawValue)
                        dataVM.expenseFilteredList = dataVM.expenseList.filter { curretFilter.contains(Int($0.category))}
                    }
                    else {
                        isFilterSelected -= 1
                        if let index = curretFilter.firstIndex(of: Category.roadTax.rawValue){ curretFilter.remove(at: index) }
                        dataVM.expenseFilteredList = dataVM.expenseList.filter { curretFilter.contains(Int($0.category))}
                    }
                }
                .buttonStyle(FilterButton(isPressed: $roadTaxIsPressed))
                
                Button("Fines"){
                    impactMed.impactOccurred()
                    finesIsPressed.toggle()
                    
                    if(finesIsPressed == true){
                        isFilterSelected += 1
                        curretFilter.append(Category.fines.rawValue)
                        dataVM.expenseFilteredList = dataVM.expenseList.filter { curretFilter.contains(Int($0.category))}
                    }
                    else {
                        isFilterSelected -= 1
                        if let index = curretFilter.firstIndex(of: Category.fines.rawValue){ curretFilter.remove(at: index) }
                        dataVM.expenseFilteredList = dataVM.expenseList.filter { curretFilter.contains(Int($0.category))}
                    }
                }
                .buttonStyle(FilterButton(isPressed: $finesIsPressed))
                
                Button("Parking"){
                    impactMed.impactOccurred()
                    parkingIsPressed.toggle()
                    if(parkingIsPressed == true){
                        isFilterSelected += 1
                        curretFilter.append(Category.parking.rawValue)
                        dataVM.expenseFilteredList = dataVM.expenseList.filter { curretFilter.contains(Int($0.category))}
                    }
                    else {
                        isFilterSelected -= 1
                        if let index = curretFilter.firstIndex(of: Category.parking.rawValue){ curretFilter.remove(at: index) }
                        dataVM.expenseFilteredList = dataVM.expenseList.filter { curretFilter.contains(Int($0.category))}
                    }
                }
                .buttonStyle(FilterButton(isPressed: $parkingIsPressed))
                
                Button("Other"){
                    impactMed.impactOccurred()
                    otherIsPressed.toggle()
                    if(otherIsPressed == true){
                        isFilterSelected += 1
                        curretFilter.append(Category.other.rawValue)
                        dataVM.expenseFilteredList = dataVM.expenseList.filter { curretFilter.contains(Int($0.category))}
                    }
                    else {
                        isFilterSelected -= 1
                        if let index = curretFilter.firstIndex(of: Category.other.rawValue){ curretFilter.remove(at: index) }
                        dataVM.expenseFilteredList = dataVM.expenseList.filter { curretFilter.contains(Int($0.category))}
                    }
                }
                .buttonStyle(FilterButton(isPressed: $otherIsPressed))
                
                
                
            }
            .padding(.leading)
            .padding(.top,25)
            .padding(.bottom,5)
        }
    }
}

struct FilterButton: ButtonStyle {
    
    @Binding var isPressed : Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .padding(.horizontal,7)
            .font(Typography.ControlS)
            .background(isPressed ? Palette.black : Palette.greyLight)
            .foregroundColor(isPressed ? Palette.white : Palette.black)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
