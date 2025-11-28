//
//  IconSize.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation
import PageKitTheming

/// Defines standard icon size options with theme integration
public enum IconSize {
	case xxsmall
	case xsmall
	case small
	case medium
	case large
	case xlarge
	case custom(CGFloat)

	/// Resolves the icon size to a CGFloat value using the theme's sizing configuration
	/// - Parameter theme: The current theme containing size definitions
	/// - Returns: The resolved icon size in points
	public func resolve(from theme: AnyTheme) -> CGFloat {
		switch self {
			case .xxsmall: theme.sizing.icons.xxsmall
			case .xsmall: theme.sizing.icons.xsmall
			case .small: theme.sizing.icons.small
			case .medium: theme.sizing.icons.medium
			case .large: theme.sizing.icons.large
			case .xlarge: theme.sizing.icons.xlarge
			case let .custom(size): size
		}
	}
}
