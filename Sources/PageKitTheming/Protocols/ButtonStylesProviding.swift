//
//  ButtonStylesProviding.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

// MARK: - ButtonStyleProviding

/// Protocol for a single button style configuration
public protocol ButtonStyleProviding {
	var backgroundColor: Color { get }
	var contentColor: Color { get }
	var cornerRadius: CGFloat { get }
	var borderColor: Color? { get }
	var borderWidth: CGFloat { get }
}

// MARK: - ButtonStylesProviding

/// Protocol for defining button style variations
public protocol ButtonStylesProviding {
	associatedtype Style: ButtonStyleProviding

	var primary: Style { get }
	var secondary: Style { get }
	var destructive: Style { get }
	var tertiary: Style { get }
	var link: Style { get }
}
