//
//  H3Text.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI
import PageKitTheming

/// A text component that displays text using the H3 typography style from the theme
///
/// H3Text automatically applies the h3 font family, weight, and color from the current theme,
/// while allowing customization through the TextConfigurable protocol.
///
/// Example usage:
/// ```swift
/// H3Text("Section Header")
///     .textSize(.large)
///     .textColor(.blue)
/// ```
public struct H3Text: TextConfigurable {
	public let text: String

	public var textSize: TextSize = .medium
	public var textColor: Color?

	@Environment(\.theme)
	private var theme: AnyTheme

	/// Creates an H3 text component
	/// - Parameter text: The text content to display
	public init(_ text: String) {
		self.text = text
	}

	public var body: some View {
		let textStyle = theme.typography.textStyles.h3
		let fontSize = textSize.resolve(from: theme)
		let fontFamily = theme.typography.fontFamily

		Text(text)
			.font(fontFamily.font(weight: textStyle.fontWeight, size: fontSize))
			.foregroundColor(textColor ?? textStyle.color)
	}
}
