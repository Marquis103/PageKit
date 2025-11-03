//
//  ThemeEnvironment.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

// MARK: - ThemeEnvironmentKey

private struct ThemeEnvironmentKey: EnvironmentKey {
	// Note: Default theme removed - you must provide your own Theme implementation
	// Set theme at your app's root: MyView().environment(\.theme, myTheme)
	static let defaultValue: Theme? = nil
}

extension EnvironmentValues {
	var theme: Theme {
		get { self[ThemeEnvironmentKey.self]! }
		set { self[ThemeEnvironmentKey.self] = newValue }
	}
}
