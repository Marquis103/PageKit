//
//  NavigationAction.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import UIKit

public enum NavigationAction {
	/// Native iOS bottom sheet using UISheetPresentationController
	///
	/// Provides full integration with PageKit's Coordinator pattern:
	/// - Signals flow from parent to sheet
	/// - Actions flow from sheet to coordinator
	/// - Interactive dismissal updates coordinator history
	///
	/// ```swift
	/// // Standard sheet with medium/large detents
	/// navigate(to: settingsPage, with: .sheet())
	///
	/// // Compact half-height sheet
	/// navigate(to: filtersPage, with: .sheet(.compact))
	///
	/// // Non-dismissible for required flows
	/// navigate(to: onboardingPage, with: .sheet(.required))
	/// ```
	@available(iOS 15.0, *)
	case sheet(SheetConfiguration = .standard)

	/// Slide up modal from bottom using custom SwiftUI animation
	@available(*, deprecated, message: "Use .sheet() instead for native iOS bottom sheet presentation")
	case modal(rewindStyle: RewindStyle = .none)

	/// Just starts the coordinator and creates the controller
	case none

	/// Push a view controller onto the current active navigation controller
	case push(rewindStyle: RewindStyle)

	/// Present a view controller over the current active view controller
	/// Presented view controller will be contained in a navigation controller
	case present(
		rewindStyle: RewindStyle,
		transition: UIModalTransitionStyle? = nil
	)

	/// Allows the system to handle presentation
	case system

	/// Attaches the controller to the key window
	case window

	/// Presents content within a container slot (used by PageKitContainers)
	/// The container handles its own layout and slot management
	case container

	public func rewind(
		viewController: UIViewController,
		animated: Bool,
		completion: (() -> Void)? = nil
	) {
		switch self {
			case .push:
				// Pop
				guard viewController.navigationController?.viewControllers.last == viewController else { return }

				viewController.navigationController?.popViewController(animated: animated)
				completion?()
			case .sheet:
				// Dismiss the sheet
				viewController.dismiss(animated: animated, completion: completion)
			case .modal:
				if let dismissable = viewController as? ModalDismissable {
					dismissable.dismissModal {
						// Dismiss without animation (animation is handled by SwiftUI)
						viewController.dismiss(animated: false, completion: completion)
					}
				} else {
					// Fallback to dismiss with animation
					viewController.dismiss(animated: animated, completion: completion)
				}
			case .present,
			     .system:
				// Dismiss
				viewController.dismiss(animated: animated, completion: completion)
			case .none:
				// Nothing to dismiss
				break
			case .window:
				// Note: Window dismissal removed - implement in your app coordinator
				break
			case .container:
				// Container slot content is managed by PageContainer, not rewound directly
				// The container handles slot clearing through its own API
				break
		}
	}

	public func pageViewController(for page: some Page, mode: PageMode, rewinder: Rewinder) -> UIViewController {
		switch self {
			case let .sheet(configuration):
				if #available(iOS 15.0, *) {
					return SheetController(
						page: page,
						mode: mode,
						rewinder: rewinder,
						configuration: configuration
					)
				} else {
					// Fallback to modal for iOS 14 and earlier
					return ModalController(page: page, mode: mode, rewinder: rewinder)
				}
			case .modal:
				return ModalController(page: page, mode: mode, rewinder: rewinder)
			default:
				return PageHostController(page: page, mode: mode, rewinder: rewinder)
		}
	}
}
