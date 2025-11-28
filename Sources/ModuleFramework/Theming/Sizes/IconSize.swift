//
//  IconSize.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation

public enum IconSize {
	case xsmall
	case small
	case medium
	case large
	case xlarge
	case custom(CGFloat)

	public func resolve(from theme: Theme) -> CGFloat {
		switch self {
			case .xsmall: theme.sizing.icons.xsmall
			case .small: theme.sizing.icons.small
			case .medium: theme.sizing.icons.medium
			case .large: theme.sizing.icons.large
			case .xlarge: theme.sizing.icons.xlarge
			case let .custom(size): size
		}
	}
}
