//
//  ColorStyles.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

public struct ColorStyles {
	public struct TextColors {
		public let primary: Color
		public let secondary: Color
		public let tertiary: Color
		public let inverted: Color

		public init(primary: Color, secondary: Color, tertiary: Color, inverted: Color) {
			self.primary = primary
			self.secondary = secondary
			self.tertiary = tertiary
			self.inverted = inverted
		}
	}

	public struct BackgroundColors {
		public let primary: Color
		public let secondary: Color
		public let tertiary: Color

		public init(primary: Color, secondary: Color, tertiary: Color) {
			self.primary = primary
			self.secondary = secondary
			self.tertiary = tertiary
		}
	}

	public struct AccentColors {
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

		public init(aqua: Color, blue: Color, gold: Color, green: Color, lime: Color, orange: Color, purple: Color, red: Color, salmon: Color, silver: Color, yellow: Color) {
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
	}

	public let primary: Color
	public let positive: Color
	public let destructive: Color
	public let text: TextColors
	public let background: BackgroundColors
	public let accent: AccentColors
	public let divider: Color

	public init(primary: Color, positive: Color, destructive: Color, text: TextColors, background: BackgroundColors, accent: AccentColors, divider: Color) {
		self.primary = primary
		self.positive = positive
		self.destructive = destructive
		self.text = text
		self.background = background
		self.accent = accent
		self.divider = divider
	}
}
