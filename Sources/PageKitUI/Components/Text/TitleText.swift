//
//  TitleText.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI
import PageKitTheming

/// A text component that displays text using the Title typography style from the theme
///
/// TitleText automatically applies the title font family, weight, and color from the current theme,
/// while allowing customization through the TextConfigurable protocol.
///
/// Example usage:
/// ```swift
/// TitleText("Item Title")
///     .textSize(.large)
///     .textColor(.blue)
/// ```
public struct TitleText: TextConfigurable, View {  // direct View listing — indirect (protocol-only) conformance composes empty under SkipUI (B1 P10/P11)
	public let text: String

	public var textSize: TextSize = .medium
	public var textColor: Color?

	@Environment(\.theme)
	var theme: AnyTheme  // skipstone: internal (see PORTABILITY.md)

	/// Creates a Title text component
	/// - Parameter text: The text content to display
	public init(_ text: String) {
		self.text = text
	}

	public var body: some View {
		let textStyle = theme.typography.textStyles.title
		let fontSize = textSize.resolve(from: theme)
		let fontFamily = theme.typography.fontFamily

		Text(text)
			.font(fontFamily.font(weight: textStyle.fontWeight, size: fontSize))
			.foregroundColor(textColor ?? textStyle.color)
	}
}
