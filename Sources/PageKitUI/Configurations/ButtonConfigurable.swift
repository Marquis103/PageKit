//
//  ButtonConfigurable.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

/// A protocol for button components that support configurable size and icons
/// Provides a fluent API for customizing button appearance consistently
public protocol ButtonConfigurable: View {
	associatedtype IconType: ImageIconProtocol

	/// The size configuration for the button
	var buttonSize: ButtonSize { get set }

	/// Optional icon to display before the button text
	var leadingIcon: Icon<IconType>? { get set }

	/// Optional icon to display after the button text
	var trailingIcon: Icon<IconType>? { get set }

	/// Creates a button with text and action
	/// - Parameters:
	///   - text: The button text
	///   - onClick: The action to perform when clicked
	init(text: String, onClick: @escaping () -> Void)

	/// Configures the button size
	/// - Parameter buttonSize: The desired button size
	/// - Returns: A modified button with the new size
	func buttonSize(_ buttonSize: ButtonSize) -> Self

	/// Configures the leading icon
	/// - Parameter leadingIcon: The icon to display before the text
	/// - Returns: A modified button with the new leading icon
	func leadingIcon(_ leadingIcon: Icon<IconType>?) -> Self

	/// Configures the trailing icon
	/// - Parameter trailingIcon: The icon to display after the text
	/// - Returns: A modified button with the new trailing icon
	func trailingIcon(_ trailingIcon: Icon<IconType>?) -> Self
}

public extension ButtonConfigurable {
	func buttonSize(_ buttonSize: ButtonSize) -> Self {
		var this = self
		this.buttonSize = buttonSize
		return this
	}

	func leadingIcon(_ leadingIcon: Icon<IconType>?) -> Self {
		var this = self
		this.leadingIcon = leadingIcon
		return this
	}

	func trailingIcon(_ trailingIcon: Icon<IconType>?) -> Self {
		var this = self
		this.trailingIcon = trailingIcon
		return this
	}
}
