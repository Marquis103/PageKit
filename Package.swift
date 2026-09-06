// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// PageKit's Android participation is gated on SKIP_ANDROID, a variable the
// consuming Skip app's build owns and exports for the WHOLE gradle session
// (`SKIP_ANDROID=1 gradle -p Android launchDebug`; the Ayes repo exports it in
// its android CI job and Scripts/skip-env.sh). Skip's own TARGET_OS_ANDROID
// cannot serve here: skip's tooling sets it selectively for Android-destination
// compiles only — the skipstone plugin/transpile pass runs WITHOUT it, and
// exporting it globally breaks skip-fuse-ui's own host compile (circular
// SwiftUI/SkipSwiftUI modules; measured 2026-09-06).
// When SKIP_ANDROID is unset — every Xcode build, every iOS consumer — this
// manifest declares ZERO package dependencies and no plugins, so iOS consumers
// resolve exactly the 2.0.0 graph: no skip binary artifact, no skipstone runs.
// When set, the three Android-graph targets gain the SkipFuseUI product (the
// `import SwiftUI` mapping for the Android triple) and the skipstone plugin.
// The `?? "0" != "0"` idiom mirrors skip-fuse-ui's manifest: "" reads as ON.
let android = Context.environment["SKIP_ANDROID"] ?? "0" != "0"

let skipstonePlugins: [Target.PluginUsage] = android
    ? [.plugin(name: "skipstone", package: "skip")]
    : []
let skipFuseUIDependency: [Target.Dependency] = android
    ? [.product(name: "SkipFuseUI", package: "skip-fuse-ui")]
    : []

let package = Package(
    name: "PageKit",
    platforms: [
        .iOS(.v17),  // All packages require iOS 17+ for @Observable support
        .macOS(.v14)  // resolution floor for the Skip Android graph (host tooling); iOS-neutral
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
    dependencies: android ? [
        .package(url: "https://source.skip.tools/skip.git", from: "1.9.4"),
        .package(url: "https://source.skip.tools/skip-fuse-ui.git", from: "1.0.0"),
    ] : [],
    targets: [
        // Portable core — the split's whole point is this target staying
        // free of UIKit and Combine (grep-gated by PageKitCoreTests).
        .target(
            name: "PageKitCore",
            dependencies: [] + skipFuseUIDependency,
            path: "Sources/PageKitCore",
            plugins: skipstonePlugins
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
            dependencies: [] + skipFuseUIDependency,
            path: "Sources/PageKitTheming",
            plugins: skipstonePlugins
        ),
        // UI components - depends on theming and core (for PageEventHandler).
        // Depends on PageKitCore directly, NOT the PageKit umbrella: the umbrella
        // carries PageKitUIKit, which must never enter the Android graph. The
        // umbrella @_exports Core, so iOS consumers see the identical API.
        .target(
            name: "PageKitUI",
            dependencies: ["PageKitTheming", "PageKitCore"] + skipFuseUIDependency,
            path: "Sources/PageKitUI",
            plugins: skipstonePlugins
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
