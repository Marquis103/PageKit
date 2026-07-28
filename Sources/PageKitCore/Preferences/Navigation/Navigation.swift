//
//  Navigation.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

/// Represents navigation configuration for a page.
///
/// Use this struct with the `.navigation()` modifier to configure
/// the navigation bar appearance and behavior for a page.
public struct Navigation: Equatable {

	// MARK: - Properties

	/// The title displayed in the navigation bar.
	public let title: String?

	/// The display mode for the navigation bar title.
	public private(set) var titleDisplayMode: NavigationBarItem.TitleDisplayMode = .inline

	/// Additional buttons displayed on the leading side of the navigation bar.
	/// Note: The automatic back button (from rewinder) appears before these.
	public private(set) var leadingButtons: [NavigationButton] = []

	/// Buttons displayed on the trailing side of the navigation bar.
	public private(set) var trailingButtons: [NavigationButton] = []

	/// Controls visibility of the toolbar background.
	public private(set) var backgroundVisibility: Visibility = .automatic

	/// When true, the automatic back button (from rewinder) is hidden.
	public private(set) var disableRewind: Bool = false

	// MARK: - Initializer

	public init(
		title: String? = nil,
		titleDisplayMode: NavigationBarItem.TitleDisplayMode = .inline,
		leadingButtons: [NavigationButton] = [],
		trailingButtons: [NavigationButton] = [],
		backgroundVisibility: Visibility = .automatic,
		disableRewind: Bool = false
	) {
		self.title = title
		self.titleDisplayMode = titleDisplayMode
		self.leadingButtons = leadingButtons
		self.trailingButtons = trailingButtons
		self.backgroundVisibility = backgroundVisibility
		self.disableRewind = disableRewind
	}

	// MARK: - Equatable

	public static func == (lhs: Navigation, rhs: Navigation) -> Bool {
		lhs.title == rhs.title
			&& lhs.titleDisplayMode == rhs.titleDisplayMode
			&& lhs.leadingButtons == rhs.leadingButtons
			&& lhs.trailingButtons == rhs.trailingButtons
			&& lhs.backgroundVisibility == rhs.backgroundVisibility
			&& lhs.disableRewind == rhs.disableRewind
	}
}
