//
//  FormModule.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation

/// Protocol for form-based modules.
///
/// FormModule is a specialization of Module that requires FormViewState
/// and provides form-specific functionality.
///
/// Example:
/// ```swift
/// final class LoginFormModule: FormModule {
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
///     lazy var view: LoginFormView = .init(
///         viewState: viewState,
///         handler: FormViewEventHandler(viewModel)
///     )
///
///     init(coordinator: Coordinating) {
///         self.coordinator = coordinator
///         self.viewState = .init()
///     }
/// }
/// ```
protocol FormModule: Module where ViewState: FormViewState, ViewModel: FormViewModel<Self> {
	// Inherits all Module requirements with FormViewState constraint
}

// MARK: - FormView

/// Protocol for form-based views.
///
/// FormView is a specialization of ModuleView that works with FormViewState.
protocol FormView: ModuleView where State: FormViewState {
	// Inherits all ModuleView requirements with FormViewState constraint
}

// MARK: - FormViewEventHandler

/// Event handler for form views.
///
/// This is a convenience wrapper around FormViewModel that allows
/// views to send events to the view model.
struct FormViewEventHandler<Event> {
	private let handler: (Event) -> Void

	init<VM: FormViewModel<Mod>, Mod: Module>(_ viewModel: VM) where Mod.ViewState: FormViewState {
		self.handler = { event in
			// Cast event to the expected type
			if let typedEvent = event as? Mod.View.Event {
				viewModel.handle(event: typedEvent)
			}
		}
	}

	func send(_ event: Event) {
		handler(event)
	}

	func callAsFunction(_ event: Event) {
		handler(event)
	}
}
