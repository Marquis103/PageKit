//
//  TappableRow.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

/// A container that makes its entire content area tappable.
///
/// Wraps content in a plain-styled button with `contentShape(Rectangle())`
/// so taps register on padding and spacers — not just visible subviews.
///
/// ```swift
/// TappableRow(action: { print("tapped") }) {
///     HStack {
///         Text("Settings")
///         Spacer()
///         Image(systemName: "chevron.right")
///     }
///     .padding()
/// }
/// ```
public struct TappableRow<Content: View>: View {

	let isDisabled: Bool
	let action: () -> Void
	@ViewBuilder let content: () -> Content

	/// Creates a tappable row.
	/// - Parameters:
	///   - isDisabled: Whether the row ignores taps. Defaults to `false`.
	///   - action: The closure to run when tapped.
	///   - content: The row content to display.
	public init(
		isDisabled: Bool = false,
		action: @escaping () -> Void,
		@ViewBuilder content: @escaping () -> Content
	) {
		self.isDisabled = isDisabled
		self.action = action
		self.content = content
	}

	public var body: some View {
		Button(action: action) {
			content()
				.contentShape(Rectangle())
		}
		.buttonStyle(.plain)
		.disabled(isDisabled)
	}
}
