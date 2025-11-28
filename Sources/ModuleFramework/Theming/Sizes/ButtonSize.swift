//
//  ButtonSize.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation

/// Defines standard button size options with theme integration
public enum ButtonSize {
	case small
	case medium
	case large
	case xlarge
	case custom(SizingStyles.ButtonSizes.ButtonSize)

	/// Resolves the button size configuration from the theme
	/// - Parameter theme: The current theme containing button size definitions
	/// - Returns: The resolved button size configuration
	public func resolve(from theme: Theme) -> SizingStyles.ButtonSizes.ButtonSize {
		switch self {
			case .small: theme.sizing.buttons.small
			case .medium: theme.sizing.buttons.medium
			case .large: theme.sizing.buttons.large
			case .xlarge: theme.sizing.buttons.xlarge
			case let .custom(size): size
		}
	}
}
