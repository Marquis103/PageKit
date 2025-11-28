//
//  ButtonSize.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI
import PageKitTheming

/// Resolved button size configuration
public struct ResolvedButtonSize {
	public let textSize: CGFloat
	public let contentPadding: EdgeInsets

	public init(textSize: CGFloat, contentPadding: EdgeInsets) {
		self.textSize = textSize
		self.contentPadding = contentPadding
	}
}

/// Defines standard button size options with theme integration
public enum ButtonSize {
	case small
	case medium
	case large
	case xlarge
	case custom(ResolvedButtonSize)

	/// Resolves the button size configuration from the theme
	/// - Parameter theme: The current theme containing button size definitions
	/// - Returns: The resolved button size configuration
	public func resolve(from theme: AnyTheme) -> ResolvedButtonSize {
		switch self {
			case .small:
				ResolvedButtonSize(
					textSize: theme.sizing.buttons.small.textSize,
					contentPadding: theme.sizing.buttons.small.contentPadding
				)
			case .medium:
				ResolvedButtonSize(
					textSize: theme.sizing.buttons.medium.textSize,
					contentPadding: theme.sizing.buttons.medium.contentPadding
				)
			case .large:
				ResolvedButtonSize(
					textSize: theme.sizing.buttons.large.textSize,
					contentPadding: theme.sizing.buttons.large.contentPadding
				)
			case .xlarge:
				ResolvedButtonSize(
					textSize: theme.sizing.buttons.xlarge.textSize,
					contentPadding: theme.sizing.buttons.xlarge.contentPadding
				)
			case let .custom(size):
				size
		}
	}
}
