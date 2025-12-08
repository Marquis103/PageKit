//
//  Coordinating.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Combine
import UIKit

// MARK: - Coordinating

@MainActor
public protocol Coordinating: CoordinatorDelegate, PageSignalPublisher {
	var coordinators: [Coordinator?] { get set }
	var signalPublisher: AnyPublisher<PageSignal, Never> { get }

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
	public var signalPublisher: AnyPublisher<any PageSignal, Never> { Empty().eraseToAnyPublisher() }

	public func coordinate(action _: any CoordinatableAction) {
		// optional implementation for non coordinators that are `Coordinating`
	}

	public func navigate(to _: UIViewController, with _: NavigationAction) {
		// optional implementation for non coordinators that are `Coordinating`
	}
}

extension Coordinating {
	@discardableResult
	public func startCoordinator<T: Coordinator>(_ coordinator: T, withAction action: NavigationAction) -> T {
		coordinators.append(coordinator)
		coordinator.delegate = self
		coordinator.start(with: action)
		return coordinator
	}

	/// CoordinatorDelegate
	public func coordinatorDidEnd(_ coordinator: Coordinator) {
		coordinators.removeAll(where: { $0 === coordinator })
	}
}
