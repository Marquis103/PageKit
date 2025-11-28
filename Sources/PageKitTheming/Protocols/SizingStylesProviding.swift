//
//  SizingStylesProviding.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

// MARK: - TextSizesProviding

/// Protocol for text size scale
public protocol TextSizesProviding {
	var xxsmall: CGFloat { get }
	var xsmall: CGFloat { get }
	var small: CGFloat { get }
	var medium: CGFloat { get }
	var large: CGFloat { get }
	var xlarge: CGFloat { get }
	var xxlarge: CGFloat { get }
	var hero: CGFloat { get }
}

// MARK: - IconSizesProviding

/// Protocol for icon size scale
public protocol IconSizesProviding {
	var xxsmall: CGFloat { get }
	var xsmall: CGFloat { get }
	var small: CGFloat { get }
	var medium: CGFloat { get }
	var large: CGFloat { get }
	var xlarge: CGFloat { get }
}

// MARK: - ButtonSizeProviding

/// Protocol for a single button size configuration
public protocol ButtonSizeProviding {
	var textSize: CGFloat { get }
	var contentPadding: EdgeInsets { get }
}

// MARK: - ButtonSizesProviding

/// Protocol for button size scale
public protocol ButtonSizesProviding {
	associatedtype Size: ButtonSizeProviding

	var small: Size { get }
	var medium: Size { get }
	var large: Size { get }
	var xlarge: Size { get }
}

// MARK: - SizingStylesProviding

/// Protocol for the complete sizing system
public protocol SizingStylesProviding {
	associatedtype Text: TextSizesProviding
	associatedtype Icons: IconSizesProviding
	associatedtype Buttons: ButtonSizesProviding

	var text: Text { get }
	var icons: Icons { get }
	var buttons: Buttons { get }
}
