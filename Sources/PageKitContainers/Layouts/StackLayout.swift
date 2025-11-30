//
//  StackLayout.swift
//
//  Copyright © 2025 PageKit. All rights reserved.
//

import SwiftUI

// MARK: - StackLayout

/// A simple stack-based layout for displaying Pages in a vertical or horizontal arrangement.
///
/// Ideal for simple multi-page interfaces where Pages should be stacked
/// without complex navigation patterns.
///
/// ```swift
/// enum PanelSlots: String, ContainerSlot {
///     case top, bottom
///     static var primary: PanelSlots { .top }
/// }
///
/// let layout = StackLayout<PanelSlots>(
///     axis: .vertical,
///     slots: [.top, .bottom],
///     spacing: 8
/// )
/// ```
@available(iOS 17, *)
public struct StackLayout<Slot: ContainerSlot>: ContainerLayout {
	/// The axis for stacking Pages.
	public let axis: Axis.Set

	/// The slots to display, in order.
	public let slots: [Slot]

	/// Spacing between stack items.
	public let spacing: CGFloat

	/// Whether the stack should be placed inside a ScrollView.
	public let scrollable: Bool

	/// Creates a stack layout with the specified configuration.
	/// - Parameters:
	///   - axis: The stack axis (`.vertical` or `.horizontal`). Defaults to `.vertical`.
	///   - slots: The slots to display in order.
	///   - spacing: Spacing between items. Defaults to 0.
	///   - scrollable: Whether to wrap in a ScrollView. Defaults to `false`.
	public init(
		axis: Axis.Set = .vertical,
		slots: [Slot],
		spacing: CGFloat = 0,
		scrollable: Bool = false
	) {
		self.axis = axis
		self.slots = slots
		self.spacing = spacing
		self.scrollable = scrollable
	}

	@MainActor
	public func body(slots slotProvider: SlotContentProvider<Slot>) -> some View {
		StackLayoutView(
			axis: axis,
			slots: slots,
			spacing: spacing,
			scrollable: scrollable,
			slotProvider: slotProvider
		)
	}
}

// MARK: - StackLayoutView

/// Internal SwiftUI view that renders the stack layout.
@available(iOS 17, *)
@MainActor
private struct StackLayoutView<Slot: ContainerSlot>: View {
	let axis: Axis.Set
	let slots: [Slot]
	let spacing: CGFloat
	let scrollable: Bool
	let slotProvider: SlotContentProvider<Slot>

	var body: some View {
		if scrollable {
			ScrollView(axis) {
				stackContent
			}
		} else {
			stackContent
		}
	}

	@ViewBuilder
	private var stackContent: some View {
		if axis == .vertical {
			VStack(spacing: spacing) {
				ForEach(slots, id: \.self) { slot in
					slotProvider[slot]
				}
			}
		} else {
			HStack(spacing: spacing) {
				ForEach(slots, id: \.self) { slot in
					slotProvider[slot]
				}
			}
		}
	}
}
