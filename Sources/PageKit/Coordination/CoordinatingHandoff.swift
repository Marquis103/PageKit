//
//  CoordinatingHandoff.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation

// MARK: - CoordinatingHandoff

public protocol CoordinatingHandoff where Self: Coordinator {
	associatedtype HandoffStep

	func childCoordinator(for step: HandoffStep) -> Coordinator
}

extension CoordinatingHandoff {
	public func handoff(to step: HandoffStep, with action: NavigationAction) {
		handoff(to: childCoordinator(for: step), with: action)
	}

	private func handoff(to childCoordinator: some Coordinator, with action: NavigationAction) {
		startCoordinator(childCoordinator, withAction: action)
	}
}
