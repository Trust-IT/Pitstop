//
//  CategoryViewModel.swift
//  Hurricane
//
//  Created by Asya Tealdi on 15/05/22.
//

import CoreData
import Foundation
import SwiftUI

class CategoryViewModel: ObservableObject {
    @Published var categories = [Category2]()

    @Published var currentPickerTab: String = .init(localized: "Overview")

    @Published var arrayCat: [Category] = []

    @Published var selectedCategory: Int16 = .init(Category.fuel.rawValue)

    @Published var fuelTotal: Float = 0.0
    @Published var maintenanceTotal: Float = 0.0
    @Published var insuranceTotal: Float = 0.0
    @Published var tollsTotal: Float = 0.0
    @Published var roadTaxTotal: Float = 0.0
    @Published var finesTotal: Float = 0.0
    @Published var parkingTotal: Float = 0.0
    @Published var otherTotal: Float = 0.0

    @Published var fuelList = [ExpenseViewModel]()
    @Published var maintenanceList = [ExpenseViewModel]()
    @Published var insuranceList = [ExpenseViewModel]()
    @Published var tollsList = [ExpenseViewModel]()
    @Published var roadTaxList = [ExpenseViewModel]()
    @Published var finesList = [ExpenseViewModel]()
    @Published var parkingList = [ExpenseViewModel]()
    @Published var otherList = [ExpenseViewModel]()

    @Published var filter: NSPredicate?
    @Published var expenseList: [ExpenseViewModel] = []
    @Published var totalExpense: Float = 0.0

    @Published var refuelsPerTime: Int = 0
    @Published var avgDaysRefuel: Int = 0
    @Published var avgPrice: Int = 0

    @Published var currentOdometer: Double = 0
    @Published var odometerTimeTotal: Double = 0
    var avgOdometer: Float = 0
    var odometerTotal: Float = 0
    var estimatedOdometerPerYear: Float = 0
    var literDiff: Float = 0
    @Published var fuelEff: Float = 0

    @Published var taxesCost: Float = 0
    @Published var otherCost: Float = 0

    var fuelPercentage: Float = 0
    var taxesPercentage: Float = 0
    var maintainancePercentage: Float = 0
    var otherPercentage: Float = 0

    var fuelGraphData: [CGFloat] = []
    var odometerGraphData: [CGFloat] = []

    @Published var selectedTimeFrame = String(localized: "Per month")
    let timeFrames = [String(localized: "Per month"), String(localized: "Per 3 months"), String(localized: "Per year"), String(localized: "All time")]

    init() {
        print("categoryVM recreating")
    }

    var defaultCategory: Category {
        get { Category(rawValue: Int(selectedCategory)) ?? .other }
        set { selectedCategory = Int16(newValue.rawValue) }
    }

    func setSelectedTimeFrame(timeFrame: String) {
        selectedTimeFrame = timeFrame
        print("selected time frame \(selectedTimeFrame)")
    }

    // Function to calculate total cost of a category
    static func totalCategoryCost(categoryList: [ExpenseViewModel]) -> Float {
        let fetchedCost = categoryList.map { ExpenseViewModel -> Float in
            ExpenseViewModel.price
        }
        //        print("fetched cost :\(fetchedCost)")
        let totalCost = fetchedCost.reduce(0, +)
        return totalCost
    }

    //    Takes current expense list and filters through the given category
    static func getExpensesCategoryList(expensesList: [ExpenseViewModel], category: Int16) -> [ExpenseViewModel] {
        var categoryList: [ExpenseViewModel]
        categoryList = expensesList.filter { expense in
            expense.category == category
        }
        return categoryList
    }

