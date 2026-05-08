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
public enum ChassisUIAsset: Sendable {
  public static let time = ChassisUIImages(name: "Time")
  public static let phone = ChassisUIImages(name: "phone")
  public static let photo = ChassisUIImages(name: "photo")
  public static let day = ChassisUIImages(name: "Day")
  public static let fuel = ChassisUIImages(name: "Fuel")
  public static let insurance = ChassisUIImages(name: "Insurance")
  public static let liters = ChassisUIImages(name: "Liters")
  public static let odometer = ChassisUIImages(name: "Odometer")
  public static let other = ChassisUIImages(name: "Other")
  public static let parking = ChassisUIImages(name: "Parking")
  public static let carIcon = ChassisUIImages(name: "carIcon")
  public static let chartIcon = ChassisUIImages(name: "chartIcon")
  public static let plusIcon = ChassisUIImages(name: "plusIcon")
  public static let settingsIcon = ChassisUIImages(name: "settingsIcon")
  public static let tolls = ChassisUIImages(name: "Tolls")
  public static let arrowAnalytics = ChassisUIImages(name: "arrowAnalytics")
  public static let arrowDown = ChassisUIImages(name: "arrowDown")
  public static let arrowLeft = ChassisUIImages(name: "arrowLeft")
  public static let arrowRight = ChassisUIImages(name: "arrowRight")
  public static let bell = ChassisUIImages(name: "bell")
  public static let bellHome = ChassisUIImages(name: "bellHome")
  public static let carSettings = ChassisUIImages(name: "car-settings")
  public static let category = ChassisUIImages(name: "category")
  public static let deleteIcon = ChassisUIImages(name: "deleteIcon")
  public static let documents = ChassisUIImages(name: "documents")
  public static let download = ChassisUIImages(name: "download")
  public static let fines = ChassisUIImages(name: "fines")
  public static let fuelType = ChassisUIImages(name: "fuelType")
  public static let ics = ChassisUIImages(name: "ics")
  public static let note = ChassisUIImages(name: "note")
  public static let paperclip = ChassisUIImages(name: "paperclip")
  public static let plus = ChassisUIImages(name: "plus")
  public static let priceLiter = ChassisUIImages(name: "priceLiter")
  public static let roadTax = ChassisUIImages(name: "roadTax")
  public static let star = ChassisUIImages(name: "star")
  public static let wrench = ChassisUIImages(name: "wrench")
  public static let page1 = ChassisUIImages(name: "page1")
  public static let page4 = ChassisUIImages(name: "page4")
  public static let page5 = ChassisUIImages(name: "page5")
  public static let premium = ChassisUIImages(name: "premium")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public struct ChassisUIImages: Sendable {
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
  init(asset: ChassisUIImages) {
    let bundle = Bundle.module
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ChassisUIImages, label: Text) {
    let bundle = Bundle.module
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ChassisUIImages) {
    let bundle = Bundle.module
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:enable all
// swiftformat:enable all
