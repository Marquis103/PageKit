//
//  NavigationPreference.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

// MARK: - NavigationPreferenceKey

/// A preference key for passing navigation configuration up the view hierarchy.
public struct NavigationPreferenceKey: PreferenceKey {
	public static var defaultValue: Navigation?

	public static func reduce(value: inout Navigation?, nextValue: () -> Navigation?) {
		// Always accept the topmost setting of navigation
		if value == nil {
			value = nextValue()
		}
	}
}

// MARK: - View Extension

extension View {

	/// Configures the navigation bar for this page.
	///
	/// Use this modifier to set the navigation title, buttons, and appearance.
	/// The automatic back button (based on rewinder style) will appear unless
	/// `disableRewind` is set to true.
	///
	/// - Parameters:
	///   - title: The title to display in the navigation bar.
	///   - titleDisplayMode: How to display the title (.inline or .large).
	///   - leadingButtons: Additional buttons on the leading side (after back button).
	///   - trailingButtons: Buttons on the trailing side.
	///   - backgroundVisibility: Visibility of the toolbar background.
	///   - disableRewind: When true, hides the automatic back button.
	/// - Returns: A view with navigation preferences set.
	///
	/// # Example
	/// ```swift
	/// struct MyPageView: View {
	///     var body: some View {
	///         Content()
	///             .navigation(title: "Settings")
	///     }
	/// }
	/// ```
	///
	/// # Example with trailing button
	/// ```swift
	/// Content()
	///     .navigation(
	///         title: "Edit Profile",
	///         trailingButtons: [
	///             .text("Save") { saveProfile() }
	///         ]
	///     )
	/// ```
	public func navigation(
		title: String? = nil,
		titleDisplayMode: NavigationBarItem.TitleDisplayMode = .inline,
		leadingButtons: [NavigationButton] = [],
		trailingButtons: [NavigationButton] = [],
		backgroundVisibility: Visibility = .automatic,
		disableRewind: Bool = false
	) -> some View {
		preference(
			key: NavigationPreferenceKey.self,
			value: Navigation(
				title: title,
				titleDisplayMode: titleDisplayMode,
				leadingButtons: leadingButtons,
				trailingButtons: trailingButtons,
				backgroundVisibility: backgroundVisibility,
				disableRewind: disableRewind
			)
		)
	}
}
