//
//  SlotContentProvider.swift
//
//  Copyright © 2025 PageKit. All rights reserved.
//

import SwiftUI

// MARK: - SlotContentProvider

/// Provides type-safe access to slot contents within a container layout.
///
/// This struct is passed to `ContainerLayout.body(slots:)` to allow layouts
/// to retrieve the view content for each slot using subscript syntax:
///
/// ```swift
/// func body(slots: SlotContentProvider<MySlots>) -> some View {
///     NavigationSplitView {
///         slots[.sidebar]
///     } detail: {
///         slots[.detail]
///     }
/// }
/// ```
@available(iOS 17, *)
@MainActor
public struct SlotContentProvider<Slot: ContainerSlot> {
	private let contents: [Slot: AnyView]

	/// Creates a slot content provider with the given slot-to-view mapping.
	/// - Parameter contents: Dictionary mapping slots to their SwiftUI views.
	public init(contents: [Slot: AnyView]) {
		self.contents = contents
	}

	/// Retrieves the view for a given slot.
	/// - Parameter slot: The slot to retrieve content for.
	/// - Returns: The view assigned to that slot, or an empty view if unassigned.
	public subscript(slot: Slot) -> AnyView {
		contents[slot] ?? AnyView(EmptyView())
	}

	/// Returns whether a slot has content assigned.
	/// - Parameter slot: The slot to check.
	/// - Returns: `true` if the slot has content, `false` otherwise.
	public func hasContent(for slot: Slot) -> Bool {
		contents[slot] != nil
	}

	/// Returns all slots that currently have content.
	public var populatedSlots: [Slot] {
		Array(contents.keys)
	}
}
