//
//  Throttler.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

/// A utility class that throttles actions to prevent rapid repeated execution.
/// Commonly used for button clicks, search inputs, and other user interactions
/// that should have a minimum time interval between executions.
///
/// Example usage:
/// ```swift
/// @StateObject private var throttler = Throttler()
///
/// Button("Submit") {
///     Task {
///         await throttler.throttle(interval: 0.5) {
///             // Action will only execute once per 0.5 seconds
///             submitForm()
///         }
///     }
/// }
/// ```
public final class Throttler: ObservableObject {
	@Published
	public private(set) var isThrottling = false

	public init() {}

	/// Throttles the execution of an action with a specified time interval
	/// - Parameters:
	///   - interval: The minimum time interval (in seconds) between executions
	///   - action: The action to execute if not currently throttling
	@MainActor
	public func throttle(
		interval: Double = 0.5,
		action: @escaping () -> Void
	) async {
		guard !isThrottling else { return }
		isThrottling = true
		action()
		let nanoseconds = interval * Double(1_000_000_000)
		try? await Task.sleep(nanoseconds: UInt64(nanoseconds))
		isThrottling = false
	}
}
