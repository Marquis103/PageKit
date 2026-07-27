//
//  Coordinating+UIKit.swift
//
//  Copyright © 2026 PageKit All rights reserved.
//

import PageKitCore
import UIKit

// MARK: - Coordinating + UIKit navigation

// The UIKit-shaped members the pre-2.0 `Coordinating` protocol required.
// Since the PE-533 split the portable protocol is just
// `coordinate(action:)` + signals; these live on as extensions so
// Coordinator-based code keeps its exact call surface and behavior.

extension Coordinating {
	/// Optional implementation for non-coordinators that are `Coordinating`.
	/// `Coordinator` overrides with the real push/present machinery.
	public func navigate(to _: UIViewController, with _: NavigationAction) {
		// optional implementation for non coordinators that are `Coordinating`
	}
}

extension Coordinator {
	/// Start a child coordinator: track it, adopt its delegate, run it.
	/// Behavior-identical to the pre-2.0 `Coordinating` default — the child
	/// is appended to `coordinators` and removed again by the base class's
	/// `coordinatorDidEnd`.
	@discardableResult
	public func startCoordinator<T: Coordinator>(_ coordinator: T, withAction action: NavigationAction) -> T {
		coordinators.append(coordinator)
		coordinator.delegate = self
		coordinator.start(with: action)
		return coordinator
	}
}
