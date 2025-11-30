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
@available(iOS 17, *)
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
	/// calls `onResume()`. Both sync and async versions are invoked.
	public func handleAppear() {
		if !hasStarted {
			hasStarted = true
			// Call sync version
			page.viewModel.onStart()
			// Call async version
			Task { @MainActor in
				await page.viewModel.onStart()
			}
		} else {
			// Call sync version
			page.viewModel.onResume()
			// Call async version
			Task { @MainActor in
				await page.viewModel.onResume()
			}
		}
	}

	/// Called when the slot's view disappears.
	///
	/// Calls `onPause()` to allow the ViewModel to pause any ongoing work.
	public func handleDisappear() {
		// Call sync version
		page.viewModel.onPause()
		// Call async version
		Task { @MainActor in
			await page.viewModel.onPause()
		}
	}

	deinit {
		// onEnd cannot be async, call sync version only
		// Note: This runs on deallocation, which happens when the Page
		// is removed from the container or the container is dismissed.
		MainActor.assumeIsolated {
			page.viewModel.onEnd()
		}
	}
}
