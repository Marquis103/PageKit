//
//  TextSize.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation
import PageKitTheming

/// Defines standard text size options with theme integration
public enum TextSize {
	case xxsmall
	case xsmall
	case small
	case medium
	case large
	case xlarge
	case xxlarge
	case hero
	case custom(CGFloat)

	/// Resolves the text size to a CGFloat value using the theme's sizing configuration
	/// - Parameter theme: The current theme containing size definitions
	/// - Returns: The resolved text size in points
	public func resolve(from theme: AnyTheme) -> CGFloat {
		switch self {
			case .xxsmall: theme.sizing.text.xxsmall
			case .xsmall: theme.sizing.text.xsmall
			case .small: theme.sizing.text.small
			case .medium: theme.sizing.text.medium
			case .large: theme.sizing.text.large
			case .xlarge: theme.sizing.text.xlarge
			case .xxlarge: theme.sizing.text.xxlarge
			case .hero: theme.sizing.text.hero
			case let .custom(size): size
		}
	}
}
