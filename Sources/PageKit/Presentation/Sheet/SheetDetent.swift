//
//  SheetDetent.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import UIKit

/// Represents the height at which a sheet can rest
public enum SheetDetent: Hashable, Sendable {
	/// Half-height sheet (approximately 50% of screen)
	case medium

	/// Full-height sheet
	case large

	/// Custom fraction of screen height (0.0 to 1.0)
	case fraction(CGFloat)

	/// Fixed height in points
	case height(CGFloat)
}

// MARK: - UIKit Conversion

extension SheetDetent {
	/// Converts to UISheetPresentationController.Detent
	@available(iOS 15.0, *)
	func toUIKitDetent() -> UISheetPresentationController.Detent {
		switch self {
			case .medium:
				return .medium()
			case .large:
				return .large()
			case let .fraction(value):
				if #available(iOS 16.0, *) {
					return .custom { context in
						context.maximumDetentValue * value
					}
				} else {
					// Fallback to medium for iOS 15
					return value > 0.5 ? .large() : .medium()
				}
			case let .height(points):
				if #available(iOS 16.0, *) {
					return .custom { _ in
						points
					}
				} else {
					// Fallback to medium for iOS 15
					return .medium()
				}
		}
	}

	/// Creates a unique identifier for use with UISheetPresentationController
	@available(iOS 15.0, *)
	var identifier: UISheetPresentationController.Detent.Identifier {
		switch self {
			case .medium:
				return .medium
			case .large:
				return .large
			case let .fraction(value):
				return .init("fraction-\(value)")
			case let .height(points):
				return .init("height-\(points)")
		}
	}
}
