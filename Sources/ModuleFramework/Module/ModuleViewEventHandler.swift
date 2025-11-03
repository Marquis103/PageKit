//
//  ModuleViewEventHandler.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation

// MARK: - ModuleViewEventHandlable

protocol ModuleViewEventHandlable {
	associatedtype Event = Void

	func handle(event: Event)
}

// MARK: - ModuleViewEventHandler

struct ModuleViewEventHandler<Event>: ModuleViewEventHandlable {
	private let _handle: (Event) -> Void
	private let _onRefresh: (() async -> Void)?

	init<H: ModuleViewEventHandlable>(_ handler: H) where H.Event == Event {
		_handle = handler.handle(event:)
		_onRefresh = (handler as? Refreshable)?.onRefresh
	}

	func handle(event: Event) {
		_handle(event)
	}
}

// MARK: - Public Interface

extension ModuleViewEventHandler {
	/// Provides onRefresh functionality when the underlying ViewModel conforms to Refreshable
	var onRefresh: (() async -> Void)? {
		_onRefresh
	}
}
