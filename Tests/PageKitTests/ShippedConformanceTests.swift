//
//  ShippedConformanceTests.swift
//
//  Copyright © 2026 PageKit All rights reserved.
//

import Foundation
import Testing
import PageKit

// MARK: - The shipped feature-coordinator shape (PE-533 compatibility contract)

// This fixture is byte-shaped like the feature coordinators shipped in Ayes
// (Onboarding/Paywall/Watchlist/Auth/Gamification/Topics/Settings/Social/Home):
// `NSObject + Coordinating`, a `coordinators: [Coordinator?]` property, four
// `CoordinatorDelegate`-shaped no-ops, and `coordinate(action:)`. Under the
// 2.0.0 umbrella the extra members are no longer protocol REQUIREMENTS — but
// they must keep COMPILING unchanged (the `Coordinator` type reaches here via
// the PageKitUIKit re-export). If this file stops building, the split broke
// its consumers.

private enum FixtureAction: CoordinatableAction {
	case something
}

@MainActor
private final class ShippedShapeCoordinator: NSObject, Coordinating {
	var coordinators: [Coordinator?] = []
	private(set) var received: [any CoordinatableAction] = []

	func coordinate(action: CoordinatableAction) {
		received.append(action)
	}

	func coordinatorWillStart(_ coordinator: Coordinator) {}
	func coordinatorDidStart(_ coordinator: Coordinator) {}
	func coordinatorWillEnd(_ coordinator: Coordinator) {}
	func coordinatorDidEnd(_ coordinator: Coordinator) {}
}

@Suite("Shipped conformance shape (2.0.0 umbrella)")
@MainActor
struct ShippedConformanceTests {

	@Test("The Ayes feature-coordinator shape compiles and satisfies Coordinating")
	func shippedShapeSatisfiesCoordinating() {
		let coordinator: any Coordinating = ShippedShapeCoordinator()

		coordinator.coordinate(action: FixtureAction.something)

		let shipped = coordinator as? ShippedShapeCoordinator
		#expect(shipped?.received.count == 1)
		// The vestigial members remain usable plain members.
		#expect(shipped?.coordinators.isEmpty == true)
	}

	@Test("A Coordinator subclass still gets navigate/start/signals from the base")
	func coordinatorBaseSurfaceIntact() async {
		final class ShellLike: Coordinator {
			override func start(with _: NavigationAction) {}
		}
		let shell = ShellLike(rootViewController: .init())

		// The pre-2.0 call surface: signals + send survive the Combine removal.
		let stream = shell.signals()
		async let first: Bool = {
			for await _ in stream { return true }
			return false
		}()
		await Task.yield()
		struct Ping: PageSignal {}
		shell.send(signal: Ping())

		#expect(await first)
	}
}
