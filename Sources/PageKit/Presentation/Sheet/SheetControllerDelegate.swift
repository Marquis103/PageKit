//
//  SheetControllerDelegate.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import UIKit

// MARK: - SheetControllerType

/// Type-erased protocol for setting sheet delegate without generic constraints
///
/// This protocol allows the Coordinator to set itself as the sheet delegate
/// without needing to know the generic Page type.
public protocol SheetControllerType: AnyObject {
	func setSheetDelegate(_ delegate: SheetControllerDelegate)
}

// MARK: - SheetControllerDelegate

/// Delegate protocol for handling sheet controller events
///
/// This protocol is critical for maintaining coordinator history when sheets
/// are interactively dismissed by the user dragging down.
public protocol SheetControllerDelegate: AnyObject {
	/// Called when the sheet controller is dismissed interactively
	///
	/// When a user drags a sheet down to dismiss it, UIKit calls
	/// `presentationControllerDidDismiss(_:)`. The SheetController forwards
	/// this to its delegate so the Coordinator can update its history.
	///
	/// **Without this**: Memory leaks, stale history, and lifecycle bugs.
	///
	/// - Parameter controller: The sheet controller that was dismissed
	func sheetControllerDidDismiss(_ controller: UIViewController)

	/// Called when the sheet's selected detent changes
	///
	/// Optional method for responding to detent changes (e.g., updating UI
	/// based on sheet expansion state).
	///
	/// - Parameters:
	///   - controller: The sheet controller
	///   - detent: The new selected detent identifier
	func sheetController(
		_ controller: UIViewController,
		didChangeSelectedDetent detent: SheetDetent?
	)
}

// MARK: - Default Implementations

extension SheetControllerDelegate {
	public func sheetController(
		_ controller: UIViewController,
		didChangeSelectedDetent detent: SheetDetent?
	) {
		// Optional - default does nothing
	}
}
