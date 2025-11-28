//
//  H2Text.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

/// A text component that displays text using the H2 typography style from the theme
///
/// H2Text automatically applies the h2 font family, weight, and color from the current theme,
/// while allowing customization through the TextConfigurable protocol.
///
/// Example usage:
/// ```swift
/// H2Text("Welcome Back")
///     .textSize(.large)
///     .textColor(.blue)
/// ```
public struct H2Text: TextConfigurable {
	public let text: String

	public var textSize: TextSize = .medium
	public var textColor: Color?

	@Environment(\.theme)
	private var theme: Theme

	/// Creates an H2 text component
	/// - Parameter text: The text content to display
	public init(_ text: String) {
		self.text = text
	}

	public var body: some View {
		let textStyle = theme.typography.textStyles.h2
		let fontSize = textSize.resolve(from: theme)

		Text(text)
			.font(textStyle.fontFamily(textStyle.fontWeight).swiftUIFont(size: fontSize))
			.foregroundColor(textColor ?? textStyle.color)
	}
}
