//
//  DefaultTypographyStyles.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

// MARK: - SystemFontFamily

/// Default font family using system fonts
public struct SystemFontFamily: FontFamilyProviding {
	public init() {}

	public func font(weight: ThemeFontWeight, size: CGFloat) -> Font {
		.system(size: size, weight: weight.swiftUIWeight)
	}
}

// MARK: - DefaultTextStyle

public struct DefaultTextStyle: TextStyleProviding {
	public let color: Color
	public let fontWeight: ThemeFontWeight
	public let size: CGFloat

	public init(color: Color, fontWeight: ThemeFontWeight, size: CGFloat) {
		self.color = color
		self.fontWeight = fontWeight
		self.size = size
	}
}

// MARK: - DefaultTextStyles

public struct DefaultTextStyles: TextStylesProviding {
	public let hero: DefaultTextStyle
	public let h1: DefaultTextStyle
	public let h2: DefaultTextStyle
	public let h3: DefaultTextStyle
	public let title: DefaultTextStyle
	public let subtitle: DefaultTextStyle
	public let body: DefaultTextStyle
	public let link: DefaultTextStyle

	public init(
		hero: DefaultTextStyle,
		h1: DefaultTextStyle,
		h2: DefaultTextStyle,
		h3: DefaultTextStyle,
		title: DefaultTextStyle,
		subtitle: DefaultTextStyle,
		body: DefaultTextStyle,
		link: DefaultTextStyle
	) {
		self.hero = hero
		self.h1 = h1
		self.h2 = h2
		self.h3 = h3
		self.title = title
		self.subtitle = subtitle
		self.body = body
		self.link = link
	}

	/// Creates standard text styles with the given colors
	public static func standard(
		primaryColor: Color = .primary,
		secondaryColor: Color = .secondary,
		linkColor: Color = .blue
	) -> DefaultTextStyles {
		DefaultTextStyles(
			hero: DefaultTextStyle(color: primaryColor, fontWeight: .bold, size: 48),
			h1: DefaultTextStyle(color: primaryColor, fontWeight: .bold, size: 32),
			h2: DefaultTextStyle(color: primaryColor, fontWeight: .semiBold, size: 24),
			h3: DefaultTextStyle(color: primaryColor, fontWeight: .semiBold, size: 20),
			title: DefaultTextStyle(color: primaryColor, fontWeight: .medium, size: 18),
			subtitle: DefaultTextStyle(color: secondaryColor, fontWeight: .medium, size: 16),
			body: DefaultTextStyle(color: primaryColor, fontWeight: .medium, size: 16),
			link: DefaultTextStyle(color: linkColor, fontWeight: .medium, size: 16)
		)
	}
}

// MARK: - DefaultTypographyStyles

public struct DefaultTypographyStyles: TypographyStylesProviding {
	public let fontFamily: SystemFontFamily
	public let textStyles: DefaultTextStyles

	public init(
		fontFamily: SystemFontFamily = SystemFontFamily(),
		textStyles: DefaultTextStyles
	) {
		self.fontFamily = fontFamily
		self.textStyles = textStyles
	}

	/// Standard typography configuration
	public static var standard: DefaultTypographyStyles {
		DefaultTypographyStyles(
			fontFamily: SystemFontFamily(),
			textStyles: .standard()
		)
	}
}
