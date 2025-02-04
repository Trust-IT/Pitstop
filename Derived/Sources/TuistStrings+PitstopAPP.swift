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
  /// 100
  public static let _100 = PitstopAPPStrings.tr("Localizable", "100")
  /// 1000
  public static let _1000 = PitstopAPPStrings.tr("Localizable", "1000")
  /// Aggiungi altre info
  public static let addMoreInfo = PitstopAPPStrings.tr("Localizable", "Add more info")
  /// Tutti i costi
  public static let allCosts = PitstopAPPStrings.tr("Localizable", "All costs")
  /// Statistiche
  public static let analytics = PitstopAPPStrings.tr("Localizable", "Analytics")
  /// Brand
  public static let brand = PitstopAPPStrings.tr("Localizable", "Brand")
  /// Annulla
  public static let cancel = PitstopAPPStrings.tr("Localizable", "Cancel")
  /// Costi
  public static let costs = PitstopAPPStrings.tr("Localizable", "Costs")
  /// Documenti
  public static let documents = PitstopAPPStrings.tr("Localizable", "Documents")
  /// Non perderti nulla \ndi importante
  public static let donTMissAnythingImportant = PitstopAPPStrings.tr("Localizable", "Don’t miss anything \nimportant")
  /// Nome della spesa
  public static let expensesName = PitstopAPPStrings.tr("Localizable", "Expenses Name")
  /// Carburante
  public static let fuel = PitstopAPPStrings.tr("Localizable", "Fuel")
  /// Scalda i motori per un modo \nsemplice di gestire il tuo veicolo e \ntagliare i costi
  public static let gearUpForASimpleWayOfManagingYourVehicleAndCuttingCosts = PitstopAPPStrings.tr("Localizable", "Gear up for a simple way of managing your \nvehicle and cutting costs")
  /// Ottieni altre funzionalità
  public static let getMoreFeatures = PitstopAPPStrings.tr("Localizable", "Get more features")
  /// Hello, World!
  public static let helloWorld = PitstopAPPStrings.tr("Localizable", "Hello, World!")
  /// Salta su e inserisci delle informazioni utili
  public static let hopInAndInsertSomeKeyDetails = PitstopAPPStrings.tr("Localizable", "Hop in and insert some key details")
  /// Mantieni tutte le info del veicolo alla mano
  public static let keepAllOfYourVehicleInfoAtHand = PitstopAPPStrings.tr("Localizable", "Keep all of your vehicle info at hand")
  /// L
  public static let l = PitstopAPPStrings.tr("Localizable", "L")
  /// Ultimi eventi
  public static let lastEvents = PitstopAPPStrings.tr("Localizable", "Last Events")
  /// Lascia che l'App ti ricordi date \nchiave e scadenze sullo stato di manutenzione del veicolo
  public static let letUsRemindYouKeyDatesAboutYourVehicleSMaintenanceStatusAndDeadlines = PitstopAPPStrings.tr("Localizable", "Let us remind you key dates about your \nvehicle’s maintenance status and deadlines")
  /// Litri
  public static let liters = PitstopAPPStrings.tr("Localizable", "Liters")
  /// Modello
  public static let model = PitstopAPPStrings.tr("Localizable", "Model")
  /// Nuovo report
  public static let newReport = PitstopAPPStrings.tr("Localizable", "New report")
  /// Note
  public static let note = PitstopAPPStrings.tr("Localizable", "Note")
  /// Odometro
  public static let odometer = PitstopAPPStrings.tr("Localizable", "Odometer")
  /// Prezzo/Litro
  public static let priceLiter = PitstopAPPStrings.tr("Localizable", "Price/Liter")
  /// Rimuovi tutte le spese
  public static let removeAllExpenses = PitstopAPPStrings.tr("Localizable", "Remove all expenses")
  /// Rimuovi tutti i veicoli
  public static let removeAllVehicles = PitstopAPPStrings.tr("Localizable", "Remove all vehicles")
  /// Salva
  public static let save = PitstopAPPStrings.tr("Localizable", "Save")
  /// Impostazioni
  public static let settings = PitstopAPPStrings.tr("Localizable", "Settings")
  /// Nome del veicolo
  public static let vehicleName = PitstopAPPStrings.tr("Localizable", "Vehicle Name")
  /// Nome del veicolo: %@
  public static func vehicleName(_ p1: Any) -> String {
    return PitstopAPPStrings.tr("Localizable", "Vehicle name: %@",String(describing: p1))
  }
  /// Registrazione veicolo
  public static let vehicleRegistration = PitstopAPPStrings.tr("Localizable", "Vehicle registration")
  /// Scalda il motore
  public static let warmUpYourEngine = PitstopAPPStrings.tr("Localizable", "Warm up your engine")
  /// Ora sei pronto a far partire il motore \ned ottimizzare le tue spese
  public static let youAreSetToStartYourEngineAndOptimizeYourSpendings = PitstopAPPStrings.tr("Localizable", "You are set to start your engine and optimize \n your spendings")
  /// Il tuo veicolo è pronto!
  public static let yourVehicleIsReady = PitstopAPPStrings.tr("Localizable", "Your vehicle is ready!")

  public enum Common: Sendable {
  /// Cancel
    public static let cancel = PitstopAPPStrings.tr("Localizable", "common.cancel")
    /// Save
    public static let save = PitstopAPPStrings.tr("Localizable", "common.save")
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
