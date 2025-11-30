//
//  TertiaryButton.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI
import PageKitTheming

/// A tertiary button with subtle styling using the theme's tertiary button style
///
/// TertiaryButton is used for subtle actions that don't need visual emphasis.
/// It typically has a transparent or very light background with optional border.
/// Part of the button hierarchy: Primary → Secondary → Tertiary.
///
/// Example usage:
/// ```swift
/// TertiaryButton(text: "Cancel", onClick: {
///     // Handle cancel action
/// })
/// .buttonSize(.medium)
/// ```
public struct TertiaryButton<T: ImageIconProtocol>: ButtonConfigurable {
	public typealias IconType = T

	public let text: String
	public let onClick: () -> Void

	public var buttonSize: ButtonSize = .medium
	public var trailingIcon: Icon<T>?
	public var leadingIcon: Icon<T>?
	public var throttleDuration: Double = 0.5

	@Environment(\.theme)
	private var theme: AnyTheme

	/// Creates a tertiary button
	/// - Parameters:
	///   - text: The button text
	///   - onClick: Action to perform when clicked
	public init(text: String, onClick: @escaping () -> Void) {
		self.text = text
		self.onClick = onClick
	}

	public var body: some View {
		BaseButton(
			style: theme.buttons.tertiary,
			size: buttonSize,
			text: text,
			leadingIcon: leadingIcon,
			trailingIcon: trailingIcon,
			throttleDuration: throttleDuration,
			onClick: onClick
		)
	}
}
