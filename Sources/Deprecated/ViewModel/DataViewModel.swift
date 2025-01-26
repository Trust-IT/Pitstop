
import CoreData
import Foundation

enum VehicleError: Error {
    case VehicleNotFound
}

// swiftlint:disable type_body_length

class DataViewModel: ObservableObject {
    // Expense
    @Published var expenseList: [ExpenseViewModel] = []

    // Filter
    @Published var filter: NSPredicate?
    //    @Published var filterCurrentExpense : NSPredicate?

    @Published var totalVehicleCost: Float = 0.0
    @Published var totalExpense: Float = 0.0
    @Published var monthsAmount: Set<String> = []
    @Published var totalMonthExpense: [Float] = []

    @Published var expenseFilteredList: [ExpenseViewModel] = []

    init() {}

    func save() {
//        manager.save()
    }

    // MARK: - EXPENSE CRUD

    // MARK: EXPENSE UPDATE

    // MARK: EXPENSE DELETE

    func removeAllExpenses() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Expense")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        manager.removeAllItems(deleteRequest: deleteRequest)
    }

    // MARK: - OTHER FUNCS

    func getTotalExpense(expenses: [ExpenseViewModel]) {
        //        print("expense list: \(expenses)")
        totalVehicleCost = 0.0
        for expense in expenses {
            totalVehicleCost += expense.price
        }
        print("sum cost : \(totalVehicleCost)")
        totalExpense = totalVehicleCost
    }

    func getMonths(expenses _: [ExpenseViewModel]) {
        var date = ""
        for expenseList in expenseList {
            date = expenseList.date.toString(dateFormat: "MMMM")
            monthsAmount.insert(date)
        }
    }

    func getMonthsExpense(expenses: [ExpenseViewModel], month: String) -> Float {
        var totalExpense: Float = 0.0
        for expense in expenses {
            if expense.date.toString(dateFormat: "MMMM") == month {
                totalExpense += expense.price
            }
        }
        return totalExpense
    }
}
