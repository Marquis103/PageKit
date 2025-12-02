//
//  SheetController.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

// MARK: - SheetController

/// A view controller that presents a Page as a native iOS bottom sheet
///
/// SheetController extends PageHostController to provide:
/// - Native `UISheetPresentationController` with detent support
/// - Interactive dismissal with proper coordinator history management
/// - Full integration with PageKit's signal/action flow
///
/// ```swift
/// // In your coordinator:
/// navigate(to: settingsPage, with: .sheet())
///
/// // With custom configuration:
/// navigate(to: filterPage, with: .sheet(.compact))
/// ```
@available(iOS 15.0, *)
public final class SheetController<P: Page>:
	PageHostController<P>,
	SheetControllerType,
	UISheetPresentationControllerDelegate,
	UIAdaptivePresentationControllerDelegate
{
	/// The sheet configuration
	public let configuration: SheetConfiguration

	/// Delegate for handling sheet dismissal events
	public weak var sheetDelegate: SheetControllerDelegate?

	/// Tracks the currently selected detent for delegate notifications
	private var currentDetent: SheetDetent?

	/// Initialize a sheet controller
	/// - Parameters:
	///   - page: The page to display
	///   - mode: The page presentation mode
	///   - rewinder: The rewinder for navigation
	///   - configuration: The sheet configuration
	public init(
		page: P,
		mode: PageMode = .normal,
		rewinder: Rewinder,
		configuration: SheetConfiguration
	) {
		self.configuration = configuration
		super.init(page: page, mode: mode, rewinder: rewinder)

		// Configure modal presentation
		modalPresentationStyle = .pageSheet

		// Prevent interactive dismissal if not dismissible
		isModalInPresentation = !configuration.isDismissible
	}

	// MARK: - View Lifecycle

	override public func viewDidLoad() {
		super.viewDidLoad()
		configureSheetPresentation()
	}

	// MARK: - Sheet Configuration

	private func configureSheetPresentation() {
		guard let sheet = sheetPresentationController else { return }

		// Configure detents
		sheet.detents = configuration.detents.map { $0.toUIKitDetent() }

		// Set initially selected detent
		if let selectedDetent = configuration.selectedDetent {
			sheet.selectedDetentIdentifier = selectedDetent.identifier
			currentDetent = selectedDetent
		}

		// Configure appearance
		sheet.prefersGrabberVisible = configuration.showsGrabber

		if let cornerRadius = configuration.cornerRadius {
			sheet.preferredCornerRadius = cornerRadius
		}

		// Configure dimming
		if let largestUndimmed = configuration.largestUndimmedDetent {
			sheet.largestUndimmedDetentIdentifier = largestUndimmed.identifier
		}

		// Configure edge behavior
		sheet.prefersEdgeAttachedInCompactHeight = configuration.prefersEdgeAttachedInCompactHeight
		sheet.prefersScrollingExpandsWhenScrolledToEdge = configuration.prefersScrollingExpandsWhenScrolledToEdge

		// Set delegate for dismissal and detent change tracking
		sheet.delegate = self
	}

	// MARK: - Detent Helpers

	/// Returns the current SheetDetent based on the selected identifier
	private func detent(for identifier: UISheetPresentationController.Detent.Identifier?) -> SheetDetent? {
		guard let identifier else { return nil }

		// Check standard identifiers first
		if identifier == .medium {
			return .medium
		} else if identifier == .large {
			return .large
		}

		// Check custom identifiers
		let identifierString = identifier.rawValue

		if identifierString.hasPrefix("fraction-"),
		   let value = Double(identifierString.replacingOccurrences(of: "fraction-", with: ""))
		{
			return .fraction(CGFloat(value))
		}

		if identifierString.hasPrefix("height-"),
		   let value = Double(identifierString.replacingOccurrences(of: "height-", with: ""))
		{
			return .height(CGFloat(value))
		}

		return nil
	}

	// MARK: - SheetControllerType

	public func setSheetDelegate(_ delegate: SheetControllerDelegate) {
		sheetDelegate = delegate
	}

	// MARK: - UISheetPresentationControllerDelegate

	public func sheetPresentationControllerDidChangeSelectedDetentIdentifier(
		_ sheetPresentationController: UISheetPresentationController
	) {
		let newDetent = detent(for: sheetPresentationController.selectedDetentIdentifier)

		if newDetent != currentDetent {
			currentDetent = newDetent
			sheetDelegate?.sheetController(self, didChangeSelectedDetent: newDetent)
		}
	}

	// MARK: - UIAdaptivePresentationControllerDelegate

	public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
		// Notify delegate that the sheet was interactively dismissed
		// This is CRITICAL for coordinator history management
		sheetDelegate?.sheetControllerDidDismiss(self)
	}

	public func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
		// Respect the configuration's dismissible setting
		configuration.isDismissible
	}

	public func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
		// Called when user tries to dismiss but isDismissible is false
		// Could be used for haptic feedback or showing a message
	}
}
