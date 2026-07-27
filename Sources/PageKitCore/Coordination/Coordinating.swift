//
//  Coordinating.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

// MARK: - Coordinating

/// The portable coordination contract (PE-533 split, 2.0.0).
///
/// Pages and view models speak to their coordinator through exactly this:
/// dispatch an action, subscribe to signals. Everything UIKit-shaped that the
/// pre-2.0 protocol also required — `coordinators`, `navigate(to:with:)`,
/// `startCoordinator` — lives with the `Coordinator` base class in
/// PageKitUIKit; view models never could reach those members anyway (the
/// default no-ops proved it).
///
/// Adopters that don't publish signals or route actions get no-op defaults,
/// so a minimal feature coordinator is just `coordinate(action:)`.
@MainActor
public protocol Coordinating: AnyObject, PageSignalPublisher {
	func coordinate(action _: CoordinatableAction)

	/// Publish a signal to this coordinator's subscribers.
	func send(signal: PageSignal)
}

extension Coordinating {
	public func coordinate(action _: any CoordinatableAction) {
		// optional implementation for non coordinators that are `Coordinating`
	}

	public func send(signal _: PageSignal) {
		// optional implementation for coordinators that never publish
	}
}
