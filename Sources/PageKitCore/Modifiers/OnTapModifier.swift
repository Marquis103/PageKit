//
//  OnTapModifier.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

// MARK: - TapModifier

/// A view modifier that adds a throttled tap gesture to prevent double-taps.
private struct TapModifier: ViewModifier {
	@StateObject
	private var throttler: Throttler = .init()

	let interval: Double
	let action: () -> Void

	func body(content: Content) -> some View {
		content
			.contentShape(Rectangle())
			.onTapGesture {
				Task {
					await throttler.throttle(interval: interval) {
						action()
					}
				}
			}
	}
}

// MARK: - View Extension

extension View {
	/// Adds a throttled tap gesture that prevents rapid double-taps.
	///
	/// Use this modifier instead of `.onTapGesture` when you want to prevent
	/// users from accidentally triggering an action twice by tapping quickly.
	///
	/// - Parameters:
	///   - interval: The minimum time (in seconds) between allowed taps. Default is 0.5 seconds.
	///   - action: The action to perform when tapped.
	/// - Returns: A view with the throttled tap gesture.
	///
	/// # Example
	/// ```swift
	/// Button {
	///     // Action
	/// }
	/// .onTap {
	///     submitForm()
	/// }
	/// ```
	public func onTap(
		interval: Double = 0.5,
		action: @escaping () -> Void
	) -> some View {
		modifier(
			TapModifier(
				interval: interval,
				action: action
			)
		)
	}
}
