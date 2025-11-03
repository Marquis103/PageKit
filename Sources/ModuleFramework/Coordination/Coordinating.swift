//
//  Coordinating.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Combine
import UIKit

// MARK: - Coordinating

protocol Coordinating: CoordinatorDelegate, ModuleSignalPublisher {
	var coordinators: [Coordinator?] { get set }
	var signalPublisher: AnyPublisher<ModuleSignal, Never> { get }

	func coordinate(action _: CoordinatableAction)

	func navigate(
		to viewController: UIViewController,
		with action: NavigationAction
	)

	func startCoordinator<T: Coordinator>(
		_ coordinator: T,
		withAction action: NavigationAction
	) -> T
}

extension Coordinating {
	var signalPublisher: AnyPublisher<any ModuleSignal, Never> { Empty().eraseToAnyPublisher() }

	func coordinate(action _: any CoordinatableAction) {
		// optional implementation for non coordinators that are `Coordinating`
	}

	func navigate(to _: UIViewController, with _: NavigationAction) {
		// optional implementation for non coordinators that are `Coordinating`
	}
}

extension Coordinating {
	@discardableResult
	func startCoordinator<T: Coordinator>(_ coordinator: T, withAction action: NavigationAction) -> T {
		coordinators.append(coordinator)
		coordinator.delegate = self
		coordinator.start(with: action)
		return coordinator
	}

	/// CoordinatorDelegate
	func coordinatorDidEnd(_ coordinator: Coordinator) {
		coordinators.removeAll(where: { $0 === coordinator })
	}
}
