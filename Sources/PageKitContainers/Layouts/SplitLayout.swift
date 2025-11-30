//
//  SplitLayout.swift
//
//  Copyright © 2025 PageKit. All rights reserved.
//

import SwiftUI

// MARK: - SplitLayout

/// A two-column split view layout using `NavigationSplitView`.
///
/// This layout provides the classic iPad master-detail pattern with a
/// sidebar on the left and detail content on the right.
///
/// ```swift
/// enum SettingsSlots: String, ContainerSlot {
///     case menu, detail
///     static var primary: SettingsSlots { .menu }
/// }
///
/// let layout = SplitLayout<SettingsSlots>(
///     sidebarSlot: .menu,
///     detailSlot: .detail
/// )
/// ```
public struct SplitLayout<Slot: ContainerSlot>: ContainerLayout {
	/// The slot displayed in the sidebar (left) column.
	public let sidebarSlot: Slot

	/// The slot displayed in the detail (right) column.
	public let detailSlot: Slot

	/// Optional preferred width for the sidebar column.
	public let preferredSidebarWidth: CGFloat?

	/// Column visibility state for the split view.
	public var columnVisibility: NavigationSplitViewVisibility

	/// Creates a split layout with the specified sidebar and detail slots.
	/// - Parameters:
	///   - sidebarSlot: The slot for the sidebar column.
	///   - detailSlot: The slot for the detail column.
	///   - preferredSidebarWidth: Optional preferred width for sidebar.
	///   - columnVisibility: Initial column visibility. Defaults to `.all`.
	public init(
		sidebarSlot: Slot,
		detailSlot: Slot,
		preferredSidebarWidth: CGFloat? = nil,
		columnVisibility: NavigationSplitViewVisibility = .all
	) {
		self.sidebarSlot = sidebarSlot
		self.detailSlot = detailSlot
		self.preferredSidebarWidth = preferredSidebarWidth
		self.columnVisibility = columnVisibility
	}

	@MainActor
	public func body(slots: SlotContentProvider<Slot>) -> some View {
		SplitLayoutView(
			sidebarSlot: sidebarSlot,
			detailSlot: detailSlot,
			preferredSidebarWidth: preferredSidebarWidth,
			initialVisibility: columnVisibility,
			slots: slots
		)
	}
}

// MARK: - SplitLayoutView

/// Internal SwiftUI view that renders the split layout.
@MainActor
private struct SplitLayoutView<Slot: ContainerSlot>: View {
	let sidebarSlot: Slot
	let detailSlot: Slot
	let preferredSidebarWidth: CGFloat?
	let initialVisibility: NavigationSplitViewVisibility
	let slots: SlotContentProvider<Slot>

	@State private var columnVisibility: NavigationSplitViewVisibility

	init(
		sidebarSlot: Slot,
		detailSlot: Slot,
		preferredSidebarWidth: CGFloat?,
		initialVisibility: NavigationSplitViewVisibility,
		slots: SlotContentProvider<Slot>
	) {
		self.sidebarSlot = sidebarSlot
		self.detailSlot = detailSlot
		self.preferredSidebarWidth = preferredSidebarWidth
		self.initialVisibility = initialVisibility
		self.slots = slots
		_columnVisibility = State(initialValue: initialVisibility)
	}

	var body: some View {
		NavigationSplitView(columnVisibility: $columnVisibility) {
			sidebarContent
		} detail: {
			if slots.hasContent(for: detailSlot) {
				slots[detailSlot]
			} else {
				ContentUnavailableView(
					"Select an item",
					systemImage: "sidebar.left",
					description: Text("Choose something from the sidebar to view details.")
				)
			}
		}
		.navigationSplitViewStyle(.balanced)
	}

	@ViewBuilder
	private var sidebarContent: some View {
		if let width = preferredSidebarWidth {
			slots[sidebarSlot]
				.navigationSplitViewColumnWidth(
					min: width * 0.8,
					ideal: width,
					max: width * 1.2
				)
		} else {
			slots[sidebarSlot]
		}
	}
}
