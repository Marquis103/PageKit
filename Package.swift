// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PageKit",
    platforms: [
        .iOS(.v17), .macOS(.v14)  // PE-536/E4 spike: macOS for skip host builds
    ],
    dependencies: [
        // PE-536/E4 spike/android: SkipFuseUI's product carries a target named
        // `SwiftUI` when TARGET_OS_ANDROID=1 — the mapping for `import SwiftUI`.
        .package(url: "https://source.skip.tools/skip-fuse-ui.git", from: "1.0.0"),
    ],
    products: [
        // Portable page system — no UIKit, no Combine (PE-533 split).
        // The Android-compatible core: Page family, view state/model,
        // events, CoordinatableAction, Coordinating, AsyncStream signals.
        .library(
            name: "PageKitCore",
            targets: ["PageKitCore"]
        ),
        // UIKit coordination + hosting: Coordinator base, NavigationAction,
        // host/sheet/modal controllers. iOS-only half of the split.
        .library(
            name: "PageKitUIKit",
            targets: ["PageKitUIKit"]
        ),
        // Core page system with coordination and navigation.
        // Since 2.0.0 this is an umbrella re-exporting PageKitCore +
        // PageKitUIKit, so existing consumers compile unchanged.
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
        // Multi-page container system for iPad - requires core
        .library(
            name: "PageKitContainers",
            targets: ["PageKitContainers"]
        ),
        // Umbrella module - includes all core packages
        .library(
            name: "PageFramework",
            targets: ["PageFramework"]
        ),
    ],
    targets: [
        // Portable core — the split's whole point is this target staying
        // free of UIKit and Combine (grep-gated by PageKitCoreTests).
        .target(
            name: "PageKitCore",
            dependencies: [
                .product(name: "SkipFuseUI", package: "skip-fuse-ui"),],
            path: "Sources/PageKitCore"
        ),
        // UIKit half — depends on Core for the portable contracts.
        .target(
            name: "PageKitUIKit",
            dependencies: ["PageKitCore"],
            path: "Sources/PageKitUIKit"
        ),
        // Umbrella shim: @_exported re-exports of Core + UIKit. Keeps the
        // `PageKit` product/module name every consumer already imports.
        .target(
            name: "PageKit",
            dependencies: ["PageKitCore", "PageKitUIKit"],
            path: "Sources/PageKit"
        ),
        // Theming system - standalone, no dependencies
        .target(
            name: "PageKitTheming",
            dependencies: [
                .product(name: "SkipFuseUI", package: "skip-fuse-ui"),],
            path: "Sources/PageKitTheming"
        ),
        // UI components - depends on theming and core (for PageEventHandler)
        .target(
            name: "PageKitUI",
            dependencies: [
                .product(name: "SkipFuseUI", package: "skip-fuse-ui"),
                "PageKitTheming",
                "PageKitCore",  // PE-536/E4 spike: umbrella (UIKit half) detached for Android
            ],
            path: "Sources/PageKitUI"
        ),
        // Form system - depends on core
        .target(
            name: "PageKitForms",
            dependencies: ["PageKit"],
            path: "Sources/PageKitForms"
        ),
        // Container system - depends on core for multi-page iPad layouts
        .target(
            name: "PageKitContainers",
            dependencies: ["PageKit"],
            path: "Sources/PageKitContainers"
        ),
        // Umbrella module - combines all core packages
        .target(
            name: "PageFramework",
            dependencies: ["PageKit", "PageKitTheming", "PageKitUI", "PageKitForms"],
            path: "Sources/PageFramework"
        ),
        // Tests
        .testTarget(
            name: "PageKitCoreTests",
            dependencies: ["PageKitCore"]
        ),
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
