//
//  FormPage.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation
import PageKit

/// Protocol for form-based pages.
///
/// FormPage is a specialization of Page that requires FormViewState
/// and provides form-specific functionality.
///
/// Example:
/// ```swift
/// final class LoginForm: FormPage {
///     enum Action: CoordinatableAction {
///         case loginSuccess
///         case showSignup
///     }
///
///     let coordinator: Coordinating
///     let viewState: LoginViewState
///     let viewModel: LoginViewModel
///     let view: LoginFormView
///
///     init(coordinator: Coordinating) {
///         self.coordinator = coordinator
///         self.viewState = LoginViewState()
///         self.viewModel = LoginViewModel(coordinator: coordinator, viewState: viewState)
///         self.view = LoginFormView(viewState: viewState, handler: FormEventHandler(viewModel))
///     }
/// }
/// ```
public protocol FormPage: Page where ViewState: FormViewState, ViewModel: FormViewModel<Self> {
	// Inherits all Page requirements with FormViewState constraint
}

// MARK: - FormView

/// Protocol for form-based content views.
///
/// FormView is a specialization of PageView that works with FormViewState.
public protocol FormView: PageView where State: FormViewState {
	// Inherits all PageView requirements with FormViewState constraint
}

// MARK: - FormEventHandler

/// Event handler for form views.
///
/// This is a convenience wrapper around FormViewModel that allows
/// views to send events to the view model.
public struct FormEventHandler<Event> {
	private let handler: (Event) -> Void

	public init<VM: FormViewModel<P>, P: Page>(_ viewModel: VM) where P.ViewState: FormViewState {
		self.handler = { event in
			// Cast event to the expected type
			if let typedEvent = event as? P.View.Event {
				viewModel.handle(event: typedEvent)
			}
		}
	}

	public func send(_ event: Event) {
		handler(event)
	}

	public func callAsFunction(_ event: Event) {
		handler(event)
	}
}
