//
//  TextSize.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation

enum TextSize {
	case xxsmall
	case xsmall
	case small
	case medium
	case large
	case xlarge
	case xxlarge
	case hero
	case custom(CGFloat)

	func resolve(from theme: Theme) -> CGFloat {
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
