//
//  DefaultSpacingStyles.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation

// MARK: - DefaultSpacingStyles

public struct DefaultSpacingStyles: SpacingStylesProviding {
	public let xxsmall: CGFloat
	public let xsmall: CGFloat
	public let small: CGFloat
	public let medium: CGFloat
	public let large: CGFloat
	public let xlarge: CGFloat
	public let xxlarge: CGFloat

	public init(
		xxsmall: CGFloat,
		xsmall: CGFloat,
		small: CGFloat,
		medium: CGFloat,
		large: CGFloat,
		xlarge: CGFloat,
		xxlarge: CGFloat
	) {
		self.xxsmall = xxsmall
		self.xsmall = xsmall
		self.small = small
		self.medium = medium
		self.large = large
		self.xlarge = xlarge
		self.xxlarge = xxlarge
	}

	/// Standard spacing scale using 4pt base unit
	public static var standard: DefaultSpacingStyles {
		DefaultSpacingStyles(
			xxsmall: 2,
			xsmall: 4,
			small: 8,
			medium: 12,
			large: 16,
			xlarge: 24,
			xxlarge: 32
		)
	}
}
