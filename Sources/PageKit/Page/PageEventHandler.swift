//
//  PageEventHandler.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation

// MARK: - PageEventHandlable

public protocol PageEventHandlable {
	associatedtype Event = Void

	func handle(event: Event)
}

// MARK: - PageEventHandler

public struct PageEventHandler<Event>: PageEventHandlable {
	private let _handle: (Event) -> Void
	private let _onRefresh: (() async -> Void)?

	public init<H: PageEventHandlable>(_ handler: H) where H.Event == Event {
		_handle = handler.handle(event:)
		_onRefresh = (handler as? Refreshable)?.onRefresh
	}

	public func handle(event: Event) {
		_handle(event)
	}
}

// MARK: - Public Interface

extension PageEventHandler {
	/// Provides onRefresh functionality when the underlying ViewModel conforms to Refreshable
	public var onRefresh: (() async -> Void)? {
		_onRefresh
	}
}
