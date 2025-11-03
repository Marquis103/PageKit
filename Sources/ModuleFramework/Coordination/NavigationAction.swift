//
//  NavigationAction.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import UIKit

enum NavigationAction {
	/// Slide up modal from bottom
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

	func rewind(
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
		}
	}

	func moduleViewController(for module: some Module, mode: PageMode, rewinder: Rewinder) -> UIViewController {
		switch self {
			case .modal:
				ModalController(module: module, mode: mode, rewinder: rewinder)
			default:
				PageController(module: module, mode: mode, rewinder: rewinder)
		}
	}
}
