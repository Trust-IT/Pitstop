// swiftlint:disable:this file_name
// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
// Generated using tuist — https://github.com/tuist/tuist

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
public enum PitstopAPPStrings: Sendable {

  public enum Category: Sendable {
  /// Fine
    public static let fines = PitstopAPPStrings.tr("Localizable", "category.fines")
    /// Insurance
    public static let insurance = PitstopAPPStrings.tr("Localizable", "category.insurance")
    /// Maintenance
    public static let maintenance = PitstopAPPStrings.tr("Localizable", "category.maintenance")
    /// Other
    public static let other = PitstopAPPStrings.tr("Localizable", "category.other")
    /// Parking
    public static let parking = PitstopAPPStrings.tr("Localizable", "category.parking")
    /// Road Tax
    public static let roadTax = PitstopAPPStrings.tr("Localizable", "category.roadTax")
    /// Toll
    public static let tolls = PitstopAPPStrings.tr("Localizable", "category.tolls")
  }

  public enum Common: Sendable {
  /// Add
    public static let add = PitstopAPPStrings.tr("Localizable", "common.add")
    /// Analytics
    public static let analytics = PitstopAPPStrings.tr("Localizable", "common.analytics")
    /// Attention
    public static let attention = PitstopAPPStrings.tr("Localizable", "common.attention")
    /// Cancel
    public static let cancel = PitstopAPPStrings.tr("Localizable", "common.cancel")
    /// Category
    public static let category = PitstopAPPStrings.tr("Localizable", "common.category")
    /// Day
    public static let day = PitstopAPPStrings.tr("Localizable", "common.day")
    /// Delete
    public static let delete = PitstopAPPStrings.tr("Localizable", "common.delete")
    /// Error
    public static let error = PitstopAPPStrings.tr("Localizable", "common.error")
    /// Expired
    public static let expired = PitstopAPPStrings.tr("Localizable", "common.expired")
    /// Future
    public static let future = PitstopAPPStrings.tr("Localizable", "common.future")
    /// Note
    public static let note = PitstopAPPStrings.tr("Localizable", "common.note")
    /// Odometer
    public static let odometer = PitstopAPPStrings.tr("Localizable", "common.odometer")
    /// Rename
    public static let rename = PitstopAPPStrings.tr("Localizable", "common.rename")
    /// Save
    public static let save = PitstopAPPStrings.tr("Localizable", "common.save")
    /// Settings
    public static let settings = PitstopAPPStrings.tr("Localizable", "common.settings")
    /// Title
    public static let title = PitstopAPPStrings.tr("Localizable", "common.title")
    /// This action cannot be undone
    public static let undone = PitstopAPPStrings.tr("Localizable", "common.undone")
    /// Untitled
    public static let untitled = PitstopAPPStrings.tr("Localizable", "common.untitled")
    /// Vehicle
    public static let vehicle = PitstopAPPStrings.tr("Localizable", "common.vehicle")
  }

  public enum Document: Sendable {
  /// Rename document
    public static let rename = PitstopAPPStrings.tr("Localizable", "document.rename")

    public enum Rename: Sendable {
    /// Title
      public static let placeholder = PitstopAPPStrings.tr("Localizable", "document.rename.placeholder")
    }
  }

  public enum Onb: Sendable {
  /// Activate notifications
    public static let activateNotifications = PitstopAPPStrings.tr("Localizable", "onb.activateNotifications")
    /// Add a new vehicle
    public static let addNewVehicle = PitstopAPPStrings.tr("Localizable", "onb.addNewVehicle")
    /// Add vehicle
    public static let addVehicle = PitstopAPPStrings.tr("Localizable", "onb.addVehicle")
    /// Brand
    public static let brand = PitstopAPPStrings.tr("Localizable", "onb.brand")
    /// Don’t miss anything important
    public static let dontMiss = PitstopAPPStrings.tr("Localizable", "onb.dontMiss")
    /// Fuel Type
    public static let fuelType = PitstopAPPStrings.tr("Localizable", "onb.fuelType")
    /// Gear up for a simple way of trackng your vehicle costs
    public static let gearUp = PitstopAPPStrings.tr("Localizable", "onb.gearUp")
    /// Hop in and insert some key details
    public static let hopIn = PitstopAPPStrings.tr("Localizable", "onb.hopIn")
    /// Later
    public static let later = PitstopAPPStrings.tr("Localizable", "onb.later")
    /// Model
    public static let model = PitstopAPPStrings.tr("Localizable", "onb.model")
    /// Add more info
    public static let moreInfo = PitstopAPPStrings.tr("Localizable", "onb.moreInfo")
    /// Next
    public static let next = PitstopAPPStrings.tr("Localizable", "onb.next")
    /// Previously 0 km
    public static let odometerPlaceholder = PitstopAPPStrings.tr("Localizable", "onb.odometerPlaceholder")
    /// Okayyyy let's go
    public static let okLetsGo = PitstopAPPStrings.tr("Localizable", "onb.okLetsGo")
    /// Plate number
    public static let plateNumber = PitstopAPPStrings.tr("Localizable", "onb.plateNumber")
    /// Let us remind you key dates about your vehicle’s maintenance status and deadlines
    public static let reminderInfo = PitstopAPPStrings.tr("Localizable", "onb.reminderInfo")
    /// Secondary fuel type
    public static let secondFuelType = PitstopAPPStrings.tr("Localizable", "onb.secondFuelType")
    /// Select a fuel type
    public static let selectFuelType = PitstopAPPStrings.tr("Localizable", "onb.selectFuelType")
    /// You are set to start your engine and optimize your spendings
    public static let startEngine = PitstopAPPStrings.tr("Localizable", "onb.startEngine")
    /// Keep all of your vehicle info at hand
    public static let vehicleInfo = PitstopAPPStrings.tr("Localizable", "onb.vehicleInfo")
    /// Vehicle name
    public static let vehicleName = PitstopAPPStrings.tr("Localizable", "onb.vehicleName")
    /// Your vehicle is ready!
    public static let vehicleReady = PitstopAPPStrings.tr("Localizable", "onb.vehicleReady")
    /// Vehicle registration
    public static let vehicleRegistration = PitstopAPPStrings.tr("Localizable", "onb.vehicleRegistration")
    /// Warm up your engine
    public static let warmUpEngine = PitstopAPPStrings.tr("Localizable", "onb.warmUpEngine")
    /// Write the odometer
    public static let writeOdometer = PitstopAPPStrings.tr("Localizable", "onb.writeOdometer")
    /// Write the plate number
    public static let writePlate = PitstopAPPStrings.tr("Localizable", "onb.writePlate")
  }

  public enum Reminder: Sendable {
  /// Clear expired reminder
    public static let clear = PitstopAPPStrings.tr("Localizable", "reminder.clear")
    /// Clear all expired reminders
    public static let clearAll = PitstopAPPStrings.tr("Localizable", "reminder.clearAll")
    /// Are you sure you want to delete this reminder?
    public static let delete = PitstopAPPStrings.tr("Localizable", "reminder.delete")
    /// There are no rmeinders now
    public static let empty = PitstopAPPStrings.tr("Localizable", "reminder.empty")
    /// Enable the notifications in the settings before creating a reminder
    public static let enableNotification = PitstopAPPStrings.tr("Localizable", "reminder.enableNotification")
    /// New reminder
    public static let new = PitstopAPPStrings.tr("Localizable", "reminder.new")
    /// Reminders
    public static let title = PitstopAPPStrings.tr("Localizable", "reminder.title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension PitstopAPPStrings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = Bundle.module.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
// swiftlint:enable all
// swiftformat:enable all
