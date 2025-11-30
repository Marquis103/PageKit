//
//  NavigationAction.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import UIKit

public enum NavigationAction {
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
			case .modal:
				ModalController(page: page, mode: mode, rewinder: rewinder)
			default:
				PageHostController(page: page, mode: mode, rewinder: rewinder)
		}
	}
}
