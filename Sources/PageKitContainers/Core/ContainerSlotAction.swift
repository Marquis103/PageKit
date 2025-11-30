//
//  ContainerSlotAction.swift
//
//  Copyright © 2025 PageKit. All rights reserved.
//

import PageKit

// MARK: - ContainerSlotAction

/// Actions specific to managing slots within a container.
///
/// Use these actions to update slot contents from within a coordinator's
/// `coordinate(action:)` method.
public enum ContainerSlotAction<Slot: ContainerSlot> {
	/// Update a slot with a new Page.
	case updateSlot(Slot, with: any Page)

	/// Clear a slot's content (shows empty state).
	case clearSlot(Slot)

	/// Set focus to a specific slot.
	case focusSlot(Slot)
}
