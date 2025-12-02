//
//  SheetConfiguration.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import UIKit

/// Configuration for sheet presentation using UISheetPresentationController
public struct SheetConfiguration: Sendable {
	/// The detents where the sheet can rest
	public var detents: [SheetDetent]

	/// The initially selected detent when the sheet appears
	public var selectedDetent: SheetDetent?

	/// Whether to show the grabber handle at the top of the sheet
	public var showsGrabber: Bool

	/// Custom corner radius for the sheet (nil uses system default)
	public var cornerRadius: CGFloat?

	/// Whether the sheet can be dismissed by dragging down or tapping outside
	public var isDismissible: Bool

	/// The largest detent that doesn't dim the content behind the sheet
	public var largestUndimmedDetent: SheetDetent?

	/// The rewind style for the navigation bar button
	public var rewindStyle: RewindStyle

	/// Whether the sheet adapts to size class changes
	public var prefersEdgeAttachedInCompactHeight: Bool

	/// Whether the sheet follows the scroll view's content inset
	public var prefersScrollingExpandsWhenScrolledToEdge: Bool

	/// Creates a sheet configuration with the specified parameters
	public init(
		detents: [SheetDetent] = [.medium, .large],
		selectedDetent: SheetDetent? = nil,
		showsGrabber: Bool = true,
		cornerRadius: CGFloat? = nil,
		isDismissible: Bool = true,
		largestUndimmedDetent: SheetDetent? = nil,
		rewindStyle: RewindStyle = .none,
		prefersEdgeAttachedInCompactHeight: Bool = false,
		prefersScrollingExpandsWhenScrolledToEdge: Bool = true
	) {
		self.detents = detents
		self.selectedDetent = selectedDetent
		self.showsGrabber = showsGrabber
		self.cornerRadius = cornerRadius
		self.isDismissible = isDismissible
		self.largestUndimmedDetent = largestUndimmedDetent
		self.rewindStyle = rewindStyle
		self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
		self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
	}
}

// MARK: - Presets

extension SheetConfiguration {
	/// Standard expandable sheet with medium and large detents
	public static var standard: SheetConfiguration {
		SheetConfiguration(
			detents: [.medium, .large],
			showsGrabber: true,
			isDismissible: true
		)
	}

	/// Compact half-height sheet that stays at medium
	public static var compact: SheetConfiguration {
		SheetConfiguration(
			detents: [.medium],
			showsGrabber: true,
			isDismissible: true
		)
	}

	/// Full-screen sheet
	public static var fullScreen: SheetConfiguration {
		SheetConfiguration(
			detents: [.large],
			showsGrabber: false,
			isDismissible: true
		)
	}

	/// Non-dismissible sheet for required flows (e.g., onboarding, confirmations)
	public static var required: SheetConfiguration {
		SheetConfiguration(
			detents: [.large],
			showsGrabber: false,
			isDismissible: false,
			rewindStyle: .none
		)
	}

	/// Fixed-height card-style sheet
	public static func card(height: CGFloat) -> SheetConfiguration {
		SheetConfiguration(
			detents: [.height(height)],
			showsGrabber: true,
			isDismissible: true
		)
	}

	/// Expandable sheet starting from a custom fraction
	public static func expandable(from fraction: CGFloat) -> SheetConfiguration {
		SheetConfiguration(
			detents: [.fraction(fraction), .large],
			selectedDetent: .fraction(fraction),
			showsGrabber: true,
			isDismissible: true
		)
	}
}

// MARK: - Equatable

extension SheetConfiguration: Equatable {
	public static func == (lhs: SheetConfiguration, rhs: SheetConfiguration) -> Bool {
		lhs.detents == rhs.detents
			&& lhs.selectedDetent == rhs.selectedDetent
			&& lhs.showsGrabber == rhs.showsGrabber
			&& lhs.cornerRadius == rhs.cornerRadius
			&& lhs.isDismissible == rhs.isDismissible
			&& lhs.largestUndimmedDetent == rhs.largestUndimmedDetent
			&& lhs.rewindStyle == rhs.rewindStyle
	}
}
