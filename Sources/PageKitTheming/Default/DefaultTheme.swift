//
//  DefaultTheme.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

// MARK: - DefaultTheme

/// A complete default theme implementation using all default style types
/// Use this as a starting point or reference implementation for custom themes
public struct DefaultTheme: Themeable {
	public let buttons: DefaultButtonStyles
	public let colors: DefaultColorStyles
	public let sizing: DefaultSizingStyles
	public let spacing: DefaultSpacingStyles
	public let typography: DefaultTypographyStyles

	public init(
		buttons: DefaultButtonStyles,
		colors: DefaultColorStyles,
		sizing: DefaultSizingStyles,
		spacing: DefaultSpacingStyles,
		typography: DefaultTypographyStyles
	) {
		self.buttons = buttons
		self.colors = colors
		self.sizing = sizing
		self.spacing = spacing
		self.typography = typography
	}

	/// Creates a standard light theme
	public static var light: DefaultTheme {
		let colors = DefaultColorStyles.light
		return DefaultTheme(
			buttons: .standard(
				primaryColor: colors.primary,
				destructiveColor: colors.destructive,
				textColor: colors.text.primary,
				backgroundColor: colors.background.secondary
			),
			colors: colors,
			sizing: .standard,
			spacing: .standard,
			typography: DefaultTypographyStyles(
				textStyles: .standard(
					primaryColor: colors.text.primary,
					secondaryColor: colors.text.secondary,
					linkColor: colors.primary
				)
			)
		)
	}

	/// Creates a standard dark theme
	public static var dark: DefaultTheme {
		let colors = DefaultColorStyles.dark
		return DefaultTheme(
			buttons: .standard(
				primaryColor: colors.primary,
				destructiveColor: colors.destructive,
				textColor: colors.text.primary,
				backgroundColor: colors.background.secondary
			),
			colors: colors,
			sizing: .standard,
			spacing: .standard,
			typography: DefaultTypographyStyles(
				textStyles: .standard(
					primaryColor: colors.text.primary,
					secondaryColor: colors.text.secondary,
					linkColor: colors.primary
				)
			)
		)
	}
}
