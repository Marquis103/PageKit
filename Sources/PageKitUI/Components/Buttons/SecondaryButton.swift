//
//  SecondaryButton.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI
import PageKitTheming

/// A secondary action button using the theme's secondary button style
///
/// SecondaryButton is used for secondary actions that are less prominent
/// than primary actions, such as "Cancel", "Back", "Skip", etc.
///
/// Example usage:
/// ```swift
/// SecondaryButton(text: "Cancel", onClick: {
///     // Handle cancel action
/// })
/// .buttonSize(.medium)
/// ```
public struct SecondaryButton<T: ImageIconProtocol>: ButtonConfigurable {
	public typealias IconType = T

	public let text: String
	public let onClick: () -> Void

	public var buttonSize: ButtonSize = .medium
	public var trailingIcon: Icon<T>?
	public var leadingIcon: Icon<T>?
	public var throttleDuration: Double = 0.5

	@Environment(\.theme)
	private var theme: AnyTheme

	/// Creates a secondary button
	/// - Parameters:
	///   - text: The button text
	///   - onClick: Action to perform when clicked
	public init(text: String, onClick: @escaping () -> Void) {
		self.text = text
		self.onClick = onClick
	}

	public var body: some View {
		BaseButton(
			style: theme.buttons.secondary,
			size: buttonSize,
			text: text,
			leadingIcon: leadingIcon,
			trailingIcon: trailingIcon,
			throttleDuration: throttleDuration,
			onClick: onClick
		)
	}
}
