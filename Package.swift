// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "swift-explore-navigation",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .shopUIPrototype,
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "ShopUIPrototype"),
    ]
)

extension Product {
    
    static let shopUIPrototype = library(
        name: "ShopUIPrototype",
        targets: ["ShopUIPrototype"]
    )
}

extension Target {
    
    static let shopUIPrototype = target(name: .shopUIPrototype)
}

extension String {
    
    static let shopUIPrototype = "ShopUIPrototype"
}
