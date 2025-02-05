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
    case onboardingRegistration
    case onboardingMoreInfo(input: OnbVehicleInputData)
    case onboardingNotification
    case onboardingReady

    // Vehicle
    case reminderReport
    case fuelReport(input: FuelExpense)

    // Reminder
    case reminderList
    case editReminder(input: Binding<Reminder>)
    case expiredReminder(input: Binding<Reminder>)

    // Settings
    case tos
    case aboutUs
    case editVehicle(input: Vehicle)
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
        case (.onboardingRegistration, .onboardingRegistration):
            true
        case let (.onboardingMoreInfo(leftData), .onboardingMoreInfo(rightData)):
            leftData == rightData
        case (.onboardingNotification, .onboardingNotification):
            true
        case (.onboardingReady, .onboardingReady):
            true
        case (.reminderReport, .reminderReport):
            true
        case (.tos, .tos):
            true
        case let (.fuelReport(leftData), .fuelReport(rightData)):
            leftData == rightData
        case (.reminderList, .reminderList):
            true
        case let (.editReminder(leftData), .editReminder(rightData)):
            leftData.wrappedValue == rightData.wrappedValue
        case let (.expiredReminder(leftData), .expiredReminder(rightData)):
            leftData.wrappedValue == rightData.wrappedValue
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
            OnbWelcomeView()
        case .onboardingRegistration:
            OnbRegistrationView()
        case let .onboardingMoreInfo(vehicleData):
            OnbMoreInfoView(input: vehicleData)
        case .onboardingNotification:
            OnbNotificationView()
        case .onboardingReady:
            OnbReadyView()
        case .reminderReport:
            ReminderReportView()
        case let .fuelReport(fuelData):
            FuelReportView(fuelExpense: fuelData)
        case .reminderList:
            RemindersListView()
        case let .editReminder(input: reminder):
            EditReminderView(reminder: reminder)
        case let .expiredReminder(input: reminder):
            ExpiredReminderView(reminder: reminder)
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
