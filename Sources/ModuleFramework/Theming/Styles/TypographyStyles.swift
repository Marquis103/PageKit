//
//  TypographyStyles.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

public struct TypographyStyles {
	public struct TextStyles {
		public struct TextStyle {
			public let color: Color
			public let fontFamily: FontFamily
			public let fontWeight: FontWeight

			public init(color: Color, fontFamily: FontFamily, fontWeight: FontWeight) {
				self.color = color
				self.fontFamily = fontFamily
				self.fontWeight = fontWeight
			}
		}

		public let hero: TextStyle
		public let h1: TextStyle
		public let h2: TextStyle
		public let h3: TextStyle
		public let title: TextStyle
		public let subtitle: TextStyle
		public let body: TextStyle
		public let link: TextStyle

		public init(hero: TextStyle, h1: TextStyle, h2: TextStyle, h3: TextStyle, title: TextStyle, subtitle: TextStyle, body: TextStyle, link: TextStyle) {
			self.hero = hero
			self.h1 = h1
			self.h2 = h2
			self.h3 = h3
			self.title = title
			self.subtitle = subtitle
			self.body = body
			self.link = link
		}
	}

	public let fontFamily: FontFamily
	public let textStyles: TextStyles

	public init(fontFamily: FontFamily, textStyles: TextStyles) {
		self.fontFamily = fontFamily
		self.textStyles = textStyles
	}
}
