//
//  PageSlotLifecycle.swift
//
//  Copyright © 2025 PageKit. All rights reserved.
//

import PageKit
import SwiftUI

// MARK: - PageSlotLifecycle

/// Manages the lifecycle of a Page within a container slot.
///
/// This class tracks appearance state and calls the appropriate ViewModel
/// lifecycle methods (`onStart`, `onResume`, `onPause`, `onEnd`) based on
/// SwiftUI's `onAppear`/`onDisappear` callbacks.
@MainActor
public final class PageSlotLifecycle<P: Page>: ObservableObject {
	private let page: P
	private var hasStarted = false

	/// Creates a lifecycle manager for the given Page.
	/// - Parameter page: The Page to manage lifecycle for.
	public init(page: P) {
		self.page = page
	}

	/// Called when the slot's view appears.
	///
	/// On first appearance, calls `onStart()`. On subsequent appearances,
	/// calls `onResume()`.
	public func handleAppear() {
		if !hasStarted {
			hasStarted = true
			Task {
				await page.viewModel.onStart()
			}
		} else {
			Task {
				await page.viewModel.onResume()
			}
		}
	}

	/// Called when the slot's view disappears.
	///
	/// Calls `onPause()` to allow the ViewModel to pause any ongoing work.
	public func handleDisappear() {
		Task {
			await page.viewModel.onPause()
		}
	}

	deinit {
		// onEnd is nonisolated and sync, can be called directly from deinit
		page.viewModel.onEnd()
	}
}
