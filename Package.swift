// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "swift-explore-swiftui-navigation",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        // Prototype
        .shopUIPrototype,
        // Domain
        .domain,
        // Features
        .addressPicker,
        .addressView,
        .deliveryTypePicker,
        .featuredShops,
        .profileFeature,
        .promoFeature,
        .promoStripFeature,
        .shopFeature,
        .shopGridFeature,
        .shopTypeFeature,
        .shopTypeStripFeature,
        .showProfileButtonFeature,
    ],
    dependencies: [
        .identifiedCollections,
        .swiftUINavigation,
        .tagged,
    ],
    targets: [
        // Prototype
        .shopUIPrototype,
        // Domain
        .domain,
        // Features
        .addressPicker,
        .addressView,
        .deliveryTypePicker,
        .featuredShops,
        .featureView,
        .profileFeature,
        .promoFeature,
        .promoStripFeature,
        .shopFeature,
        .shopGridFeature,
        .shopTypeFeature,
        .shopTypeStripFeature,
        .showProfileButtonFeature,
    ]
)

// MARK: - Prototype

private extension Product {
    
    static let shopUIPrototype = library(
        name: "ShopUIPrototype",
        targets: ["ShopUIPrototype"]
    )
}

private extension Target {
    
    static let shopUIPrototype = target(
        name: .shopUIPrototype,
        dependencies: [
            // Domain
            .domain,
            // Packages
            .identifiedCollections,
            .swiftUINavigation,
            .tagged,
            // Features
            .addressPicker,
            .addressView,
            .deliveryTypePicker,
            .featuredShops,
            .featureView,
            .profileFeature,
            .promoFeature,
            .promoStripFeature,
            .shopFeature,
            .shopGridFeature,
            .shopTypeFeature,
            .shopTypeStripFeature,
            .showProfileButtonFeature,
        ]
    )
}

private extension String {
    
    static let shopUIPrototype = "ShopUIPrototype"
}

// MARK: - Domain

private extension Product {
    
    static let domain = library(
        name: .domain,
        targets: [.domain]
    )
}

private extension Target {
    
    static let domain = target(
        name: .domain,
        dependencies: [
            .identifiedCollections,
            .tagged,
        ]
    )
}

private extension Target.Dependency {
    
    static let domain = byName(name: .domain)
}

private extension String {
    
    static let domain = "Domain"
}

// MARK: - Features

private extension Product {
    
    static let addressPicker = library(
        name: .addressPicker,
        targets: [.addressPicker]
    )
    static let addressView = library(
        name: .addressView,
        targets: [.addressView]
    )
    static let deliveryTypePicker = library(
        name: .deliveryTypePicker,
        targets: [.deliveryTypePicker]
    )
    static let featuredShops = library(
        name: .featuredShops,
        targets: [.featuredShops]
    )
    static let featureView = library(
        name: .featureView,
        targets: [.featureView]
    )
    static let profileFeature = library(
        name: .profileFeature,
        targets: [.profileFeature]
    )
    static let promoFeature = library(
        name: .promoFeature,
        targets: [.promoFeature]
    )
    static let promoStripFeature = library(
        name: .promoStripFeature,
        targets: [.promoStripFeature]
    )
    static let shopFeature = library(
        name: .shopFeature,
        targets: [.shopFeature]
    )
    static let shopGridFeature = library(
        name: .shopGridFeature,
        targets: [.shopGridFeature]
    )
    static let shopTypeFeature = library(
        name: .shopTypeFeature,
        targets: [.shopTypeFeature]
    )
    static let shopTypeStripFeature = library(
        name: .shopTypeStripFeature,
        targets: [.shopTypeStripFeature]
    )
    static let showProfileButtonFeature = library(
        name: .showProfileButtonFeature,
        targets: [.showProfileButtonFeature]
    )
}

private extension Target {
    
    static let addressPicker = target(
        name: .addressPicker,
        dependencies: [
            .domain
        ]
    )
    static let addressView = target(
        name: .addressView,
        dependencies: [
            .domain
        ]
    )
    static let deliveryTypePicker = target(
        name: .deliveryTypePicker,
        dependencies: [
            .domain
        ]
    )
    static let featuredShops = target(
        name: .featuredShops,
        dependencies: [
            .domain
        ]
    )
    static let featureView = target(
        name: .featureView,
        dependencies: [
            .domain
        ]
    )
    static let profileFeature = target(
        name: .profileFeature,
        dependencies: [
            .domain,
            .swiftUINavigation
        ]
    )
    static let promoFeature = target(
        name: .promoFeature,
        dependencies: [
            .domain,
        ]
    )
    static let promoStripFeature = target(
        name: .promoStripFeature,
        dependencies: [
            .domain,
        ]
    )
    static let shopFeature = target(
        name: .shopFeature,
        dependencies: [
            .domain,
            .swiftUINavigation
        ]
    )
    static let shopGridFeature = target(
        name: .shopGridFeature,
        dependencies: [
            .domain,
            .swiftUINavigation
        ]
    )
    static let shopTypeFeature = target(
        name: .shopTypeFeature,
        dependencies: [
            .domain,
        ]
    )
    static let shopTypeStripFeature = target(
        name: .shopTypeStripFeature,
        dependencies: [
            .domain,
            .swiftUINavigation
        ]
    )
    static let showProfileButtonFeature = target(
        name: .showProfileButtonFeature,
        dependencies: [
            .domain,
        ]
    )
}

