//
//  TypographyStylesProviding.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

// MARK: - FontWeight

/// Font weight options for typography
public enum ThemeFontWeight {
	case light
	case medium
	case semiBold
	case bold
	case extraBold
	case black

	public var uiFontWeight: UIFont.Weight {
		switch self {
			case .light: .light
			case .medium: .medium
			case .semiBold: .semibold
			case .bold: .bold
			case .extraBold: .heavy
			case .black: .black
		}
	}

	public var swiftUIWeight: Font.Weight {
		switch self {
			case .light: .light
			case .medium: .medium
			case .semiBold: .semibold
			case .bold: .bold
			case .extraBold: .heavy
			case .black: .black
		}
	}
}

// MARK: - FontFamilyProviding

/// Protocol for defining a font family
public protocol FontFamilyProviding {
	func font(weight: ThemeFontWeight, size: CGFloat) -> Font
}

// MARK: - TextStyleProviding

/// Protocol for a single text style configuration
public protocol TextStyleProviding {
	var color: Color { get }
	var fontWeight: ThemeFontWeight { get }
	var size: CGFloat { get }
}

// MARK: - TextStylesProviding

/// Protocol for text style variations
public protocol TextStylesProviding {
	associatedtype Style: TextStyleProviding

	var hero: Style { get }
	var h1: Style { get }
	var h2: Style { get }
	var h3: Style { get }
	var title: Style { get }
	var subtitle: Style { get }
	var body: Style { get }
	var link: Style { get }
}

// MARK: - TypographyStylesProviding

/// Protocol for the complete typography system
public protocol TypographyStylesProviding {
	associatedtype FontFamily: FontFamilyProviding
	associatedtype TextStyles: TextStylesProviding

	var fontFamily: FontFamily { get }
	var textStyles: TextStyles { get }
}
