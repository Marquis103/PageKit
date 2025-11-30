//
//  GhostButton.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI
import PageKitTheming

/// A ghost button with transparent background using the theme's ghost button style
///
/// GhostButton is used for subtle actions that don't need visual emphasis.
/// It has a transparent background with only text and optional border visible.
///
/// Example usage:
/// ```swift
/// GhostButton(text: "Cancel", onClick: {
///     // Handle cancel action
/// })
/// .buttonSize(.medium)
/// ```
public struct GhostButton<T: ImageIconProtocol>: ButtonConfigurable {
	public typealias IconType = T

	public let text: String
	public let onClick: () -> Void

	public var buttonSize: ButtonSize = .medium
	public var trailingIcon: Icon<T>?
	public var leadingIcon: Icon<T>?
	public var throttleDuration: Double = 0.5

	@Environment(\.theme)
	private var theme: AnyTheme

	/// Creates a ghost button
	/// - Parameters:
	///   - text: The button text
	///   - onClick: Action to perform when clicked
	public init(text: String, onClick: @escaping () -> Void) {
		self.text = text
		self.onClick = onClick
	}

	public var body: some View {
		BaseButton(
			style: theme.buttons.ghost,
			size: buttonSize,
			text: text,
			leadingIcon: leadingIcon,
			trailingIcon: trailingIcon,
			throttleDuration: throttleDuration,
			onClick: onClick
		)
	}
}
