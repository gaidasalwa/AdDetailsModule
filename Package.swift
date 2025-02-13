// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AdDetailsModule",
    platforms: [
        .iOS(.v15) // ✅ Spécifie que le module supporte iOS 13 minimum
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AdDetailsModule",
            targets: ["AdDetailsModule"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.8.0"),
        .package(url: "https://github.com/gaidasalwa/AppModels.git", from: "1.0.0"),
        .package(url: "https://github.com/gaidasalwa/CoreModule.git", from: "1.0.0"),
        .package(url: "https://github.com/gaidasalwa/AppDI.git", from: "1.0.0"),
        .package(url: "https://github.com/gaidasalwa/Extensions.git", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AdDetailsModule",
            dependencies: ["RxSwift", "AppModels", "CoreModule", "AppDI", "Extensions", .product(name: "RxCocoa", package: "RxSwift")]
        ),
        .testTarget(
            name: "AdDetailsModuleTests",
            dependencies: ["AdDetailsModule"]
        ),
    ]
)
