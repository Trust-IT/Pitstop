import OSLog

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.pitstop"

    static let navigation = Logger(subsystem: subsystem, category: "navigation")
    static let manager = Logger(subsystem: subsystem, category: "manager")
    static let persistence = Logger(subsystem: subsystem, category: "persistence")
    static let notifications = Logger(subsystem: subsystem, category: "notifications")
}
