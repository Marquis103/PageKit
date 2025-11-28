//
//  ThemeEnvironment.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

// MARK: - AnyTheme

/// Type-erased theme wrapper for use with SwiftUI Environment
/// This allows any Themeable implementation to be used in the environment
public struct AnyTheme {
	private let _buttons: () -> any ButtonStylesProviding
	private let _colors: () -> any ColorStylesProviding
	private let _sizing: () -> any SizingStylesProviding
	private let _spacing: () -> any SpacingStylesProviding
	private let _typography: () -> any TypographyStylesProviding

	public init<T: Themeable>(_ theme: T) {
		_buttons = { theme.buttons }
		_colors = { theme.colors }
		_sizing = { theme.sizing }
		_spacing = { theme.spacing }
		_typography = { theme.typography }
	}

	public var buttons: any ButtonStylesProviding { _buttons() }
	public var colors: any ColorStylesProviding { _colors() }
	public var sizing: any SizingStylesProviding { _sizing() }
	public var spacing: any SpacingStylesProviding { _spacing() }
	public var typography: any TypographyStylesProviding { _typography() }
}

// MARK: - ThemeEnvironmentKey

private struct ThemeEnvironmentKey: EnvironmentKey {
	static let defaultValue: AnyTheme? = nil
}

extension EnvironmentValues {
	public var theme: AnyTheme {
		get { self[ThemeEnvironmentKey.self]! }
		set { self[ThemeEnvironmentKey.self] = newValue }
	}

	public var optionalTheme: AnyTheme? {
		get { self[ThemeEnvironmentKey.self] }
		set { self[ThemeEnvironmentKey.self] = newValue }
	}
}

// MARK: - View Extension

extension View {
	/// Sets the theme for this view and its descendants
	public func theme<T: Themeable>(_ theme: T) -> some View {
		environment(\.theme, AnyTheme(theme))
	}
}
