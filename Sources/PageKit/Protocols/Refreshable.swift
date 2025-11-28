//
//  Refreshable.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation

// MARK: - Refreshable

/// Protocol for ViewModels that support pull-to-refresh functionality
public protocol Refreshable: AnyObject {
	/// Performs the refresh operation
	/// - Returns: Void when refresh is complete
	@MainActor
	func onRefresh() async
}