    // Function to add or subtract month from current date.
    func addOrSubtractMonths(month: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: month, to: Date())!
    }

    func calculateTimeFrame(timeFrame: String) -> Int {
        var monthSub: Int {
            if timeFrame == String(localized: "Per month") {
                -1
            } else if timeFrame == String(localized: "Per 3 months") {
                -3
            } else if timeFrame == String(localized: "Per year") {
                -12
            } else {
                0
            }
        }
        return monthSub
    }

    func calculateDays(timeFrame: String) -> Int {
        var Days: Int {
            if timeFrame == String(localized: "Per month") {
                30
            } else if timeFrame == String(localized: "Per 3 months") {
                90
            } else if timeFrame == String(localized: "Per year") {
                365
            } else {
                0
            }
        }
        return Days
    }

    // MARK: Fuel, remember to insert a time frame property to pass

    // Fuel Efficiency, every 100 km

    func getFuelEfficiency(timeFrame: String, fuelList _: [ExpenseViewModel]) {
        let time = calculateTimeFrame(timeFrame: timeFrame)
        let timeSubMonth = addOrSubtractMonths(month: time)

        var expenseListTime = expenseList.filter { expense in
            expense.date > timeSubMonth
        }
        expenseListTime.sort { expenseOne, expenseTwo in
            expenseOne.date > expenseTwo.date
        }
        let literArray = expenseListTime.map { expense in
            expense.liters
        }
        print("lierarray \(literArray)")
        let literSum = literArray.reduce(0, +)
        literDiff = literSum - Float(expenseListTime.last?.liters ?? 0.0)
        print("liter sum \(literSum)")
        let q = odometerTotal / 100
        print("q is \(q)")
        if q != 0.0 {
            fuelEff = literSum / q
        } else {
            fuelEff = q
        }
        print("fuel efficiency \(fuelEff)")

        // self.odometerTotal
    }

    // Refuel x month, from fuelExpenseList filter those who are in the time frame -> perform count

    func getRefuel(timeFrame: String, fuelList: [ExpenseViewModel]) {
        print("current time frame is \(selectedTimeFrame)")
        print("time frame is \(timeFrame)")
        let monthSub = calculateTimeFrame(timeFrame: timeFrame)
        if monthSub != 0 {
            let monthSubtractedDate = addOrSubtractMonths(month: monthSub)

            let monthFuels = fuelList.filter { refuel in
                refuel.date > monthSubtractedDate
            }

            refuelsPerTime = monthFuels.count
            print(refuelsPerTime)
        } else {
            refuelsPerTime = fuelList.count
        }
    }

    // Average days/refuel, map through fuelExpenseList and return days between 2 fuel expenses in a new array -> calculate avg value

    func getAverageDaysRefuel(timeFrame _: String, fuelList: [ExpenseViewModel]) {
        let dateArray = fuelList.map { ExpenseViewModel -> Date in
            ExpenseViewModel.date
        }

        var daysDiff = [TimeInterval]()
        for (index, date) in dateArray.enumerated() {
            if date != dateArray.last {
                daysDiff.append(Date.timeDifference(lhs: date, rhs: dateArray[index + 1]))
            }
        }
        let daysDiffInt = daysDiff.map { sec in
            // absolute abs floor sec / 86400 // dividi la differenza per giorni
            Int(floor(abs(sec / 86400)))
        }
        print("date array\(daysDiffInt)")

        avgDaysRefuel = (daysDiffInt.reduce(0, +)) / daysDiffInt.count
        print("avg days : \(avgDaysRefuel)")
    }

    // Average price x liter, map through fuel list and return prices in a new array -> calculate avg value ------ DA TESTARE

    func getAveragePrice(timeFrame _: String, fuelList: [ExpenseViewModel]) {
        let priceArray = fuelList.map { expense in
            expense.price
        }
        let literArray = fuelList.map { expense in
            expense.liters
        }
        print("price array : \(priceArray)")
        if literArray.reduce(0, +) != 0 {
            avgPrice = Int(priceArray.reduce(0, +)) / Int(literArray.reduce(0, +))
        }
    }

    // MARK: Odometer, remember to insert a time frame property

    // Average, take odometer and the last one within time frame, sub and divide it by the given time -> calculate avg

    func getAverageOdometer(expenseList: [ExpenseViewModel], timeFrame: String) {
        let monthSub = calculateTimeFrame(timeFrame: timeFrame)
        let monthSubtractedDate = addOrSubtractMonths(month: monthSub)

        var expenseListTime = expenseList.filter { expense in
            expense.date > monthSubtractedDate
        }
        expenseListTime.sort { expenseOne, expenseTwo in
            expenseOne.date > expenseTwo.date
        }
        odometerTotal = Float(expenseListTime.first?.odometer ?? 0.0) - Float(expenseListTime.last?.odometer ?? 0.0)
        print("odometer difference : \(odometerTotal)")

        let days = calculateDays(timeFrame: timeFrame)
        avgOdometer = odometerTotal / Float(days)
    }

    // Estimated km/year takes odometer data from time frame, makes an average -> multiply for 12/ 4 / 1 based on time frame

    func getEstimatedOdometerPerYear(timeFrame _: String) {
        //        let days = calculateDays(timeFrame: timeFrame)
        estimatedOdometerPerYear = avgOdometer * Float(365)
    }

    func totalCostPercentage(totalCost: Float, expenseList _: [ExpenseViewModel]) {
        fuelPercentage = (fuelTotal / totalCost) * 100
        taxesPercentage = ((insuranceTotal + roadTaxTotal + finesTotal + tollsTotal) / totalCost) * 100
        maintainancePercentage = (maintenanceTotal / totalCost) * 100
        otherPercentage = ((otherTotal + parkingTotal) / totalCost) * 100
    }

    func getTotalExpense(expenses: [ExpenseViewModel]) {
        totalExpense = 0.0
        for expense in expenses {
            totalExpense += expense.price
        }
        print("sum cost : \(totalExpense)")
        totalExpense = totalExpense
    }

    func getLitersData(expenses: [ExpenseViewModel]) {
        let litersArray = expenses.map { expense -> Float in
            expense.liters
        }
        print("liters array: \(litersArray)")
        let liters = litersArray.filter { liter in
            liter > 0
        }
        print("liter are \(liters)")

        fuelGraphData = liters.map { liter in
            CGFloat(liter)
        }
    }

    func getOdometersData(expenses: [ExpenseViewModel]) {
        let odometerArray = expenses.map { expense in
            expense.odometer
        }
        let odometers = odometerArray.filter { odometer in
            odometer > 0
        }
        print("odometer array is \(odometerArray)")
        odometerGraphData = odometers.map { odometer in
            CGFloat(odometer)
        }
    }

    func assignCategories(expenseList _: [ExpenseViewModel]) {
        fuelList = CategoryViewModel.getExpensesCategoryList(expensesList: expenseList, category: 8)
        maintenanceList = CategoryViewModel.getExpensesCategoryList(expensesList: expenseList, category: 1)
        insuranceList = CategoryViewModel.getExpensesCategoryList(expensesList: expenseList, category: 2)
        roadTaxList = CategoryViewModel.getExpensesCategoryList(expensesList: expenseList, category: 3)
        tollsList = CategoryViewModel.getExpensesCategoryList(expensesList: expenseList, category: 4)
        finesList = CategoryViewModel.getExpensesCategoryList(expensesList: expenseList, category: 5)
        parkingList = CategoryViewModel.getExpensesCategoryList(expensesList: expenseList, category: 6)
        otherList = CategoryViewModel.getExpensesCategoryList(expensesList: expenseList, category: 7)

        fuelTotal = CategoryViewModel.totalCategoryCost(categoryList: fuelList)
        maintenanceTotal = CategoryViewModel.totalCategoryCost(categoryList: maintenanceList)
        insuranceTotal = CategoryViewModel.totalCategoryCost(categoryList: insuranceList)
        tollsTotal = CategoryViewModel.totalCategoryCost(categoryList: tollsList)
        roadTaxTotal = CategoryViewModel.totalCategoryCost(categoryList: roadTaxList)
        finesTotal = CategoryViewModel.totalCategoryCost(categoryList: finesList)
        parkingTotal = CategoryViewModel.totalCategoryCost(categoryList: parkingList)
        otherTotal = CategoryViewModel.totalCategoryCost(categoryList: otherList)

        categories = [Category2(name: String(localized: "Fuel"), color: Palette.colorYellow, icon: .fuelType, totalCosts: fuelTotal),
                      Category2(name: String(localized: "Maintenance"), color: Palette.colorGreen, icon: .wrench, totalCosts: maintenanceTotal),
                      Category2(name: String(localized: "Insurance"), color: Palette.colorOrange, icon: .insurance, totalCosts: insuranceTotal),
                      Category2(name: String(localized: "Road tax"), color: Palette.colorOrange, icon: .roadTax, totalCosts: roadTaxTotal),
                      Category2(name: String(localized: "Fines"), color: Palette.colorOrange, icon: .fines, totalCosts: finesTotal),
                      Category2(name: String(localized: "Tolls"), color: Palette.colorOrange, icon: .tolls, totalCosts: tollsTotal),
                      Category2(name: String(localized: "Parking"), color: Palette.colorViolet, icon: .parking, totalCosts: parkingTotal),
                      Category2(name: String(localized: "Other"), color: Palette.colorViolet, icon: .other, totalCosts: otherTotal)]
    }

    func retrieveAndUpdate(vehicleID: NSManagedObjectID) {
        expenseList = []
        avgOdometer = 0
        odometerTotal = 0
        estimatedOdometerPerYear = 0
        let filterCurrentExpense = NSPredicate(format: "vehicle = %@", vehicleID)
        getExpensesCoreData(filter: filterCurrentExpense, storage: { storage in
            self.expenseList = storage
            self.assignCategories(expenseList: storage)
            self.getRefuel(timeFrame: self.selectedTimeFrame, fuelList: self.fuelList)

            if self.fuelList.count >= 2 {
                self.getAverageOdometer(expenseList: self.expenseList, timeFrame: self.selectedTimeFrame)
                self.getEstimatedOdometerPerYear(timeFrame: self.selectedTimeFrame)

                self.getAverageDaysRefuel(timeFrame: self.selectedTimeFrame, fuelList: self.fuelList)
                self.getAveragePrice(timeFrame: self.selectedTimeFrame, fuelList: self.fuelList)
            }
            self.getFuelEfficiency(timeFrame: self.selectedTimeFrame, fuelList: self.fuelList)
            self.getTotalExpense(expenses: self.expenseList)
            self.totalCostPercentage(totalCost: self.totalExpense, expenseList: self.expenseList)
            self.getLitersData(expenses: self.expenseList)
            self.getOdometersData(expenses: self.expenseList)
        })
    }

    func getExpensesCoreData(filter: NSPredicate?, storage _: @escaping ([ExpenseViewModel]) -> Void) {
        let request = NSFetchRequest<Expense>(entityName: "Expense")
        let expense: [Expense]

        let sort = NSSortDescriptor(keyPath: \Expense.objectID, ascending: true)
        request.sortDescriptors = [sort]
        request.predicate = filter
    }
}

