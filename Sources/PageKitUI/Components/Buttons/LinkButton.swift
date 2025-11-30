//
//  LinkButton.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI
import PageKitTheming

/// A link-style button using the theme's link button style
///
/// LinkButton is used for navigation or inline actions that should appear as links.
/// It has padding unlike TextButton, making it suitable as a standalone action.
///
/// Example usage:
/// ```swift
/// LinkButton(text: "View Details", onClick: {
///     // Navigate to details
/// })
/// .buttonSize(.medium)
/// .trailingIcon(Icon(icon: Icons.Bold.arrowRight))
/// ```
public struct LinkButton<T: ImageIconProtocol>: ButtonConfigurable {
	public typealias IconType = T

	public let text: String
	public let onClick: () -> Void

	public var buttonSize: ButtonSize = .medium
	public var trailingIcon: Icon<T>?
	public var leadingIcon: Icon<T>?
	public var throttleDuration: Double = 0.5

	@Environment(\.theme)
	private var theme: AnyTheme

	/// Creates a link button
	/// - Parameters:
	///   - text: The button text
	///   - onClick: Action to perform when clicked
	public init(text: String, onClick: @escaping () -> Void) {
		self.text = text
		self.onClick = onClick
	}

	public var body: some View {
		BaseButton(
			style: theme.buttons.link,
			size: buttonSize,
			text: text,
			leadingIcon: leadingIcon,
			trailingIcon: trailingIcon,
			throttleDuration: throttleDuration,
			onClick: onClick
		)
	}
}
