//
//  ContainerSlot.swift
//
//  Copyright © 2025 PageKit. All rights reserved.
//

import Foundation

// MARK: - ContainerSlot

/// Protocol for defining named slots (regions) in a container layout.
///
/// - Note: Requires iOS 17.0 or later.
///
/// Slots identify where Pages can be placed within a multi-page container.
/// Define your slots as an enum conforming to this protocol:
///
/// ```swift
/// enum MailSlots: String, ContainerSlot {
///     case sidebar
///     case messages
///     case detail
///
///     static var primary: MailSlots { .sidebar }
/// }
/// ```
@available(iOS 17, *)
public protocol ContainerSlot: Hashable, CaseIterable, RawRepresentable where RawValue == String {
	/// The primary slot that receives initial focus.
	///
	/// This slot is typically the "master" in a master-detail layout,
	/// or the leftmost column in a multi-column layout.
	static var primary: Self { get }
}