enum Category: Int, Hashable {
    case maintenance = 1
    case insurance = 2
    case roadTax = 3
    case tolls = 4
    case fines = 5
    case parking = 6
    case other = 7
    case fuel = 8
}

extension Category: CaseIterable {
    var label: String {
        switch self {
        case .fuel:
            NSLocalizedString("Fuel", comment: "")
        case .maintenance:
            NSLocalizedString("Maintenance", comment: "")
        case .insurance:
            NSLocalizedString("Insurance", comment: "")
        case .roadTax:
            NSLocalizedString("Road tax", comment: "")
        case .tolls:
            NSLocalizedString("Tolls", comment: "")
        case .fines:
            NSLocalizedString("Fines", comment: "")
        case .parking:
            NSLocalizedString("Parking", comment: "")
        case .other:
            NSLocalizedString("Other", comment: "")
        }
    }

    var icon: ImageResource {
        switch self {
        case .fuel:
            .fuel
        case .maintenance:
            .wrench
        case .insurance:
            .insurance
        case .roadTax:
            .roadTax
        case .tolls:
            .tolls
        case .fines:
            .fines
        case .parking:
            .parking
        case .other:
            .other
        }
    }

    var color: Color {
        switch self {
        case .fuel:
            Palette.colorYellow
        case .maintenance:
            Palette.colorGreen
        case .insurance:
            Palette.colorOrange
        case .roadTax:
            Palette.colorOrange
        case .tolls:
            Palette.colorOrange
        case .fines:
            Palette.colorOrange
        case .parking:
            Palette.colorViolet
        case .other:
            Palette.colorViolet
        }
    }
}

struct Category2: Hashable {
    var name: String
    var color: Color
    var icon: ImageResource
    var totalCosts: Float
}

enum CategoryEnum {
    case maintenance
    case fuel
    case insurance
}

extension Date {
    static func timeDifference(lhs: Date, rhs: Date) -> TimeInterval {
        lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
