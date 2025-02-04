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
    public static let odometer = PitstopAPPImages(name: "Odometer")
    public static let time = PitstopAPPImages(name: "Time")
    public static let documents = PitstopAPPImages(name: "documents")
    public static let fuelType = PitstopAPPImages(name: "fuelType")
    public static let phone = PitstopAPPImages(name: "phone")
    public static let photo = PitstopAPPImages(name: "photo")
    public static let fuel = PitstopAPPImages(name: "Fuel")
    public static let insurance = PitstopAPPImages(name: "Insurance")
    public static let parking = PitstopAPPImages(name: "Parking")
    public static let tolls = PitstopAPPImages(name: "Tolls")
    public static let roadTax = PitstopAPPImages(name: "roadTax")
    public static let day = PitstopAPPImages(name: "Day")
    public static let liters = PitstopAPPImages(name: "Liters")
    public static let other = PitstopAPPImages(name: "Other")
    public static let arrowAnalytics = PitstopAPPImages(name: "arrowAnalytics")
    public static let arrowDown = PitstopAPPImages(name: "arrowDown")
    public static let arrowLeft = PitstopAPPImages(name: "arrowLeft")
    public static let bell = PitstopAPPImages(name: "bell")
    public static let carSettings = PitstopAPPImages(name: "car-settings")
    public static let category = PitstopAPPImages(name: "category")
    public static let deleteIcon = PitstopAPPImages(name: "deleteIcon")
    public static let download = PitstopAPPImages(name: "download")
    public static let fines = PitstopAPPImages(name: "fines")
    public static let ics = PitstopAPPImages(name: "ics")
    public static let note = PitstopAPPImages(name: "note")
    public static let paperclip = PitstopAPPImages(name: "paperclip")
    public static let plus = PitstopAPPImages(name: "plus")
    public static let priceLiter = PitstopAPPImages(name: "priceLiter")
    public static let star = PitstopAPPImages(name: "star")
    public static let wrench = PitstopAPPImages(name: "wrench")
    public static let page1 = PitstopAPPImages(name: "page1")
    public static let page4 = PitstopAPPImages(name: "page4")
    public static let page5 = PitstopAPPImages(name: "page5")
    public static let logo = PitstopAPPImages(name: "logo")
    public static let premium = PitstopAPPImages(name: "premium")
    public static let carIcon = PitstopAPPImages(name: "carIcon")
    public static let chartIcon = PitstopAPPImages(name: "chartIcon")
    public static let plusIcon = PitstopAPPImages(name: "plusIcon")
    public static let settingsIcon = PitstopAPPImages(name: "settingsIcon")
    public static let arrowRight = PitstopAPPImages(name: "arrowRight")
    public static let bellHome = PitstopAPPImages(name: "bellHome")
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

  init(decorative asset: PitstopAPPImages) {
    let bundle = Bundle.module
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:enable all
// swiftformat:enable all
