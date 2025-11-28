//
//  PrimaryButton.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

/// A primary action button using the theme's primary button style
///
/// PrimaryButton is used for the most important actions in your interface,
/// such as "Submit", "Continue", "Save", etc. It uses the primary style
/// from your theme configuration.
///
/// Example usage:
/// ```swift
/// PrimaryButton(text: "Continue", onClick: {
///     // Handle continue action
/// })
/// .buttonSize(.large)
/// .trailingIcon(Icon(icon: Icons.Bold.arrowRight))
/// ```
public struct PrimaryButton<T: ImageIconProtocol>: ButtonConfigurable {
	public typealias IconType = T

	public let text: String
	public let onClick: () -> Void

	public var buttonSize: ButtonSize = .medium
	public var trailingIcon: Icon<T>?
	public var leadingIcon: Icon<T>?
	public var throttleDuration: Double = 0.5

	@Environment(\.theme)
	private var theme: Theme

	/// Creates a primary button
	/// - Parameters:
	///   - text: The button text
	///   - onClick: Action to perform when clicked
	public init(text: String, onClick: @escaping () -> Void) {
		self.text = text
		self.onClick = onClick
	}

	public var body: some View {
		BaseButton(
			style: theme.buttons.primary,
			size: buttonSize,
			text: text,
			leadingIcon: leadingIcon,
			trailingIcon: trailingIcon,
			throttleDuration: throttleDuration,
			onClick: onClick
		)
	}
}
