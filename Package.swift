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
        // Domains
        .domain,
        .mapDomain,
        // Features
        .addNewAddressFeature,
        .addressMapSearchFeature,
        .addressPickerFeature,
        .addressViewFeature,
        .appFeature,
        .deliveryTypePickerFeature,
        .featuredShopsFeature,
        .featureViewFeature,
        .mainPageFeature,
        .mapKitMapFeature,
        .newAppFeatureFeature,
        .profileEditorFeature,
        .profileFeature,
        .promoFeature,
        .promoStripFeature,
        .shopFeature,
        .shopGridFeature,
        .shopTypeFeature,
        .shopTypeStripFeature,
        .showProfileButtonFeature,
        // Services
        .addressSearchService,
        .geocoderAddressCoordinateSearch,
    ],
    dependencies: [
        .casePaths,
        .combineSchedulers,
        .identifiedCollections,
        .snapshotTesting,
        .swiftUINavigation,
        .tagged,
    ],
    targets: [
        // Domains
        .mapDomain,
        .domain,
        .mapDomainTests,
        // Features
        .addNewAddressFeature,
        .addressMapSearchFeature,
        .addressMapSearchFeatureTests,
        .addressPickerFeature,
        .addressViewFeature,
        .appFeature,
        .deliveryTypePickerFeature,
        .featuredShopsFeature,
        .featureViewFeature,
        .mainPageFeature,
        .mapKitMapFeature,
        .newAppFeatureFeature,
        .profileEditorFeature,
        .profileFeature,
        .promoFeature,
        .promoStripFeature,
        .shopFeature,
        .shopGridFeature,
        .shopTypeFeature,
        .shopTypeStripFeature,
        .showProfileButtonFeature,
        // Services
        .addressSearchService,
        .addressSearchServiceTests,
        .geocoderAddressCoordinateSearch,
    ]
)

// MARK: - Domains

private extension Product {
    
    static let domain = library(
        name: .domain,
        targets: [.domain]
    )
    static let mapDomain = library(
        name: .mapDomain,
        targets: [.mapDomain]
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
    static let mapDomain = target(
        name: .mapDomain,
        dependencies: [
        ]
    )
    static let mapDomainTests = testTarget(
        name: .mapDomainTests,
        dependencies: [
            .mapDomain,
        ]
    )
}

private extension Target.Dependency {
    
    static let domain = byName(name: .domain)
    static let mapDomain = byName(name: .mapDomain)
}

private extension String {
    
    static let domain = "Domain"
    static let mapDomain = "MapDomain"
    static let mapDomainTests = "MapDomainTests"
}

// MARK: - Features

private extension Product {
    
