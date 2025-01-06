// swiftlint:disable:this file_name
// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
// Generated using tuist — https://github.com/tuist/tuist

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum PitstopAPPAsset: Sendable {
  public enum Assets {
  public static let accentColor = PitstopAPPColors(name: "AccentColor")
    public static let day = PitstopAPPImages(name: "Day")
    public static let liters = PitstopAPPImages(name: "Liters")
    public static let note = PitstopAPPImages(name: "Note")
    public static let odometer = PitstopAPPImages(name: "Odometer")
    public static let recurrent = PitstopAPPImages(name: "Recurrent")
    public static let time = PitstopAPPImages(name: "Time")
    public static let basedOn = PitstopAPPImages(name: "basedOn")
    public static let category = PitstopAPPImages(name: "category")
    public static let fuelType = PitstopAPPImages(name: "fuelType")
    public static let literColored = PitstopAPPImages(name: "literColored")
    public static let noteColored = PitstopAPPImages(name: "noteColored")
    public static let priceLiter = PitstopAPPImages(name: "priceLiter")
    public static let priceLiterColored = PitstopAPPImages(name: "priceLiterColored")
    public static let remindMe = PitstopAPPImages(name: "remindMe")
    public static let fuel = PitstopAPPImages(name: "Fuel")
    public static let insurance = PitstopAPPImages(name: "Insurance")
    public static let other = PitstopAPPImages(name: "Other")
    public static let parking = PitstopAPPImages(name: "Parking")
    public static let tolls = PitstopAPPImages(name: "Tolls")
    public static let fines = PitstopAPPImages(name: "fines")
    public static let maintenance = PitstopAPPImages(name: "maintenance")
    public static let roadTax = PitstopAPPImages(name: "roadTax")
    public static let documents = PitstopAPPImages(name: "documents")
    public static let page1 = PitstopAPPImages(name: "page1")
    public static let page4 = PitstopAPPImages(name: "page4")
    public static let page5 = PitstopAPPImages(name: "page5")
    public static let phone = PitstopAPPImages(name: "phone")
    public static let photo = PitstopAPPImages(name: "photo")
    public static let carIcon = PitstopAPPImages(name: "carIcon")
    public static let chartIcon = PitstopAPPImages(name: "chartIcon")
    public static let plus = PitstopAPPImages(name: "plus")
    public static let settingsIcon = PitstopAPPImages(name: "settingsIcon")
    public static let arrowDown = PitstopAPPImages(name: "arrowDown")
    public static let arrowLeft = PitstopAPPImages(name: "arrowLeft")
    public static let bellHome = PitstopAPPImages(name: "bellHome")
    public static let bestBoy = PitstopAPPImages(name: "bestBoy")
    public static let carSettings = PitstopAPPImages(name: "car-settings")
    public static let deleteIcon = PitstopAPPImages(name: "deleteIcon")
    public static let download = PitstopAPPImages(name: "download")
    public static let ics = PitstopAPPImages(name: "ics")
    public static let logo = PitstopAPPImages(name: "logo")
    public static let paperclip = PitstopAPPImages(name: "paperclip")
    public static let premium = PitstopAPPImages(name: "premium")
    public static let service = PitstopAPPImages(name: "service")
  }
  public enum PreviewAssets {
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class PitstopAPPColors: Sendable {
  public let name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, visionOS 1.0, *)
  public var color: Color {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, visionOS 1.0, *)
  public var swiftUIColor: SwiftUI.Color {
      return SwiftUI.Color(asset: self)
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension PitstopAPPColors.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, visionOS 1.0, *)
  convenience init?(asset: PitstopAPPColors) {
    let bundle = Bundle.module
    #if os(iOS) || os(tvOS) || os(visionOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, visionOS 1.0, *)
public extension SwiftUI.Color {
  init(asset: PitstopAPPColors) {
    let bundle = Bundle.module
    self.init(asset.name, bundle: bundle)
  }
}
#endif

public struct PitstopAPPImages: Sendable {
  public let name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
  public typealias Image = UIImage
  #endif

  public var image: Image {
    let bundle = Bundle.module
    #if os(iOS) || os(tvOS) || os(visionOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, visionOS 1.0, *)
  public var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, visionOS 1.0, *)
public extension SwiftUI.Image {
  init(asset: PitstopAPPImages) {
    let bundle = Bundle.module
    self.init(asset.name, bundle: bundle)
  }

  init(asset: PitstopAPPImages, label: Text) {
    let bundle = Bundle.module
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(_ asset: PitstopAPPImages) {
    let bundle = Bundle.module
    self.init(asset.name, bundle: bundle)
  }

  init(_ asset: PitstopAPPImages, label: Text) {
    let bundle = Bundle.module
    self.init(asset.name, bundle: bundle)
  }

  init(decorative asset: PitstopAPPImages) {
    let bundle = Bundle.module
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

@available(iOS 11.0, tvOS 11.0,*)
@available(watchOS, unavailable)
extension UIKit.UIImage {
   /// Initialize `UIImage` with a Tuist generated image resource
   convenience init(resource asset: PitstopAPPImages) {
        #if !os(watchOS)
            self.init(named: asset.name, in: Bundle.module, compatibleWith: nil)! 
        #else
            self.init()
        #endif
   }
}

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
extension PitstopAPPImages {



  static let assets_day = PitstopAPPAsset.Assets.day
  static let assets_liters = PitstopAPPAsset.Assets.liters
  static let assets_note = PitstopAPPAsset.Assets.note
  static let assets_odometer = PitstopAPPAsset.Assets.odometer
  static let assets_recurrent = PitstopAPPAsset.Assets.recurrent
  static let assets_time = PitstopAPPAsset.Assets.time
  static let assets_basedOn = PitstopAPPAsset.Assets.basedOn
  static let assets_category = PitstopAPPAsset.Assets.category
  static let assets_fuelType = PitstopAPPAsset.Assets.fuelType
  static let assets_literColored = PitstopAPPAsset.Assets.literColored
  static let assets_noteColored = PitstopAPPAsset.Assets.noteColored
  static let assets_priceLiter = PitstopAPPAsset.Assets.priceLiter
  static let assets_priceLiterColored = PitstopAPPAsset.Assets.priceLiterColored
  static let assets_remindMe = PitstopAPPAsset.Assets.remindMe
  static let assets_fuel = PitstopAPPAsset.Assets.fuel
  static let assets_insurance = PitstopAPPAsset.Assets.insurance
  static let assets_other = PitstopAPPAsset.Assets.other
  static let assets_parking = PitstopAPPAsset.Assets.parking
  static let assets_tolls = PitstopAPPAsset.Assets.tolls
  static let assets_fines = PitstopAPPAsset.Assets.fines
  static let assets_maintenance = PitstopAPPAsset.Assets.maintenance
  static let assets_roadTax = PitstopAPPAsset.Assets.roadTax
  static let assets_documents = PitstopAPPAsset.Assets.documents
  static let assets_page1 = PitstopAPPAsset.Assets.page1
  static let assets_page4 = PitstopAPPAsset.Assets.page4
  static let assets_page5 = PitstopAPPAsset.Assets.page5
  static let assets_phone = PitstopAPPAsset.Assets.phone
  static let assets_photo = PitstopAPPAsset.Assets.photo
  static let assets_carIcon = PitstopAPPAsset.Assets.carIcon
  static let assets_chartIcon = PitstopAPPAsset.Assets.chartIcon
  static let assets_plus = PitstopAPPAsset.Assets.plus
  static let assets_settingsIcon = PitstopAPPAsset.Assets.settingsIcon
  static let assets_arrowDown = PitstopAPPAsset.Assets.arrowDown
  static let assets_arrowLeft = PitstopAPPAsset.Assets.arrowLeft
  static let assets_bellHome = PitstopAPPAsset.Assets.bellHome
  static let assets_bestBoy = PitstopAPPAsset.Assets.bestBoy
  static let assets_carSettings = PitstopAPPAsset.Assets.carSettings
  static let assets_deleteIcon = PitstopAPPAsset.Assets.deleteIcon
  static let assets_download = PitstopAPPAsset.Assets.download
  static let assets_ics = PitstopAPPAsset.Assets.ics
  static let assets_logo = PitstopAPPAsset.Assets.logo
  static let assets_paperclip = PitstopAPPAsset.Assets.paperclip
  static let assets_premium = PitstopAPPAsset.Assets.premium
  static let assets_service = PitstopAPPAsset.Assets.service

}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// swiftlint:enable all
// swiftformat:enable all
