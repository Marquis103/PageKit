//
//  FormPage.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
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
/// final class LoginFormPage: FormPage {
///     enum Action: CoordinatableAction {
///         case loginSuccess
///         case showSignup
///     }
///
///     let coordinator: Coordinating
///     let viewState: LoginFormViewState
///
///     lazy var viewModel: LoginFormViewModel = .init(
///         coordinator: coordinator,
///         viewState: viewState
///     )
///
///     lazy var content: LoginFormContent = .init(
///         viewState: viewState,
///         handler: FormContentEventHandler(viewModel)
///     )
///
///     init(coordinator: Coordinating) {
///         self.coordinator = coordinator
///         self.viewState = .init()
///     }
/// }
/// ```
public protocol FormPage: Page where ViewState: FormViewState, ViewModel: FormViewModel<Self> {
	// Inherits all Page requirements with FormViewState constraint
}

// MARK: - FormContent

/// Protocol for form-based content views.
///
/// FormContent is a specialization of PageContent that works with FormViewState.
public protocol FormContent: PageContent where State: FormViewState {
	// Inherits all PageContent requirements with FormViewState constraint
}

// MARK: - FormContentEventHandler

/// Event handler for form content views.
///
/// This is a convenience wrapper around FormViewModel that allows
/// views to send events to the view model.
public struct FormContentEventHandler<Event> {
	private let handler: (Event) -> Void

	public init<VM: FormViewModel<P>, P: Page>(_ viewModel: VM) where P.ViewState: FormViewState {
		self.handler = { event in
			// Cast event to the expected type
			if let typedEvent = event as? P.Content.Event {
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
