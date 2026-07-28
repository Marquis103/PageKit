//
//  PageKitExports.swift
//
//  Copyright © 2026 PageKit All rights reserved.
//

// Since 2.0.0 (PE-533) `PageKit` is an umbrella over the split halves:
// - PageKitCore: the portable page system (no UIKit, no Combine) —
//   Page family, view state/model, events, CoordinatableAction,
//   Coordinating, AsyncStream signals.
// - PageKitUIKit: Coordinator base, NavigationAction, host/sheet/modal
//   controllers.
//
// Existing consumers `import PageKit` and compile unchanged; new
// portable targets (e.g. Android-bound feature modules) import
// PageKitCore alone.

@_exported import PageKitCore
@_exported import PageKitUIKit
