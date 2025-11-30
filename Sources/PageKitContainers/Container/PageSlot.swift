//
//  PageSlot.swift
//
//  Copyright © 2025 PageKit. All rights reserved.
//

import PageKit
import SwiftUI

// MARK: - PageSlot

/// A SwiftUI view that hosts a Page within a container slot.
///
/// `PageSlot` wraps a Page's view and manages its lifecycle automatically.
/// When the slot appears, the Page's `onStart()` or `onResume()` is called.
/// When it disappears, `onPause()` is called. When the slot is deallocated,
/// `onEnd()` is called.
///
/// ```swift
/// // In a ContainerLayout body:
/// NavigationSplitView {
///     PageSlot(page: sidebarPage)
/// } detail: {
///     PageSlot(page: detailPage)
/// }
/// ```
///
/// Pages hosted in a `PageSlot` work identically to pages hosted in a
/// `PageHostController` - they receive the same lifecycle callbacks and
/// can communicate via the shared coordinator's signal system.
public struct PageSlot<P: Page>: View {
	private let page: P
	@StateObject private var lifecycleManager: PageSlotLifecycle<P>

	/// Creates a slot hosting the given Page.
	/// - Parameter page: The Page to host in this slot.
	public init(page: P) {
		self.page = page
		_lifecycleManager = StateObject(wrappedValue: PageSlotLifecycle(page: page))
	}

	public var body: some View {
		page.view
			.onAppear {
				lifecycleManager.handleAppear()
			}
			.onDisappear {
				lifecycleManager.handleDisappear()
			}
	}
}

// MARK: - AnyPageSlot

/// Type-erased wrapper for PageSlot to allow storing heterogeneous Pages.
///
/// Used internally by `PageContainer` to store Pages of different types
/// in a single dictionary.
@MainActor
public struct AnyPageSlot: View {
	private let makeBody: () -> AnyView

	/// Creates a type-erased page slot from a concrete Page.
	/// - Parameter page: The Page to wrap.
	public init<P: Page>(page: P) {
		self.makeBody = {
			AnyView(PageSlot(page: page))
		}
	}

	public var body: some View {
		makeBody()
	}
}
