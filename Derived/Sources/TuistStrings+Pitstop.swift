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
public enum PitstopStrings: Sendable {
  public enum InfoPlist {
  /// I permessi della fotocamera sono necessari per scannerizzare i documenti
    public static let nsCameraUsageDescription = PitstopStrings.tr("InfoPlist", "NSCameraUsageDescription")
    /// Resta aggiornato sulle scadenze e sullo stato di manutenzione del tuo veicolo
    public static let nsUserNotificationsUsageDescription = PitstopStrings.tr("InfoPlist", "NSUserNotificationsUsageDescription")
  }
  public enum Localizable {

    public enum Category: Sendable {
    /// Fine
      public static let fines = PitstopStrings.tr("Localizable", "category.fines")
      /// Insurance
      public static let insurance = PitstopStrings.tr("Localizable", "category.insurance")
      /// Maintenance
      public static let maintenance = PitstopStrings.tr("Localizable", "category.maintenance")
      /// Other
      public static let other = PitstopStrings.tr("Localizable", "category.other")
      /// Parking
      public static let parking = PitstopStrings.tr("Localizable", "category.parking")
      /// Road Tax
      public static let roadTax = PitstopStrings.tr("Localizable", "category.roadTax")
      /// Toll
      public static let tolls = PitstopStrings.tr("Localizable", "category.tolls")
    }

    public enum Common: Sendable {
    /// Add
      public static let add = PitstopStrings.tr("Localizable", "common.add")
      /// Analytics
      public static let analytics = PitstopStrings.tr("Localizable", "common.analytics")
      /// Attention
      public static let attention = PitstopStrings.tr("Localizable", "common.attention")
      /// Cancel
      public static let cancel = PitstopStrings.tr("Localizable", "common.cancel")
      /// Category
      public static let category = PitstopStrings.tr("Localizable", "common.category")
      /// Day
      public static let day = PitstopStrings.tr("Localizable", "common.day")
      /// Delete
      public static let delete = PitstopStrings.tr("Localizable", "common.delete")
      /// Error
      public static let error = PitstopStrings.tr("Localizable", "common.error")
      /// Expired
      public static let expired = PitstopStrings.tr("Localizable", "common.expired")
      /// Future
      public static let future = PitstopStrings.tr("Localizable", "common.future")
      /// Note
      public static let note = PitstopStrings.tr("Localizable", "common.note")
      /// Odometer
      public static let odometer = PitstopStrings.tr("Localizable", "common.odometer")
      /// Rename
      public static let rename = PitstopStrings.tr("Localizable", "common.rename")
      /// Save
      public static let save = PitstopStrings.tr("Localizable", "common.save")
      /// Settings
      public static let settings = PitstopStrings.tr("Localizable", "common.settings")
      /// Title
      public static let title = PitstopStrings.tr("Localizable", "common.title")
      /// This action cannot be undone
      public static let undone = PitstopStrings.tr("Localizable", "common.undone")
      /// Untitled
      public static let untitled = PitstopStrings.tr("Localizable", "common.untitled")
      /// Vehicle
      public static let vehicle = PitstopStrings.tr("Localizable", "common.vehicle")
    }

    public enum Document: Sendable {
    /// Rename document
      public static let rename = PitstopStrings.tr("Localizable", "document.rename")

      public enum Rename: Sendable {
      /// Title
        public static let placeholder = PitstopStrings.tr("Localizable", "document.rename.placeholder")
      }
    }

    public enum Onb: Sendable {
    /// Activate notifications
      public static let activateNotifications = PitstopStrings.tr("Localizable", "onb.activateNotifications")
      /// Add a new vehicle
      public static let addNewVehicle = PitstopStrings.tr("Localizable", "onb.addNewVehicle")
      /// Add vehicle
      public static let addVehicle = PitstopStrings.tr("Localizable", "onb.addVehicle")
      /// Brand
      public static let brand = PitstopStrings.tr("Localizable", "onb.brand")
      /// Don’t miss anything important
      public static let dontMiss = PitstopStrings.tr("Localizable", "onb.dontMiss")
      /// Fuel Type
      public static let fuelType = PitstopStrings.tr("Localizable", "onb.fuelType")
      /// Gear up for a simple way of trackng your vehicle costs
      public static let gearUp = PitstopStrings.tr("Localizable", "onb.gearUp")
      /// Hop in and insert some key details
      public static let hopIn = PitstopStrings.tr("Localizable", "onb.hopIn")
      /// Later
      public static let later = PitstopStrings.tr("Localizable", "onb.later")
      /// Model
      public static let model = PitstopStrings.tr("Localizable", "onb.model")
      /// Add more info
      public static let moreInfo = PitstopStrings.tr("Localizable", "onb.moreInfo")
      /// Next
      public static let next = PitstopStrings.tr("Localizable", "onb.next")
      /// Previously 0 km
      public static let odometerPlaceholder = PitstopStrings.tr("Localizable", "onb.odometerPlaceholder")
      /// Okayyyy let's go
      public static let okLetsGo = PitstopStrings.tr("Localizable", "onb.okLetsGo")
      /// Plate number
      public static let plateNumber = PitstopStrings.tr("Localizable", "onb.plateNumber")
      /// Let us remind you key dates about your vehicle’s maintenance status and deadlines
      public static let reminderInfo = PitstopStrings.tr("Localizable", "onb.reminderInfo")
      /// Secondary fuel type
      public static let secondFuelType = PitstopStrings.tr("Localizable", "onb.secondFuelType")
      /// Select a fuel type
      public static let selectFuelType = PitstopStrings.tr("Localizable", "onb.selectFuelType")
      /// You are set to start your engine and optimize your spendings
      public static let startEngine = PitstopStrings.tr("Localizable", "onb.startEngine")
      /// Keep all of your vehicle info at hand
      public static let vehicleInfo = PitstopStrings.tr("Localizable", "onb.vehicleInfo")
      /// Vehicle name
      public static let vehicleName = PitstopStrings.tr("Localizable", "onb.vehicleName")
      /// Your vehicle is ready!
      public static let vehicleReady = PitstopStrings.tr("Localizable", "onb.vehicleReady")
      /// Vehicle registration
      public static let vehicleRegistration = PitstopStrings.tr("Localizable", "onb.vehicleRegistration")
      /// Warm up your engine
      public static let warmUpEngine = PitstopStrings.tr("Localizable", "onb.warmUpEngine")
      /// Write the odometer
      public static let writeOdometer = PitstopStrings.tr("Localizable", "onb.writeOdometer")
      /// Write the plate number
      public static let writePlate = PitstopStrings.tr("Localizable", "onb.writePlate")
    }

    public enum Reminder: Sendable {
    /// Clear expired reminder
      public static let clear = PitstopStrings.tr("Localizable", "reminder.clear")
      /// Clear all expired reminders
      public static let clearAll = PitstopStrings.tr("Localizable", "reminder.clearAll")
      /// Are you sure you want to delete this reminder?
      public static let delete = PitstopStrings.tr("Localizable", "reminder.delete")
      /// There are no rmeinders now
      public static let empty = PitstopStrings.tr("Localizable", "reminder.empty")
      /// Enable the notifications in the settings before creating a reminder
      public static let enableNotification = PitstopStrings.tr("Localizable", "reminder.enableNotification")
      /// New reminder
      public static let new = PitstopStrings.tr("Localizable", "reminder.new")
      /// Reminders
      public static let title = PitstopStrings.tr("Localizable", "reminder.title")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension PitstopStrings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = Bundle.module.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
// swiftlint:enable all
// swiftformat:enable all
