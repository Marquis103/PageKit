//
//  BaseButton.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI
import PageKitTheming

/// Throttler utility for button click rate limiting
#if os(Android)
// PE-536/E4 spike/android: Fuse-native has Observation but not ObservableObject.
@MainActor
@Observable
private final class ButtonThrottler {
	private(set) var isThrottling = false

	func throttle(
		interval: Double = 0.5,
		action: @escaping () -> Void
	) async {
		guard !isThrottling else { return }
		isThrottling = true
		action()
		let nanoseconds = interval * Double(1_000_000_000)
		try? await Task.sleep(nanoseconds: UInt64(nanoseconds))
		isThrottling = false
	}
}
#else
@MainActor
private final class ButtonThrottler: ObservableObject {
	@Published
	private(set) var isThrottling = false

	func throttle(
		interval: Double = 0.5,
		action: @escaping () -> Void
	) async {
		guard !isThrottling else { return }
		isThrottling = true
		action()
		let nanoseconds = interval * Double(1_000_000_000)
		try? await Task.sleep(nanoseconds: UInt64(nanoseconds))
		isThrottling = false
	}
}
#endif

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
public struct BaseButton<T: ImageIconProtocol>: View {
	public let style: any ButtonStyleProviding
	public let size: ButtonSize
	public let text: String
	public let leadingIcon: Icon<T>?
	public let trailingIcon: Icon<T>?
	public var throttleDuration: Double = 0.5
	public let onClick: () -> Void

	@Environment(\.theme)
	var theme: AnyTheme

	@Environment(\.isEnabled)
	var isEnabled

	#if os(Android)
	// PE-536/E4 spike: plain storage — @Observable reads still drive updates;
	// per-body re-init means throttle state doesn't persist (spike caveat).
	private let throttler: ButtonThrottler = .init()
	#else
	@StateObject
	var throttler: ButtonThrottler = .init()
	#endif

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
		style: any ButtonStyleProviding,
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
						.lineLimit(1)
						#if !os(Android)  // PE-536/E4: SkipSwiftUI lacks truncationMode
						.truncationMode(.tail)
						#endif

					if let trailingIcon {
						trailingIcon
							.padding(.leading, buttonSize.contentPadding.leading)
					}
				}
				.padding(buttonSize.contentPadding)
				.frame(maxWidth: .infinity)
				.background(style.backgroundColor)
				#if !os(Android)
				.contentShape(Rectangle())
				#endif
			}
		)
		.buttonStyle(PlainButtonStyle())
		.overlay {
			if let borderColor = style.borderColor, style.borderWidth > 0 {
				RoundedRectangle(cornerRadius: style.cornerRadius)
					.strokeBorder(borderColor, lineWidth: style.borderWidth)
			}
		}
		.clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
		.opacity(isEnabled ? 1 : 0.75)
	}
}