private extension Target.Dependency {

    static let addressPicker = byName(name: .addressPicker)
    static let addressView = byName(name: .addressView)
    static let deliveryTypePicker = byName(name: .deliveryTypePicker)
    static let featuredShops = byName(name: .featuredShops)
    static let featureView = byName(name: .featureView)
    static let profileFeature = byName(name: .profileFeature)
    static let promoFeature = byName(name: .promoFeature)
    static let promoStripFeature = byName(name: .promoStripFeature)
    static let shopFeature = byName(name: .shopFeature)
    static let shopGridFeature = byName(name: .shopGridFeature)
    static let shopTypeFeature = byName(name: .shopTypeFeature)
    static let shopTypeStripFeature = byName(name: .shopTypeStripFeature)
    static let showProfileButtonFeature = byName(name: .showProfileButtonFeature)
}

private extension String {

    static let addressPicker = "AddressPicker"
    static let addressView = "AddressView"
    static let deliveryTypePicker = "DeliveryTypePicker"
    static let featuredShops = "FeaturedShops"
    static let featureView = "FeatureView"
    static let profileFeature = "ProfileFeature"
    static let promoFeature = "PromoFeature"
    static let promoStripFeature = "PromoStripFeature"
    static let shopFeature = "ShopFeature"
    static let shopGridFeature = "ShopGridFeature"
    static let shopTypeFeature = "ShopTypeFeature"
    static let shopTypeStripFeature = "ShopTypeStripFeature"
    static let showProfileButtonFeature = "ShowProfileButtonFeature"
}

// MARK: - Point-Free

private extension Package.Dependency {
    
    static let casePaths = Package.Dependency.package(
        url: .pointFreeGitHub + .case_paths,
        from: .init(0, 10, 1)
    )
    static let combineSchedulers = Package.Dependency.package(
        url: .pointFreeGitHub + .combine_schedulers,
        from: .init(0, 9, 1)
    )
    static let identifiedCollections = Package.Dependency.package(
        url: .pointFreeGitHub + .swift_identified_collections,
        from: .init(0, 4, 1)
    )
    static let snapshotTesting = Package.Dependency.package(
        url: .pointFreeGitHub + .swift_snapshot_testing,
        from: .init(1, 10, 0)
    )
    static let swiftUINavigation = Package.Dependency.package(
        url: .pointFreeGitHub + .swiftui_navigation,
        from: .init(0, 4, 5)
    )
    static let tagged = Package.Dependency.package(
        url: .pointFreeGitHub + .swift_tagged,
        from: .init(0, 7, 0)
    )
}

private extension Target.Dependency {
    
    static let casePaths = product(
        name: .casePaths,
        package: .case_paths
    )
    static let combineSchedulers = product(
        name: .combineSchedulers,
        package: .combine_schedulers
    )
    static let identifiedCollections = product(
        name: .identifiedCollections,
        package: .swift_identified_collections
    )
    static let snapshotTesting = product(
        name: .snapshotTesting,
        package: .swift_snapshot_testing
    )
    static let swiftUINavigation = product(
        name: .swiftUINavigation,
        package: .swiftui_navigation
    )
    static let tagged = product(
        name: .tagged,
        package: .swift_tagged
    )
}

private extension String {
    
    static let pointFreeGitHub = "https://github.com/pointfreeco/"
    
    static let casePaths = "CasePaths"
    static let case_paths = "swift-case-paths"
    
    static let combineSchedulers = "CombineSchedulers"
    static let combine_schedulers = "combine-schedulers"
    
    static let identifiedCollections = "IdentifiedCollections"
    static let swift_identified_collections = "swift-identified-collections"
    
    static let snapshotTesting = "SnapshotTesting"
    static let swift_snapshot_testing = "swift-snapshot-testing"
    
    static let swiftUINavigation = "SwiftUINavigation"
    static let swiftui_navigation = "swiftui-navigation"
    
    static let tagged = "Tagged"
    static let swift_tagged = "swift-tagged"
}
