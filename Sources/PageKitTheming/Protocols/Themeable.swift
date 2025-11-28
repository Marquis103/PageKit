//
//  Themeable.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

// MARK: - Themeable

/// Main protocol for defining a complete theme
/// Implement this protocol to create your own custom theme
public protocol Themeable {
	associatedtype Buttons: ButtonStylesProviding
	associatedtype Colors: ColorStylesProviding
	associatedtype Sizing: SizingStylesProviding
	associatedtype Spacing: SpacingStylesProviding
	associatedtype Typography: TypographyStylesProviding

	var buttons: Buttons { get }
	var colors: Colors { get }
	var sizing: Sizing { get }
	var spacing: Spacing { get }
	var typography: Typography { get }
}
