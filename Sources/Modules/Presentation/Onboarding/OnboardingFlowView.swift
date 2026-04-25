//
//  OnboardingFlowView.swift
//  Pitstop-APP
//

import OSLog
import SwiftData
import SwiftUI

enum OnboardingPage: Equatable {
    case welcome
    case registration
    case moreInfo
    case notification
    case ready
}

struct OnboardingFlowView: View {
    @EnvironmentObject private var navManager: NavigationManager
    @Environment(VehicleManager.self) private var vehicleManager
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    @AppStorage("shouldShowOnboarding") private var shouldShowOnboarding: Bool = true

    let pages: [OnboardingPage]
    var isDismissible: Bool = false

    @State private var currentPage: Int = 0
    @State private var inputData = OnboardingVehicleInputData()
    @State private var plate: String = ""
    @State private var odometer: Int = 0
    @State private var isVehicleCreated: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                    pageView(for: page)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .never))
            .tint(appState.currentTheme.accentColor)
            .highPriorityGesture(
                DragGesture()
                    .onEnded { value in
                        let isForward = value.translation.width < -50
                        let isBackward = value.translation.width > 50
                        if isForward, canAdvance(from: currentPage), currentPage < pages.count - 1 {
                            withAnimation(.easeInOut) { currentPage += 1 }
                        } else if isBackward, currentPage > minimumAllowedPage {
                            withAnimation(.easeInOut) { currentPage -= 1 }
                        }
                    }
            )

            ctaButtons
        }
        .background(Palette.greyBackground)
        .toolbar {
            if isDismissible {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { navManager.popAll() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Palette.black)
                    }
                    .buttonStyle(.glass)
                }
            }
        }
    }

    @ViewBuilder
    private var ctaButtons: some View {
        VStack(spacing: 16) {
            if currentPage < pages.count, pages[currentPage] == .notification {
                Button(action: {
                    Task {
                        do {
                            _ = try await NotificationManager.shared.requestAuthNotifications()
                        } catch {
                            Logger.notifications.error("Error requesting notifications: \(error)")
                        }
                    }
                    advance()
                }) {
                    Text(PitstopStrings.Localizable.Onb.activateNotifications)
                }
                .buttonStyle(Primary())

                Button(action: advance) {
                    Text(PitstopStrings.Localizable.Onb.later)
                }
                .buttonStyle(Secondary())
            } else {
                Button(action: primaryAction) {
                    Text(primaryLabel)
                }
                .buttonStyle(Primary())
                .disabled(!canAdvance(from: currentPage))
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 32)
        .padding(.top, 8)
    }

    @ViewBuilder
    private func pageView(for page: OnboardingPage) -> some View {
        switch page {
        case .welcome:
            OnboardingWelcomeView()
        case .registration:
            OnboardingVehicleRegistrationView(inputData: $inputData)
        case .moreInfo:
            OnboardingVehicleDetailsView(plate: $plate, odometer: $odometer)
        case .notification:
            OnboardingNotificationPermissionView()
        case .ready:
            OnboardingVehicleReadyView()
        }
    }

    private var primaryLabel: String {
        guard currentPage < pages.count else { return PitstopStrings.Localizable.Onb.next }
        switch pages[currentPage] {
        case .moreInfo: return PitstopStrings.Localizable.Onb.addVehicle
        case .ready: return PitstopStrings.Localizable.Onb.okLetsGo
        default: return PitstopStrings.Localizable.Onb.next
        }
    }

    private func primaryAction() {
        guard currentPage < pages.count else { return }
        switch pages[currentPage] {
        case .moreInfo:
            addVehicle()
            advance()
        case .ready:
            complete()
        default:
            advance()
        }
    }

    private var minimumAllowedPage: Int {
        guard isVehicleCreated, let moreInfoIndex = pages.firstIndex(of: .moreInfo) else { return 0 }
        return moreInfoIndex + 1
    }

    private func canAdvance(from index: Int) -> Bool {
        guard index < pages.count else { return false }
        return pages[index] != .registration || !inputData.isEmpty()
    }

    private func advance() {
        withAnimation(.easeInOut) {
            currentPage = min(currentPage + 1, pages.count - 1)
        }
    }

    private func complete() {
        shouldShowOnboarding = false
        navManager.popAll()
    }

    private func addVehicle() {
        let vehicle = Vehicle(
            brand: inputData.brand,
            model: inputData.model,
            mainFuelType: inputData.fuelType,
            initialOdometer: odometer,
            plate: plate
        )
        do {
            try vehicle.saveToModelContext(context: modelContext)
        } catch {
            Logger.persistence.error("Onboarding add vehicle: \(error)")
        }
        vehicleManager.setCurrentVehicle(vehicle, modelContext: modelContext)
        isVehicleCreated = true
    }
}
