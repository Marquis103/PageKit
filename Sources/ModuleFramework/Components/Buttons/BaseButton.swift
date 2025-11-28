//
//  BaseButton.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

/// The base button component that all styled buttons are built upon
///
/// BaseButton handles common button functionality including:
/// - Theme-based styling (colors, borders, corner radius)
/// - Size configuration
/// - Icon support (leading and trailing)
/// - Click throttling to prevent rapid repeated clicks
/// - Disabled state styling
///
/// This component is typically not used directly, but rather through styled
/// button components like PrimaryButton, SecondaryButton, etc.
///
/// Example usage:
/// ```swift
/// BaseButton(
///     style: theme.buttons.primary,
///     size: .medium,
///     text: "Submit",
///     leadingIcon: nil,
///     trailingIcon: Icon(icon: Icons.Bold.arrowRight),
///     throttleDuration: 0.5,
///     onClick: { submitForm() }
/// )
/// ```
public struct BaseButton<T: ImageIconProtocol>: View {
	public let style: ButtonStyles.ButtonStyle
	public let size: ButtonSize
	public let text: String
	public let leadingIcon: Icon<T>?
	public let trailingIcon: Icon<T>?
	public var throttleDuration: Double = 0.5
	public let onClick: () -> Void

	@Environment(\.theme)
	private var theme: Theme

	@Environment(\.isEnabled)
	private var isEnabled

	@StateObject
	private var throttler: Throttler = .init()

	/// Creates a base button with the specified configuration
	/// - Parameters:
	///   - style: The button style from the theme
	///   - size: The button size
	///   - text: The button text
	///   - leadingIcon: Optional icon to display before the text
	///   - trailingIcon: Optional icon to display after the text
	///   - throttleDuration: Time in seconds to throttle clicks (default: 0.5)
	///   - onClick: Action to perform when button is clicked
	public init(
		style: ButtonStyles.ButtonStyle,
		size: ButtonSize,
		text: String,
		leadingIcon: Icon<T>? = nil,
		trailingIcon: Icon<T>? = nil,
		throttleDuration: Double = 0.5,
		onClick: @escaping () -> Void
	) {
		self.style = style
		self.size = size
		self.text = text
		self.leadingIcon = leadingIcon
		self.trailingIcon = trailingIcon
		self.throttleDuration = throttleDuration
		self.onClick = onClick
	}

	public var body: some View {
		let buttonSize = size.resolve(from: theme)

		SwiftUI.Button(
			action: {
				Task {
					await throttler.throttle(interval: throttleDuration, action: onClick)
				}
			},
			label: {
				HStack {
					if let leadingIcon {
						leadingIcon
							.padding(.trailing, buttonSize.contentPadding.trailing)
					}

					H2Text(text.uppercased())
						.textSize(.custom(buttonSize.textSize))
						.textColor(style.contentColor)
						.lineLimit(1) // Limit to one line
						.truncationMode(.tail)

					if let trailingIcon {
						trailingIcon
							.padding(.leading, buttonSize.contentPadding.leading)
					}
				}
				.padding(buttonSize.contentPadding)
				.frame(maxWidth: .infinity)
				.background(style.backgroundColor)
				.contentShape(Rectangle())
			}
		)
		// This line allows the button to be clickable when it's inside a list
		.buttonStyle(PlainButtonStyle())
		.let(style.border) { btn, border in
			btn.overlay {
				RoundedRectangle(cornerRadius: style.cornerRadius)
					.strokeBorder(border.color, lineWidth: border.width)
			}
		}
		.clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
		.if(!isEnabled) { $0.opacity(0.75) }
	}
}
