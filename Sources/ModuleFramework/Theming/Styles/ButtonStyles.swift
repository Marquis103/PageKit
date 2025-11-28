//
//  ButtonStyles.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

public struct ButtonStyles {
	public struct ButtonStyle {
		public let backgroundColor: Color
		public let contentColor: Color
		public let cornerRadius: CGFloat
		public let border: (color: Color, width: CGFloat)?

		public init(
			backgroundColor: Color,
			contentColor: Color,
			cornerRadius: CGFloat,
			border: (color: Color, width: CGFloat)? = nil
		) {
			self.backgroundColor = backgroundColor
			self.contentColor = contentColor
			self.cornerRadius = cornerRadius
			self.border = border
		}
	}

	public let primary: ButtonStyle
	public let secondary: ButtonStyle
	public let destructive: ButtonStyle
	public let ghost: ButtonStyle
	public let link: ButtonStyle

	public init(
		primary: ButtonStyle,
		secondary: ButtonStyle,
		destructive: ButtonStyle,
		ghost: ButtonStyle,
		link: ButtonStyle
	) {
		self.primary = primary
		self.secondary = secondary
		self.destructive = destructive
		self.ghost = ghost
		self.link = link
	}
}
