//
//  DefaultButtonStyles.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

// MARK: - DefaultButtonStyle

public struct DefaultButtonStyle: ButtonStyleProviding {
	public let backgroundColor: Color
	public let contentColor: Color
	public let cornerRadius: CGFloat
	public let borderColor: Color?
	public let borderWidth: CGFloat

	public init(
		backgroundColor: Color,
		contentColor: Color,
		cornerRadius: CGFloat,
		borderColor: Color? = nil,
		borderWidth: CGFloat = 0
	) {
		self.backgroundColor = backgroundColor
		self.contentColor = contentColor
		self.cornerRadius = cornerRadius
		self.borderColor = borderColor
		self.borderWidth = borderWidth
	}
}

// MARK: - DefaultButtonStyles

public struct DefaultButtonStyles: ButtonStylesProviding {
	public let primary: DefaultButtonStyle
	public let secondary: DefaultButtonStyle
	public let destructive: DefaultButtonStyle
	public let ghost: DefaultButtonStyle
	public let link: DefaultButtonStyle

	public init(
		primary: DefaultButtonStyle,
		secondary: DefaultButtonStyle,
		destructive: DefaultButtonStyle,
		ghost: DefaultButtonStyle,
		link: DefaultButtonStyle
	) {
		self.primary = primary
		self.secondary = secondary
		self.destructive = destructive
		self.ghost = ghost
		self.link = link
	}

	/// Creates default button styles with standard configuration
	public static func standard(
		primaryColor: Color = .blue,
		destructiveColor: Color = .red,
		textColor: Color = .primary,
		backgroundColor: Color = .gray.opacity(0.1)
	) -> DefaultButtonStyles {
		DefaultButtonStyles(
			primary: DefaultButtonStyle(
				backgroundColor: primaryColor,
				contentColor: .white,
				cornerRadius: 8
			),
			secondary: DefaultButtonStyle(
				backgroundColor: backgroundColor,
				contentColor: textColor,
				cornerRadius: 8
			),
			destructive: DefaultButtonStyle(
				backgroundColor: destructiveColor,
				contentColor: .white,
				cornerRadius: 8
			),
			ghost: DefaultButtonStyle(
				backgroundColor: .clear,
				contentColor: textColor,
				cornerRadius: 8,
				borderColor: textColor.opacity(0.3),
				borderWidth: 1
			),
			link: DefaultButtonStyle(
				backgroundColor: .clear,
				contentColor: primaryColor,
				cornerRadius: 0
			)
		)
	}
}
