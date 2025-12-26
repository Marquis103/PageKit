//
//  FormViewEventHandler.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation
import PageKit

#if canImport(UIKit)
import UIKit
#endif

// MARK: - FormViewEventHandlable

/// Protocol for form-specific event handlers.
///
/// Extends PageEventHandlable with form submission capabilities.
/// ViewModels that handle forms should conform to this protocol.
///
/// Example:
/// ```swift
/// final class LoginViewModel: FormViewModel<LoginPage>, FormViewEventHandlable {
///     func validateAndSubmit() {
///         viewState.validateAllFields()
///         guard viewState.validated else { return }
///         Task { await handleSubmit() }
///     }
/// }
/// ```
public protocol FormViewEventHandlable: PageEventHandlable {
	/// Validates all form fields and submits if valid.
	func validateAndSubmit()
}

// MARK: - FormViewEventHandler

/// Type-erased wrapper for form event handlers.
///
/// Provides the same functionality as PageEventHandler with additional
/// form-specific methods like `validateAndSubmit()`.
public struct FormViewEventHandler<Event> {
	private let _handle: (Event) async -> Void
	private let _onRefresh: (() async -> Void)?
	private let _validateAndSubmit: () -> Void

	public init<H: FormViewEventHandlable>(_ handler: H) where H.Event == Event {
		_handle = handler.handle(event:)
		_onRefresh = (handler as? Refreshable)?.onRefresh
		_validateAndSubmit = handler.validateAndSubmit
	}

	public func handle(event: Event) async {
		await _handle(event)
	}

	/// Validates all form fields and submits if valid.
	///
	/// This method:
	/// 1. Dismisses the keyboard (resignFirstResponder)
	/// 2. Calls the underlying ViewModel's validateAndSubmit()
	public func validateAndSubmit() {
		resignFirstResponder()
		_validateAndSubmit()
	}

	// MARK: - Private Helpers

	/// Dismisses the keyboard by resigning the first responder.
	private func resignFirstResponder() {
		#if canImport(UIKit)
		DispatchQueue.main.async {
			UIApplication.shared.sendAction(
				#selector(UIResponder.resignFirstResponder),
				to: nil,
				from: nil,
				for: nil
			)
		}
		#endif
	}
}

// MARK: - Public Interface

extension FormViewEventHandler {
	/// Provides onRefresh functionality when the underlying ViewModel conforms to Refreshable
	public var onRefresh: (() async -> Void)? {
		_onRefresh
	}

	/// Convenience method for sending events from synchronous contexts (like SwiftUI views).
	/// Wraps the async handle call in a Task.
	@MainActor
	public func send(_ event: Event) {
		Task { @MainActor in
			await handle(event: event)
		}
	}
}
