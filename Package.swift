// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PageKit",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Core page system with coordination and navigation
        .library(
            name: "PageKit",
            targets: ["PageKit"]
        ),
        // Protocol-based theming system
        .library(
            name: "PageKitTheming",
            targets: ["PageKitTheming"]
        ),
        // UI components (buttons, icons, text) - requires theming
        .library(
            name: "PageKitUI",
            targets: ["PageKitUI"]
        ),
        // Form handling system - requires core
        .library(
            name: "PageKitForms",
            targets: ["PageKitForms"]
        ),
        // Legacy support - includes all packages
        .library(
            name: "ModuleFramework",
            targets: ["ModuleFramework"]
        ),
    ],
    targets: [
        // Core page system - standalone, no dependencies
        .target(
            name: "PageKit",
            dependencies: [],
            path: "Sources/PageKit"
        ),
        // Theming system - standalone, no dependencies
        .target(
            name: "PageKitTheming",
            dependencies: [],
            path: "Sources/PageKitTheming"
        ),
        // UI components - depends on theming
        .target(
            name: "PageKitUI",
            dependencies: ["PageKitTheming"],
            path: "Sources/PageKitUI"
        ),
        // Form system - depends on core
        .target(
            name: "PageKitForms",
            dependencies: ["PageKit"],
            path: "Sources/PageKitForms"
        ),
        // Legacy module - combines all for backwards compatibility
        .target(
            name: "ModuleFramework",
            dependencies: ["PageKit", "PageKitTheming", "PageKitUI", "PageKitForms"],
            path: "Sources/ModuleFramework"
        ),
        // Tests
        .testTarget(
            name: "PageKitTests",
            dependencies: ["PageKit"]
        ),
        .testTarget(
            name: "PageKitThemingTests",
            dependencies: ["PageKitTheming"]
        ),
        .testTarget(
            name: "PageKitUITests",
            dependencies: ["PageKitUI", "PageKitTheming"]
        ),
        .testTarget(
            name: "PageKitFormsTests",
            dependencies: ["PageKitForms", "PageKit"]
        ),
    ]
)
