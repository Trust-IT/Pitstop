// swiftlint:disable:this file_name
// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
// Generated using tuist — https://github.com/tuist/tuist



#if os(macOS)
#if hasFeature(InternalImportsByDefault)
public import AppKit
#else
import AppKit
#endif
#else
#if hasFeature(InternalImportsByDefault)
public import UIKit
#else
import UIKit
#endif
#endif

#if canImport(SwiftUI)
#if hasFeature(InternalImportsByDefault)
public import SwiftUI
#else
import SwiftUI
#endif
#endif

// MARK: - Asset Catalogs

public enum PitstopAsset: Sendable {
  public enum Assets {
  public static let accentColor = PitstopColors(name: "AccentColor")
    public static let time = PitstopImages(name: "Time")
    public static let phone = PitstopImages(name: "phone")
    public static let photo = PitstopImages(name: "photo")
    public static let day = PitstopImages(name: "Day")
    public static let fuel = PitstopImages(name: "Fuel")
    public static let insurance = PitstopImages(name: "Insurance")
    public static let liters = PitstopImages(name: "Liters")
    public static let odometer = PitstopImages(name: "Odometer")
    public static let other = PitstopImages(name: "Other")
    public static let parking = PitstopImages(name: "Parking")
    public static let carIcon = PitstopImages(name: "carIcon")
    public static let chartIcon = PitstopImages(name: "chartIcon")
    public static let plusIcon = PitstopImages(name: "plusIcon")
    public static let settingsIcon = PitstopImages(name: "settingsIcon")
    public static let tolls = PitstopImages(name: "Tolls")
    public static let arrowAnalytics = PitstopImages(name: "arrowAnalytics")
    public static let arrowDown = PitstopImages(name: "arrowDown")
    public static let arrowLeft = PitstopImages(name: "arrowLeft")
    public static let arrowRight = PitstopImages(name: "arrowRight")
    public static let bell = PitstopImages(name: "bell")
    public static let bellHome = PitstopImages(name: "bellHome")
    public static let carSettings = PitstopImages(name: "car-settings")
    public static let category = PitstopImages(name: "category")
    public static let deleteIcon = PitstopImages(name: "deleteIcon")
    public static let documents = PitstopImages(name: "documents")
    public static let download = PitstopImages(name: "download")
    public static let fines = PitstopImages(name: "fines")
    public static let fuelType = PitstopImages(name: "fuelType")
    public static let ics = PitstopImages(name: "ics")
    public static let note = PitstopImages(name: "note")
    public static let paperclip = PitstopImages(name: "paperclip")
    public static let plus = PitstopImages(name: "plus")
    public static let priceLiter = PitstopImages(name: "priceLiter")
    public static let roadTax = PitstopImages(name: "roadTax")
    public static let star = PitstopImages(name: "star")
    public static let wrench = PitstopImages(name: "wrench")
    public static let page1 = PitstopImages(name: "page1")
    public static let page4 = PitstopImages(name: "page4")
    public static let page5 = PitstopImages(name: "page5")
    public static let logo = PitstopImages(name: "logo")
    public static let premium = PitstopImages(name: "premium")
  }
  public enum PreviewAssets {
  }
}

// MARK: - Implementation Details

public final class PitstopColors: Sendable {
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

public extension PitstopColors.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, visionOS 1.0, *)
  convenience init?(asset: PitstopColors) {
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
  init(asset: PitstopColors) {
    let bundle = Bundle.module
    self.init(asset.name, bundle: bundle)
  }
}
#endif

public struct PitstopImages: Sendable {
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
  init(asset: PitstopImages) {
    let bundle = Bundle.module
    self.init(asset.name, bundle: bundle)
  }

  init(asset: PitstopImages, label: Text) {
    let bundle = Bundle.module
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: PitstopImages) {
    let bundle = Bundle.module
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftformat:enable all
// swiftlint:enable all
