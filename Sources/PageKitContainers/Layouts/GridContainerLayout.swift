//
//  GridContainerLayout.swift
//
//  Copyright © 2025 PageKit. All rights reserved.
//

import SwiftUI

// MARK: - GridContainerLayout

/// A grid-based layout for displaying multiple Pages in a flexible grid.
///
/// Useful for dashboard-style interfaces where multiple Pages are displayed
/// as cards or tiles in a grid arrangement.
///
/// ```swift
/// enum DashboardSlots: String, ContainerSlot {
///     case stats, chart, activity, alerts
///     static var primary: DashboardSlots { .stats }
/// }
///
/// let layout = GridContainerLayout<DashboardSlots>(
///     columns: 2,
///     slots: [.stats, .chart, .activity, .alerts],
///     spacing: 16
/// )
/// ```
public struct GridContainerLayout<Slot: ContainerSlot>: ContainerLayout {
	/// Number of columns in the grid.
	public let columns: Int

	/// The slots to display, in order.
	public let slots: [Slot]

	/// Spacing between grid items.
	public let spacing: CGFloat

	/// Optional minimum height for each grid item.
	public let minItemHeight: CGFloat?

	/// Creates a grid layout with the specified configuration.
	/// - Parameters:
	///   - columns: Number of columns. Defaults to 2.
	///   - slots: The slots to display in order.
	///   - spacing: Spacing between items. Defaults to 16.
	///   - minItemHeight: Optional minimum height for items.
	public init(
		columns: Int = 2,
		slots: [Slot],
		spacing: CGFloat = 16,
		minItemHeight: CGFloat? = nil
	) {
		self.columns = columns
		self.slots = slots
		self.spacing = spacing
		self.minItemHeight = minItemHeight
	}

	@MainActor
	public func body(slots slotProvider: SlotContentProvider<Slot>) -> some View {
		GridContainerLayoutView(
			columns: columns,
			slots: slots,
			spacing: spacing,
			minItemHeight: minItemHeight,
			slotProvider: slotProvider
		)
	}

	/// Grid layout adapts to compact size class by using single column.
	public func adapted(for horizontalSizeClass: UserInterfaceSizeClass?) -> any ContainerLayout {
		if horizontalSizeClass == .compact {
			return GridContainerLayout(
				columns: 1,
				slots: slots,
				spacing: spacing,
				minItemHeight: minItemHeight
			)
		}
		return self
	}
}

// MARK: - GridContainerLayoutView

/// Internal SwiftUI view that renders the grid layout.
@MainActor
private struct GridContainerLayoutView<Slot: ContainerSlot>: View {
	let columns: Int
	let slots: [Slot]
	let spacing: CGFloat
	let minItemHeight: CGFloat?
	let slotProvider: SlotContentProvider<Slot>

	private var gridColumns: [GridItem] {
		Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns)
	}

	var body: some View {
		ScrollView {
			LazyVGrid(columns: gridColumns, spacing: spacing) {
				ForEach(slots, id: \.self) { slot in
					slotProvider[slot]
						.frame(minHeight: minItemHeight)
				}
			}
			.padding(spacing)
		}
	}
}
