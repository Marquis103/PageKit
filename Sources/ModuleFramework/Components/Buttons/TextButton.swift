//
//  TextButton.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

/// A text-style button with minimal padding, appearing as a clickable link
///
/// TextButton is used for tertiary actions or inline links within content.
/// It has no background and minimal padding, making it suitable for use
/// within text or as a subtle action.
///
/// Example usage:
/// ```swift
/// TextButton(text: "Learn More", onClick: {
///     // Navigate to details
/// })
/// .buttonSize(.medium)
/// .trailingIcon(Icon(icon: Icons.Bold.arrowRight))
/// ```
public struct TextButton<T: ImageIconProtocol>: ButtonConfigurable {
	public typealias IconType = T

	public let text: String
	public let onClick: () -> Void

	public var buttonSize: ButtonSize = .medium
	public var trailingIcon: Icon<T>?
	public var leadingIcon: Icon<T>?
	public var throttleDuration: Double = 0.5

	@Environment(\.theme)
	private var theme: Theme

	/// Creates a text button
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
			size: .custom(
				SizingStyles.ButtonSizes.ButtonSize(
					textSize: buttonSize.resolve(from: theme).textSize,
					contentPadding: .init(horizontal: 0, vertical: 0)
				)
			),
			text: text,
			leadingIcon: leadingIcon,
			trailingIcon: trailingIcon,
			throttleDuration: throttleDuration,
			onClick: onClick
		)
		.fixedSize(horizontal: true, vertical: true)
	}
}
