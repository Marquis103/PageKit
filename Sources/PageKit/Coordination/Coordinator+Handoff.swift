//
//  Coordinator+Handoff.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation
import ObjectiveC

// MARK: - Coordinator End with Handoff

/// Provides a mechanism for child coordinators to signal handoff actions to parent coordinators.
/// The handoff action is stored and retrieved when the parent's coordinatorDidEnd is called.
private var handoffActionKey: UInt8 = 0

extension Coordinator {

    /// The pending handoff action to be communicated to the parent coordinator.
    public var pendingHandoffAction: CoordinatableAction? {
        get {
            objc_getAssociatedObject(self, &handoffActionKey) as? CoordinatableAction
        }
        set {
            objc_setAssociatedObject(
                self,
                &handoffActionKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    /// Ends this coordinator and signals a handoff action to the parent coordinator.
    /// - Parameter action: The action to pass to the parent coordinator for handling.
    public func end(with action: CoordinatableAction) {
        pendingHandoffAction = action
        end()
    }
}
