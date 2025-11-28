//
//  ColorStylesProviding.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

// MARK: - TextColorsProviding

/// Protocol for text color variations
public protocol TextColorsProviding {
	var primary: Color { get }
	var secondary: Color { get }
	var tertiary: Color { get }
	var inverted: Color { get }
}

// MARK: - BackgroundColorsProviding

/// Protocol for background color variations
public protocol BackgroundColorsProviding {
	var primary: Color { get }
	var secondary: Color { get }
	var tertiary: Color { get }
}

// MARK: - AccentColorsProviding

/// Protocol for accent color palette
public protocol AccentColorsProviding {
	var aqua: Color { get }
	var blue: Color { get }
	var gold: Color { get }
	var green: Color { get }
	var lime: Color { get }
	var orange: Color { get }
	var purple: Color { get }
	var red: Color { get }
	var salmon: Color { get }
	var silver: Color { get }
	var yellow: Color { get }
}

// MARK: - ColorStylesProviding

/// Protocol for the complete color system
public protocol ColorStylesProviding {
	associatedtype Text: TextColorsProviding
	associatedtype Background: BackgroundColorsProviding
	associatedtype Accent: AccentColorsProviding

	var primary: Color { get }
	var positive: Color { get }
	var destructive: Color { get }
	var text: Text { get }
	var background: Background { get }
	var accent: Accent { get }
	var divider: Color { get }
}
