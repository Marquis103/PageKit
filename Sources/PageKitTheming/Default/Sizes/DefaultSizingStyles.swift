//
//  DefaultSizingStyles.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

// MARK: - DefaultTextSizes

public struct DefaultTextSizes: TextSizesProviding {
	public let xxsmall: CGFloat
	public let xsmall: CGFloat
	public let small: CGFloat
	public let medium: CGFloat
	public let large: CGFloat
	public let xlarge: CGFloat
	public let xxlarge: CGFloat
	public let hero: CGFloat

	public init(
		xxsmall: CGFloat,
		xsmall: CGFloat,
		small: CGFloat,
		medium: CGFloat,
		large: CGFloat,
		xlarge: CGFloat,
		xxlarge: CGFloat,
		hero: CGFloat
	) {
		self.xxsmall = xxsmall
		self.xsmall = xsmall
		self.small = small
		self.medium = medium
		self.large = large
		self.xlarge = xlarge
		self.xxlarge = xxlarge
		self.hero = hero
	}

	/// Standard text size scale
	public static var standard: DefaultTextSizes {
		DefaultTextSizes(
			xxsmall: 10,
			xsmall: 12,
			small: 14,
			medium: 16,
			large: 18,
			xlarge: 24,
			xxlarge: 32,
			hero: 48
		)
	}
}

// MARK: - DefaultIconSizes

public struct DefaultIconSizes: IconSizesProviding {
	public let xxsmall: CGFloat
	public let xsmall: CGFloat
	public let small: CGFloat
	public let medium: CGFloat
	public let large: CGFloat
	public let xlarge: CGFloat

	public init(
		xxsmall: CGFloat,
		xsmall: CGFloat,
		small: CGFloat,
		medium: CGFloat,
		large: CGFloat,
		xlarge: CGFloat
	) {
		self.xxsmall = xxsmall
		self.xsmall = xsmall
		self.small = small
		self.medium = medium
		self.large = large
		self.xlarge = xlarge
	}

	/// Standard icon size scale
	public static var standard: DefaultIconSizes {
		DefaultIconSizes(
			xxsmall: 12,
			xsmall: 16,
			small: 20,
			medium: 24,
			large: 32,
			xlarge: 48
		)
	}
}

// MARK: - DefaultButtonSize

public struct DefaultButtonSize: ButtonSizeProviding {
	public let textSize: CGFloat
	public let contentPadding: EdgeInsets

	public init(textSize: CGFloat, contentPadding: EdgeInsets) {
		self.textSize = textSize
		self.contentPadding = contentPadding
	}
}

// MARK: - DefaultButtonSizes

public struct DefaultButtonSizes: ButtonSizesProviding {
	public let small: DefaultButtonSize
	public let medium: DefaultButtonSize
	public let large: DefaultButtonSize
	public let xlarge: DefaultButtonSize

	public init(
		small: DefaultButtonSize,
		medium: DefaultButtonSize,
		large: DefaultButtonSize,
		xlarge: DefaultButtonSize
	) {
		self.small = small
		self.medium = medium
		self.large = large
		self.xlarge = xlarge
	}

	/// Standard button size scale
	public static var standard: DefaultButtonSizes {
		DefaultButtonSizes(
			small: DefaultButtonSize(
				textSize: 12,
				contentPadding: EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
			),
			medium: DefaultButtonSize(
				textSize: 14,
				contentPadding: EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
			),
			large: DefaultButtonSize(
				textSize: 16,
				contentPadding: EdgeInsets(top: 14, leading: 24, bottom: 14, trailing: 24)
			),
			xlarge: DefaultButtonSize(
				textSize: 18,
				contentPadding: EdgeInsets(top: 18, leading: 32, bottom: 18, trailing: 32)
			)
		)
	}
}

// MARK: - DefaultSizingStyles

public struct DefaultSizingStyles: SizingStylesProviding {
	public let text: DefaultTextSizes
	public let icons: DefaultIconSizes
	public let buttons: DefaultButtonSizes

	public init(
		text: DefaultTextSizes,
		icons: DefaultIconSizes,
		buttons: DefaultButtonSizes
	) {
		self.text = text
		self.icons = icons
		self.buttons = buttons
	}

	/// Standard sizing configuration
	public static var standard: DefaultSizingStyles {
		DefaultSizingStyles(
			text: .standard,
			icons: .standard,
			buttons: .standard
		)
	}
}
