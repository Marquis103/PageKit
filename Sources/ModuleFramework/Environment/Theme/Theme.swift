//
//  Theme.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation

public struct Theme {
	public let buttons: ButtonStyles
	public let colors: ColorStyles
	public let sizing: SizingStyles
	public let spacing: SpacingStyles
	public let typography: TypographyStyles

	public init(
		buttons: ButtonStyles,
		colors: ColorStyles,
		sizing: SizingStyles,
		spacing: SpacingStyles,
		typography: TypographyStyles
	) {
		self.buttons = buttons
		self.colors = colors
		self.sizing = sizing
		self.spacing = spacing
		self.typography = typography
	}
}
