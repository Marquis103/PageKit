//
//  DefaultColorStyles.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

// MARK: - DefaultTextColors

public struct DefaultTextColors: TextColorsProviding {
	public let primary: Color
	public let secondary: Color
	public let tertiary: Color
	public let inverted: Color

	public init(
		primary: Color,
		secondary: Color,
		tertiary: Color,
		inverted: Color
	) {
		self.primary = primary
		self.secondary = secondary
		self.tertiary = tertiary
		self.inverted = inverted
	}
}

// MARK: - DefaultBackgroundColors

public struct DefaultBackgroundColors: BackgroundColorsProviding {
	public let primary: Color
	public let secondary: Color
	public let tertiary: Color

	public init(
		primary: Color,
		secondary: Color,
		tertiary: Color
	) {
		self.primary = primary
		self.secondary = secondary
		self.tertiary = tertiary
	}
}

// MARK: - DefaultAccentColors

public struct DefaultAccentColors: AccentColorsProviding {
	public let aqua: Color
	public let blue: Color
	public let gold: Color
	public let green: Color
	public let lime: Color
	public let orange: Color
	public let purple: Color
	public let red: Color
	public let salmon: Color
	public let silver: Color
	public let yellow: Color

	public init(
		aqua: Color,
		blue: Color,
		gold: Color,
		green: Color,
		lime: Color,
		orange: Color,
		purple: Color,
		red: Color,
		salmon: Color,
		silver: Color,
		yellow: Color
	) {
		self.aqua = aqua
		self.blue = blue
		self.gold = gold
		self.green = green
		self.lime = lime
		self.orange = orange
		self.purple = purple
		self.red = red
		self.salmon = salmon
		self.silver = silver
		self.yellow = yellow
	}

	/// Creates a standard accent color palette
	public static var standard: DefaultAccentColors {
		DefaultAccentColors(
			aqua: Color(red: 0, green: 0.8, blue: 0.8),
			blue: .blue,
			gold: Color(red: 1, green: 0.84, blue: 0),
			green: .green,
			lime: Color(red: 0.5, green: 1, blue: 0),
			orange: .orange,
			purple: .purple,
			red: .red,
			salmon: Color(red: 1, green: 0.5, blue: 0.5),
			silver: Color(red: 0.75, green: 0.75, blue: 0.75),
			yellow: .yellow
		)
	}
}

// MARK: - DefaultColorStyles

public struct DefaultColorStyles: ColorStylesProviding {
	public let primary: Color
	public let positive: Color
	public let destructive: Color
	public let text: DefaultTextColors
	public let background: DefaultBackgroundColors
	public let accent: DefaultAccentColors
	public let divider: Color

	public init(
		primary: Color,
		positive: Color,
		destructive: Color,
		text: DefaultTextColors,
		background: DefaultBackgroundColors,
		accent: DefaultAccentColors,
		divider: Color
	) {
		self.primary = primary
		self.positive = positive
		self.destructive = destructive
		self.text = text
		self.background = background
		self.accent = accent
		self.divider = divider
	}

	/// Creates standard light mode color styles
	public static var light: DefaultColorStyles {
		DefaultColorStyles(
			primary: .blue,
			positive: .green,
			destructive: .red,
			text: DefaultTextColors(
				primary: .black,
				secondary: .gray,
				tertiary: .gray.opacity(0.6),
				inverted: .white
			),
			background: DefaultBackgroundColors(
				primary: .white,
				secondary: Color(uiColor: .systemGray6),
				tertiary: Color(uiColor: .systemGray5)
			),
			accent: .standard,
			divider: .gray.opacity(0.3)
		)
	}

	/// Creates standard dark mode color styles
	public static var dark: DefaultColorStyles {
		DefaultColorStyles(
			primary: .blue,
			positive: .green,
			destructive: .red,
			text: DefaultTextColors(
				primary: .white,
				secondary: .gray,
				tertiary: .gray.opacity(0.6),
				inverted: .black
			),
			background: DefaultBackgroundColors(
				primary: .black,
				secondary: Color(uiColor: .systemGray6),
				tertiary: Color(uiColor: .systemGray5)
			),
			accent: .standard,
			divider: .gray.opacity(0.3)
		)
	}
}
