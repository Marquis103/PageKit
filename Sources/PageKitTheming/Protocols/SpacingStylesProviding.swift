//
//  SpacingStylesProviding.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation

// MARK: - SpacingStylesProviding

/// Protocol for spacing scale
public protocol SpacingStylesProviding {
	var xxsmall: CGFloat { get }
	var xsmall: CGFloat { get }
	var small: CGFloat { get }
	var medium: CGFloat { get }
	var large: CGFloat { get }
	var xlarge: CGFloat { get }
	var xxlarge: CGFloat { get }
}
