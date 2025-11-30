//
//  ContainerLayout.swift
//
//  Copyright © 2025 PageKit. All rights reserved.
//

import SwiftUI

// MARK: - ContainerLayout

/// Protocol for defining how slots are visually arranged in a container.
///
/// Implement this protocol to create custom layouts for multi-page containers.
/// The framework provides built-in layouts like `SplitLayout` and `TripleColumnLayout`.
///
/// ```swift
/// struct MyCustomLayout<Slot: ContainerSlot>: ContainerLayout {
///     func body(slots: SlotContentProvider<Slot>) -> some View {
///         HStack {
///             slots[.sidebar]
///             Divider()
///             slots[.detail]
///         }
///     }
/// }
/// ```
@available(iOS 17, *)
public protocol ContainerLayout {
	/// The slot type this layout works with.
	associatedtype Slot: ContainerSlot

	/// The SwiftUI view type returned by `body(slots:)`.
	associatedtype Body: View

	/// Creates the SwiftUI view that arranges the slot contents.
	/// - Parameter slots: Provider for accessing slot content by slot identifier.
	/// - Returns: A SwiftUI view arranging the slots.
	@MainActor @ViewBuilder
	func body(slots: SlotContentProvider<Slot>) -> Body

	/// Whether this layout supports per-slot navigation (Rewinder) behavior.
	///
	/// When `false` (default), the entire container has one Rewinder that
	/// dismisses the whole container. When `true`, each slot can have
	/// its own navigation stack and back behavior.
	var supportsPerSlotRewinding: Bool { get }

	/// Returns an adapted layout for a given horizontal size class.
	///
	/// Override this to provide different layouts for compact vs regular
	/// size classes (e.g., stack layout on iPhone, split view on iPad).
	///
	/// - Parameter horizontalSizeClass: The current horizontal size class.
	/// - Returns: A layout appropriate for the size class.
	func adapted(for horizontalSizeClass: UserInterfaceSizeClass?) -> any ContainerLayout
}

// MARK: - Default Implementations

@available(iOS 17, *)
extension ContainerLayout {
	/// Default: Container-level rewinding (entire container dismisses together).
	public var supportsPerSlotRewinding: Bool { false }

	/// Default: Return self (no adaptation).
	public func adapted(for horizontalSizeClass: UserInterfaceSizeClass?) -> any ContainerLayout {
		self
	}
}
