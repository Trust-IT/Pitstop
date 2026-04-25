//
//  Route.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 16/01/25.
//

import SwiftUI

enum Route {
    // Onboarding
    case onboardingWelcome
    case onboardingAddVehicle

    // Vehicle
    case reminderReport(input: Reminder, isEdit: Bool)
    case fuelReport(input: FuelExpense)

    // Reminder
    case reminderList
    case expiredReminder(input: Reminder)

    // Documents
    case docScanner

    // Settings
    case tos
    case aboutUs
    case editVehicle(input: Vehicle)
}

extension Route: Identifiable {
    var id: UUID { UUID() } // TODO: CHECK IF IT IS VALID
}

extension Route: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(hashValue)
    }
}

extension Route: Equatable {
    static func == (lhs: Route, rhs: Route) -> Bool {
        switch (lhs, rhs) {
        case (.onboardingWelcome, .onboardingWelcome):
            true
        case (.onboardingAddVehicle, .onboardingAddVehicle):
            true
        case let (.reminderReport(leftInput, leftIsEdit),
                  .reminderReport(rightInput, rightIsEdit)):
            leftInput == rightInput && leftIsEdit == rightIsEdit
        case (.tos, .tos):
            true
        case let (.fuelReport(leftData), .fuelReport(rightData)):
            leftData == rightData
        case (.reminderList, .reminderList):
            true
        case let (.expiredReminder(leftData), .expiredReminder(rightData)):
            leftData == rightData
        case (.aboutUs, .aboutUs):
            true
        case let (.editVehicle(leftData), .editVehicle(rightData)):
            leftData == rightData
        default:
            false
        }
    }
}

extension Route: View {
    var body: some View {
        switch self {
        case .onboardingWelcome:
            OnboardingFlowView(pages: [.welcome, .registration, .moreInfo, .notification, .ready])
        case .onboardingAddVehicle:
            OnboardingFlowView(pages: [.welcome, .registration, .moreInfo, .ready], isDismissible: true)
        case let .reminderReport(reminder, isEdit):
            ReminderReportView(reminder: reminder, isEditMode: isEdit)
        case let .fuelReport(fuelData):
            FuelReportView(fuelExpense: fuelData)
        case .reminderList:
            RemindersListView()
        case let .expiredReminder(input: reminder):
            ExpiredReminderView(reminder: reminder)
        case .docScanner:
            DocumentScannerView()
        case .tos:
            HTMLView(htmlFileName: "TermsOfService")
        case .aboutUs:
            AboutView()
        case let .editVehicle(input: vehicleData):
            EditVehicleView(vehicle: vehicleData)
        default:
            EmptyView()
        }
    }
}
