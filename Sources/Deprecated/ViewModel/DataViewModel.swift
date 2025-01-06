
import CoreData
import Foundation

enum VehicleError: Error {
    case VehicleNotFound
}

// swiftlint:disable type_body_length

class DataViewModel: ObservableObject {
    let manager = CoreDataManager.instance

    // Expense
    @Published var expenseList: [ExpenseViewModel] = []
    @Published var expenses: [Expense] = []
    @Published var expenseModel = ExpenseState()

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
        manager.save()
    }

    // MARK: - EXPENSE CRUD

    func getExpenseByID(expenseID: NSManagedObjectID) throws -> ExpenseViewModel {
        guard let expense = manager.getExpenseById(id: expenseID) else {
            throw VehicleError.VehicleNotFound // DA FIXARE
        }

        let expenseVM = ExpenseViewModel(expense: expense)
        return expenseVM
    }

    func addExpense(expense: ExpenseState) {
        let newExpense = Expense(context: manager.context)
        var newOdometer: Float = 0.0
        newExpense.note = expense.note
        newExpense.price = expense.price
        newExpense.odometer = expense.odometer
        newExpense.category = expense.category ?? 0
        newExpense.date = expense.date
        newExpense.fuelType = expense.fuelType ?? 0
        newExpense.liters = expense.liters ?? 0.0
        newExpense.priceLiter = expense.priceLiter ?? 1.0
        print(" Expense : \(newExpense)")
        expenseList.append(ExpenseViewModel(expense: newExpense))
        save()
    }

    // MARK: EXPENSE UPDATE

    func updateExpense(_ es: ExpenseState) throws {
        guard let expenseID = es.expenseID else {
            return print("Expense ID not found during update")
        }

        guard let expense = manager.getExpenseById(id: expenseID) else {
            return print("Expense not found during update")
        }

        expense.price = es.price
        expense.odometer = es.price
        expense.date = es.date
        expense.odometer = es.odometer
        expense.priceLiter = es.priceLiter ?? 0.0
        expense.fuelType = es.fuelType ?? 7
        expense.liters = es.liters ?? 0.0
        expense.category = es.category ?? 8
        expense.note = es.note

        // PUBLISHED LIST UPDATE
        for (index, value) in expenseList.enumerated() {
            if value.expenseID == es.expenseID {
                expenseList.remove(at: index)
                expenseList.insert(ExpenseViewModel(expense: expense), at: index)
            }
        }

        save()
        print("EXPENSE UPDATE DONE")
    }

    // MARK: EXPENSE DELETE

    //    func removeExpense(indexSet: IndexSet) {
    //        guard let index = indexSet.first else { return }
    //        let entity = expenses[index]
    //        expense
    //    }

    //    func deleteExpense(at indexSet: IndexSet){
    //        indexSet.forEach{ index in
    //            let expense = expenseList[index]
    //            expenseList.remove(at: index)
    //            deleteExpenseCoreData(expense: expense)
    //        }
    //    }

    //    func deleteExpenseCoreData(expense : ExpenseViewModel) {
    //        let expense = manager.getExpenseById(id: expense.expenseID)
    //        if let expense = expense {
    //            manager.deleteExpense(expense)
    //        }
    //        save()
    //    }

    func deleteExpense(expenseS: ExpenseState) {
        guard let expenseID = expenseS.expenseID else {
            return print("Expense ID not found during update")
        }

        let expense = manager.getExpenseById(id: expenseID)
        if let expense {
            manager.deleteExpense(expense)
        }
        save()
    }

    func removeAllExpenses() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Expense")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        manager.removeAllItems(deleteRequest: deleteRequest)
    }

    func getExpensesCoreData(filter: NSPredicate?, storage: @escaping ([ExpenseViewModel]) -> Void) {
        let request = NSFetchRequest<Expense>(entityName: "Expense")
        let expense: [Expense]

        let sort = NSSortDescriptor(keyPath: \Expense.objectID, ascending: true)
        request.sortDescriptors = [sort]
        request.predicate = filter

        do {
            expense = try manager.context.fetch(request)
            DispatchQueue.main.async {
                storage(expense.map(ExpenseViewModel.init))
            }

        } catch {
            print("💰 Error fetching expenses: \(error.localizedDescription)")
        }
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

    func addNewExpensePriceToTotal(expense: ExpenseState) {
        totalExpense += expense.price
        print("Add new expense")
    }
}

extension Date {
    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
