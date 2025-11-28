//
//  TextConfigurable.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

/// A protocol for text components that support configurable size and color
/// Provides a fluent API for styling text elements consistently across the app
public protocol TextConfigurable: View {
	/// The size configuration for the text
	var textSize: TextSize { get set }

	/// Optional color override for the text
	var textColor: Color? { get set }

	/// Configures the text size
	/// - Parameter textSize: The desired text size
	/// - Returns: A modified instance with the new size
	func textSize(_ textSize: TextSize) -> Self

	/// Configures the text color
	/// - Parameter textColor: The desired text color
	/// - Returns: A modified instance with the new color
	func textColor(_ textColor: Color) -> Self
}

public extension TextConfigurable {
	func textSize(_ textSize: TextSize) -> Self {
		var this = self
		this.textSize = textSize
		return this
	}

	func textColor(_ textColor: Color) -> Self {
		var this = self
		this.textColor = textColor
		return this
	}
}
