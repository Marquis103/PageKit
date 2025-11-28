//
//  DestructiveButton.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

/// A destructive action button using the theme's destructive button style
///
/// DestructiveButton is used for actions that are potentially dangerous
/// or irreversible, such as "Delete", "Remove", "Clear", etc. It uses
/// destructive styling (typically red) to warn users of the action's nature.
///
/// Example usage:
/// ```swift
/// DestructiveButton(text: "Delete Account", onClick: {
///     // Show confirmation dialog
///     showDeleteConfirmation()
/// })
/// .buttonSize(.large)
/// ```
public struct DestructiveButton<T: ImageIconProtocol>: ButtonConfigurable {
	public typealias IconType = T

	public let text: String
	public let onClick: () -> Void

	public var buttonSize: ButtonSize = .medium
	public var trailingIcon: Icon<T>?
	public var leadingIcon: Icon<T>?
	public var throttleDuration: Double = 0.5

	@Environment(\.theme)
	private var theme: Theme

	/// Creates a destructive button
	/// - Parameters:
	///   - text: The button text
	///   - onClick: Action to perform when clicked
	public init(text: String, onClick: @escaping () -> Void) {
		self.text = text
		self.onClick = onClick
	}

	public var body: some View {
		BaseButton(
			style: theme.buttons.destructive,
			size: buttonSize,
			text: text,
			leadingIcon: leadingIcon,
			trailingIcon: trailingIcon,
			throttleDuration: throttleDuration,
			onClick: onClick
		)
	}
}
