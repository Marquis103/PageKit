//
//  BodyText.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI
import PageKitTheming

/// A text component that displays text using the Body typography style from the theme
///
/// BodyText automatically applies the body font family, weight, and color from the current theme,
/// while allowing customization through the TextConfigurable protocol.
///
/// Example usage:
/// ```swift
/// BodyText("This is the main content of the page.")
///     .textSize(.medium)
///     .textColor(.primary)
/// ```
public struct BodyText: TextConfigurable {
	public let text: String

	public var textSize: TextSize = .medium
	public var textColor: Color?

	@Environment(\.theme)
	private var theme: AnyTheme

	/// Creates a Body text component
	/// - Parameter text: The text content to display
	public init(_ text: String) {
		self.text = text
	}

	public var body: some View {
		let textStyle = theme.typography.textStyles.body
		let fontSize = textSize.resolve(from: theme)
		let fontFamily = theme.typography.fontFamily

		Text(text)
			.font(fontFamily.font(weight: textStyle.fontWeight, size: fontSize))
			.foregroundColor(textColor ?? textStyle.color)
	}
}
