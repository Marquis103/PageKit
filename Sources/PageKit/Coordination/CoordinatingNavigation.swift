//
//  CoordinatingNavigation.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import UIKit

// MARK: - CoordinatingNavigation

public protocol CoordinatingNavigation where Self: Coordinator {
	associatedtype NavigationStep

	func viewController(for step: NavigationStep) -> UIViewController?
	func page(for step: NavigationStep) -> (any Page)?
	func mode(for step: NavigationStep) -> PageMode
}

extension CoordinatingNavigation {
	public func viewController(for _: NavigationStep) -> UIViewController? {
		nil
	}

	public func page(for _: NavigationStep) -> (any Page)? {
		nil
	}

	public func mode(for _: NavigationStep) -> PageMode {
		.normal
	}

	@discardableResult
	public func navigate<T: UIViewController>(to step: NavigationStep, with action: NavigationAction) -> T? {
		if let page = page(for: step) {
			let mode = mode(for: step)
			let pageController = action.pageViewController(for: page, mode: mode, rewinder: rewinder(for: action))
			navigate(to: pageController, with: action)
			return pageController as? T
		} else if let viewController = viewController(for: step) {
			navigate(to: viewController, with: action)
			return viewController as? T
		} else {
			return nil
		}
	}

	private func rewinder(for action: NavigationAction) -> Rewinder {
		switch action {
			case let .sheet(configuration):
				Rewinder(rewindStyle: configuration.rewindStyle) { [weak self] in
					self?.rewind()
				}
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
