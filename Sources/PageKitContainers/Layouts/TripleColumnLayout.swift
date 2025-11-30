//
//  TripleColumnLayout.swift
//
//  Copyright © 2025 PageKit. All rights reserved.
//

import SwiftUI

// MARK: - TripleColumnLayout

/// A three-column layout using `NavigationSplitView` with sidebar, content, and detail.
///
/// This layout provides the Mail.app-style pattern with three columns:
/// sidebar (folders), content (messages), and detail (message preview).
///
/// ```swift
/// enum MailSlots: String, ContainerSlot {
///     case folders, messages, detail
///     static var primary: MailSlots { .folders }
/// }
///
/// let layout = TripleColumnLayout<MailSlots>(
///     sidebarSlot: .folders,
///     contentSlot: .messages,
///     detailSlot: .detail
/// )
/// ```
@available(iOS 17, *)
public struct TripleColumnLayout<Slot: ContainerSlot>: ContainerLayout {
	/// The slot displayed in the sidebar (leftmost) column.
	public let sidebarSlot: Slot

	/// The slot displayed in the content (middle) column.
	public let contentSlot: Slot

	/// The slot displayed in the detail (rightmost) column.
	public let detailSlot: Slot

	/// Column visibility state for the split view.
	public var columnVisibility: NavigationSplitViewVisibility

	/// Creates a triple-column layout with the specified slots.
	/// - Parameters:
	///   - sidebarSlot: The slot for the sidebar (left) column.
	///   - contentSlot: The slot for the content (middle) column.
	///   - detailSlot: The slot for the detail (right) column.
	///   - columnVisibility: Initial column visibility. Defaults to `.all`.
	public init(
		sidebarSlot: Slot,
		contentSlot: Slot,
		detailSlot: Slot,
		columnVisibility: NavigationSplitViewVisibility = .all
	) {
		self.sidebarSlot = sidebarSlot
		self.contentSlot = contentSlot
		self.detailSlot = detailSlot
		self.columnVisibility = columnVisibility
	}

	@MainActor
	public func body(slots: SlotContentProvider<Slot>) -> some View {
		TripleColumnLayoutView(
			sidebarSlot: sidebarSlot,
			contentSlot: contentSlot,
			detailSlot: detailSlot,
			initialVisibility: columnVisibility,
			slots: slots
		)
	}
}

// MARK: - TripleColumnLayoutView

/// Internal SwiftUI view that renders the triple-column layout.
@available(iOS 17, *)
@MainActor
private struct TripleColumnLayoutView<Slot: ContainerSlot>: View {
	let sidebarSlot: Slot
	let contentSlot: Slot
	let detailSlot: Slot
	let initialVisibility: NavigationSplitViewVisibility
	let slots: SlotContentProvider<Slot>

	@State private var columnVisibility: NavigationSplitViewVisibility

	init(
		sidebarSlot: Slot,
		contentSlot: Slot,
		detailSlot: Slot,
		initialVisibility: NavigationSplitViewVisibility,
		slots: SlotContentProvider<Slot>
	) {
		self.sidebarSlot = sidebarSlot
		self.contentSlot = contentSlot
		self.detailSlot = detailSlot
		self.initialVisibility = initialVisibility
		self.slots = slots
		_columnVisibility = State(initialValue: initialVisibility)
	}

	var body: some View {
		NavigationSplitView(columnVisibility: $columnVisibility) {
			slots[sidebarSlot]
		} content: {
			if slots.hasContent(for: contentSlot) {
				slots[contentSlot]
			} else {
				ContentUnavailableView(
					"Select a category",
					systemImage: "folder",
					description: Text("Choose a category from the sidebar.")
				)
			}
		} detail: {
			if slots.hasContent(for: detailSlot) {
				slots[detailSlot]
			} else {
				ContentUnavailableView(
					"Select an item",
					systemImage: "doc.text",
					description: Text("Choose an item to view details.")
				)
			}
		}
		.navigationSplitViewStyle(.balanced)
	}
}
