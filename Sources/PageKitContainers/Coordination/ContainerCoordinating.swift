//
//  ContainerCoordinating.swift
//
//  Copyright © 2025 PageKit. All rights reserved.
//

import PageKit
import SwiftUI
import UIKit

// MARK: - ContainerCoordinating

/// A protocol for coordinators that manage multi-page containers.
///
/// Adopt this protocol in coordinators that need to present multiple Pages
/// simultaneously using container layouts like `SplitLayout` or `GridContainerLayout`.
///
/// ```swift
/// class SettingsCoordinator: Coordinator, ContainerCoordinating {
///     typealias ContainerSlotType = SettingsSlots
///     typealias ContainerLayoutType = SplitLayout<SettingsSlots>
///
///     private(set) var container: PageContainer<SplitLayout<SettingsSlots>>?
///
///     override func start(with action: NavigationAction) {
///         let layout = SplitLayout<SettingsSlots>(
///             sidebarSlot: .menu,
///             detailSlot: .detail
///         )
///         let container = createContainer(with: layout)
///         container.assign(MenuPage(coordinator: self), to: .menu)
///         container.assign(PlaceholderPage(coordinator: self), to: .detail)
///         navigate(to: container, with: action)
///     }
///
///     func updateDetail(with page: some Page) {
///         container?.assign(page, to: .detail)
///     }
/// }
/// ```
public protocol ContainerCoordinating: Coordinating {
	/// The slot type used by this coordinator's container.
	associatedtype ContainerSlotType: ContainerSlot

	/// The layout type used by this coordinator's container.
	associatedtype ContainerLayoutType: ContainerLayout where ContainerLayoutType.Slot == ContainerSlotType

	/// The container managed by this coordinator.
	var container: PageContainer<ContainerLayoutType>? { get }
}

// MARK: - Default Implementation

extension ContainerCoordinating where Self: Coordinator {
	/// Creates a container with the given layout.
	///
	/// This is the primary way to create a `PageContainer` in a coordinator.
	/// The container is created but not yet navigated to - call `navigate(to:with:)`
	/// to present it.
	///
	/// - Parameter layout: The layout to use for the container.
	/// - Returns: A new `PageContainer` configured with the given layout.
	public func createContainer(with layout: ContainerLayoutType) -> PageContainer<ContainerLayoutType> {
		PageContainer(layout: layout, coordinator: self)
	}

	/// Assigns a Page to a slot in the container.
	///
	/// This is a convenience method that forwards to `container?.assign(_:to:)`.
	///
	/// - Parameters:
	///   - page: The Page to assign.
	///   - slot: The slot to assign it to.
	public func assignToContainer<P: Page>(_ page: P, to slot: ContainerSlotType) {
		container?.assign(page, to: slot)
	}

	/// Clears a slot in the container.
	///
	/// This is a convenience method that forwards to `container?.clear(slot:)`.
	///
	/// - Parameter slot: The slot to clear.
	public func clearContainerSlot(_ slot: ContainerSlotType) {
		container?.clear(slot: slot)
	}

	/// Returns whether a slot in the container has content.
	///
	/// - Parameter slot: The slot to check.
	/// - Returns: `true` if the slot has a Page assigned, `false` otherwise.
	public func containerHasContent(in slot: ContainerSlotType) -> Bool {
		container?.hasContent(in: slot) ?? false
	}
}

// MARK: - ContainerSlotSignal

/// A signal type for slot-based communication between Pages in a container.
///
/// Use `ContainerSlotSignal` to communicate updates between Pages that share
/// a container. For example, when a sidebar selection changes, send a signal
/// to update the detail pane.
///
/// ```swift
/// // Define in your coordinator
/// struct SelectItem: ContainerSlotSignal {
///     let itemId: String
///     let targetSlot: MySlots = .detail
/// }
///
/// // Send from a Page
/// coordinator.send(signal: SelectItem(itemId: "123"))
///
/// // Receive in another Page
/// coordinator.signalPublisher
///     .compactMap { $0 as? SelectItem }
///     .sink { signal in
///         loadItem(signal.itemId)
///     }
/// ```
public protocol ContainerSlotSignal: PageSignal {
	/// The slot type this signal targets.
	associatedtype Slot: ContainerSlot

	/// The slot this signal is intended for.
	var targetSlot: Slot { get }
}

// MARK: - ContainerNavigationStep

/// A protocol for navigation steps that target container slots.
///
/// Adopt this protocol in your coordinator's `NavigationStep` type to enable
/// slot-based navigation within containers.
///
/// ```swift
/// enum SettingsStep: ContainerNavigationStep {
///     case showGeneral
///     case showPrivacy
///     case showNotifications
///
///     var targetSlot: SettingsSlots? {
///         .detail  // All steps target the detail slot
///     }
/// }
/// ```
public protocol ContainerNavigationStep {
	/// The slot type for container navigation.
	associatedtype Slot: ContainerSlot

	/// The slot this navigation step should target.
	/// Return `nil` for full-screen navigation that replaces the container.
	var targetSlot: Slot? { get }
}
