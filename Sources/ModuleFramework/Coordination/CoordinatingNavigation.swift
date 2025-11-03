//
//  CoordinatingNavigation.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import UIKit

// MARK: - CoordinatingNavigation

protocol CoordinatingNavigation where Self: Coordinator {
	associatedtype NavigationStep

	func viewController(for step: NavigationStep) -> UIViewController?
	func module(for step: NavigationStep) -> (any Module)?
	func mode(for step: NavigationStep) -> PageMode
}

extension CoordinatingNavigation {
	func viewController(for _: NavigationStep) -> UIViewController? {
		nil
	}

	func module(for _: NavigationStep) -> (any Module)? {
		nil
	}

	func mode(for _: NavigationStep) -> PageMode {
		.normal
	}

	@discardableResult
	func navigate<T: UIViewController>(to step: NavigationStep, with action: NavigationAction) -> T? {
		if let module = module(for: step) {
			let mode = mode(for: step)
			let moduleController = action.moduleViewController(for: module, mode: mode, rewinder: rewinder(for: action))
			navigate(to: moduleController, with: action)
			return moduleController as? T
		} else if let viewController = viewController(for: step) {
			navigate(to: viewController, with: action)
			return viewController as? T
		} else {
			return nil
		}
	}

	private func rewinder(for action: NavigationAction) -> Rewinder {
		switch action {
			case let .modal(rewindStyle),
			     let .present(rewindStyle, _),
			     let .push(rewindStyle):
				Rewinder(rewindStyle: rewindStyle) { [weak self] in
					self?.rewind()
				}
			case .none,
			     .window:
				Rewinder(rewindStyle: nil, rewind: nil)
			default:
				Rewinder(rewindStyle: nil) { [weak self] in
					self?.rewind()
				}
		}
	}
}
