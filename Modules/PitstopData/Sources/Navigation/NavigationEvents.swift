//
//  NavigationEvents.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 29/04/25.
//

// Cross-feature navigation events. No View imports — safe to use in any feature.

public struct ShowOnboardingWelcomeEvent: Hashable {
    public init() {}
}

public struct ShowReminderCreateEvent: Hashable {
    public init() {}
}

public struct ShowAddVehicleEvent: Hashable {
    public init() {}
}