    static let addNewAddressFeature = library(
        name: .addNewAddressFeature,
        targets: [.addNewAddressFeature]
    )
    static let addressMapSearchFeature = library(
        name: .addressMapSearchFeature,
        targets: [.addressMapSearchFeature]
    )
    static let addressPickerFeature = library(
        name: .addressPickerFeature,
        targets: [.addressPickerFeature]
    )
    static let addressViewFeature = library(
        name: .addressViewFeature,
        targets: [.addressViewFeature]
    )
    static let appFeature = library(
        name: .appFeature,
        targets: [.appFeature]
    )
    static let deliveryTypePickerFeature = library(
        name: .deliveryTypePickerFeature,
        targets: [.deliveryTypePickerFeature]
    )
    static let featuredShopsFeature = library(
        name: .featuredShopsFeature,
        targets: [.featuredShopsFeature]
    )
    static let featureViewFeature = library(
        name: .featureViewFeature,
        targets: [.featureViewFeature]
    )
    static let mainPageFeature = library(
        name: .mainPageFeature,
        targets: [.mainPageFeature]
    )
    static let mapKitMapFeature = library(
        name: .mapKitMapFeature,
        targets: [.mapKitMapFeature]
    )
    static let newAppFeatureFeature = library(
        name: .newAppFeatureFeature,
        targets: [.newAppFeatureFeature]
    )
    static let profileEditorFeature = library(
        name: .profileEditorFeature,
        targets: [.profileEditorFeature]
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
    
    static let addNewAddressFeature = target(
        name: .addNewAddressFeature,
        dependencies: [
            .casePaths,
            .combineSchedulers,
            .tagged
        ]
    )
    static let addressMapSearchFeature = target(
        name: .addressMapSearchFeature,
        dependencies: [
            .casePaths,
            .combineSchedulers,
            .mapDomain,
            .tagged,
        ]
    )
    static let addressMapSearchFeatureTests = testTarget(
        name: .addressMapSearchFeatureTests,
        dependencies: [
            .combineSchedulers,
            .mapDomain,
            .addressMapSearchFeature,
        ]
    )
    static let addressPickerFeature = target(
        name: .addressPickerFeature,
        dependencies: [
            .domain
        ]
    )
    static let addressViewFeature = target(
        name: .addressViewFeature,
        dependencies: [
            .domain
        ]
    )
    static let appFeature = target(
        name: .appFeature,
        dependencies: [
            // Domains
            .domain,
            .mapDomain,
            // Packages
            .identifiedCollections,
            .swiftUINavigation,
            .tagged,
            // Features
            .addressMapSearchFeature,
            .addressPickerFeature,
            .addressViewFeature,
            .deliveryTypePickerFeature,
            .featuredShopsFeature,
            .featureViewFeature,
            .mainPageFeature,
            .newAppFeatureFeature,
            .profileEditorFeature,
            .profileFeature,
            .promoFeature,
            .promoStripFeature,
            .shopFeature,
            .shopGridFeature,
            .shopTypeFeature,
            .shopTypeStripFeature,
            .showProfileButtonFeature,
            // Services
            .addressSearchService,
        ]
    )
    
    static let deliveryTypePickerFeature = target(
        name: .deliveryTypePickerFeature,
        dependencies: [
            .domain
        ]
    )
    static let featuredShopsFeature = target(
        name: .featuredShopsFeature,
        dependencies: [
            .domain
        ]
    )
    static let featureViewFeature = target(
        name: .featureViewFeature,
        dependencies: [
            .domain
        ]
    )
    static let mainPageFeature = target(
        name: .mainPageFeature,
        dependencies: [
            .domain
        ]
    )
    static let mapKitMapFeature = target(
        name: .mapKitMapFeature,
        dependencies: [
            .mapDomain
        ]
    )
    static let newAppFeatureFeature = target(
        name: .newAppFeatureFeature,
        dependencies: [
            .domain
        ]
    )
    static let profileEditorFeature = target(
        name: .profileEditorFeature,
        dependencies: [
            .domain,
            .swiftUINavigation,
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
            .deliveryTypePickerFeature,
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

    static let addNewAddressFeature = byName(name: .addNewAddressFeature)
    static let addressMapSearchFeature = byName(name: .addressMapSearchFeature)
    static let addressPickerFeature = byName(name: .addressPickerFeature)
    static let addressViewFeature = byName(name: .addressViewFeature)
    static let deliveryTypePickerFeature = byName(name: .deliveryTypePickerFeature)
    static let featuredShopsFeature = byName(name: .featuredShopsFeature)
    static let featureViewFeature = byName(name: .featureViewFeature)
    static let mainPageFeature = byName(name: .mainPageFeature)
    static let mapKitMapFeature = byName(name: .mapKitMapFeature)
    static let newAppFeatureFeature = byName(name: .newAppFeatureFeature)
    static let profileEditorFeature = byName(name: .profileEditorFeature)
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

    static let addNewAddressFeature = "AddNewAddressFeature"
    static let addressMapSearchFeature = "AddressMapSearchFeature"
    static let addressMapSearchFeatureTests = "AddressMapSearchFeatureTests"
    static let addressPickerFeature = "AddressPickerFeature"
    static let addressViewFeature = "AddressViewFeature"
    static let appFeature = "AppFeature"
    static let deliveryTypePickerFeature = "DeliveryTypePickerFeature"
    static let featuredShopsFeature = "FeaturedShopsFeature"
    static let featureViewFeature = "FeatureViewFeature"
    static let mainPageFeature = "MainPageFeature"
    static let mapKitMapFeature = "MapKitMapFeature"
    static let newAppFeatureFeature = "NewAppFeatureFeature"
    static let profileEditorFeature = "ProfileEditorFeature"
    static let profileFeature = "ProfileFeature"
    static let promoFeature = "PromoFeature"
    static let promoStripFeature = "PromoStripFeature"
    static let shopFeature = "ShopFeature"
    static let shopGridFeature = "ShopGridFeature"
    static let shopTypeFeature = "ShopTypeFeature"
    static let shopTypeStripFeature = "ShopTypeStripFeature"
    static let showProfileButtonFeature = "ShowProfileButtonFeature"
}

// MARK: - Services

private extension Product {
    
    static let addressSearchService = library(
        name: .addressSearchService,
        targets: [.addressSearchService]
    )
    static let geocoderAddressCoordinateSearch = library(
        name: .geocoderAddressCoordinateSearch,
        targets: [.geocoderAddressCoordinateSearch]
    )
}

private extension Target {
    
    static let addressSearchService = target(
        name: .addressSearchService,
        dependencies: [
            .mapDomain,
        ]
    )
    static let addressSearchServiceTests = testTarget(
        name: .addressSearchServiceTests,
        dependencies: [
            .addressSearchService,
            .casePaths,
            .mapDomain,
            .snapshotTesting,
        ]
    )
    static let geocoderAddressCoordinateSearch = target(
        name: .geocoderAddressCoordinateSearch,
        dependencies: [
            .mapDomain,
        ]
    )
}

private extension Target.Dependency {
    
    static let addressSearchService = byName(name: .addressSearchService)
    static let geocoderAddressCoordinateSearch = byName(name: .geocoderAddressCoordinateSearch)
}

private extension String {
    
    static let addressSearchService = "AddressSearchService"
    static let addressSearchServiceTests = "AddressSearchServiceTests"
    static let geocoderAddressCoordinateSearch = "GeocoderAddressCoordinateSearch"
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
