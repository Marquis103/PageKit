//
//  NavigationButton.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

/// A button that can be displayed in the navigation bar.
///
/// Use this with the `.navigation()` modifier to add custom buttons
/// to the leading or trailing positions of the navigation bar.
public struct NavigationButton: View, Identifiable, Equatable {

	// MARK: - Content Type

	/// The type of content displayed in the button.
	public enum Content: Equatable {
		/// An SF Symbol icon.
		case icon(String)
		/// A text label.
		case text(String)
	}

	// MARK: - Properties

	/// The content displayed in the button.
	public let content: Content

	/// Whether this is a destructive action (displays in red).
	public private(set) var destructive: Bool

	/// The action to perform when tapped.
	public let onClick: () -> Void

	/// Unique identifier for the button.
	public var id: String {
		switch content {
		case let .icon(name):
			"\(name)-\(destructive)"
		case let .text(text):
			"\(text)-\(destructive)"
		}
	}

	// MARK: - Initializers

	/// Creates a navigation button with the specified content.
	/// - Parameters:
	///   - content: The content to display (icon or text).
	///   - destructive: Whether this is a destructive action.
	///   - onClick: The action to perform when tapped.
	public init(
		content: Content,
		destructive: Bool = false,
		onClick: @escaping () -> Void
	) {
		self.content = content
		self.destructive = destructive
		self.onClick = onClick
	}

	/// Creates a navigation button with an SF Symbol icon.
	/// - Parameters:
	///   - systemName: The SF Symbol name.
	///   - destructive: Whether this is a destructive action.
	///   - onClick: The action to perform when tapped.
	public static func icon(
		_ systemName: String,
		destructive: Bool = false,
		onClick: @escaping () -> Void
	) -> NavigationButton {
		NavigationButton(content: .icon(systemName), destructive: destructive, onClick: onClick)
	}

	/// Creates a navigation button with a text label.
	/// - Parameters:
	///   - text: The text to display.
	///   - destructive: Whether this is a destructive action.
	///   - onClick: The action to perform when tapped.
	public static func text(
		_ text: String,
		destructive: Bool = false,
		onClick: @escaping () -> Void
	) -> NavigationButton {
		NavigationButton(content: .text(text), destructive: destructive, onClick: onClick)
	}

	// MARK: - Body

	public var body: some View {
		Button(action: onClick) {
			switch content {
			case let .icon(systemName):
				Image(systemName: systemName)
					.foregroundStyle(destructive ? Color.red : Color.primary)
			case let .text(text):
				Text(text)
					.foregroundStyle(destructive ? Color.red : Color.accentColor)
			}
		}
	}

	// MARK: - Equatable

	public static func == (lhs: NavigationButton, rhs: NavigationButton) -> Bool {
		lhs.id == rhs.id
	}
}
