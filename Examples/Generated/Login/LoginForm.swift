//
//  LoginForm.swift
//
//  Copyright © 2025 PageKit. All rights reserved.
//

import PageKit
import PageKitForms

final class LoginForm: FormPage {
	enum Action: CoordinatableAction {
		// Define navigation actions
	}

	let coordinator: Coordinating
	let viewState: LoginViewState
	let viewModel: LoginViewModel
	let view: LoginFormView

	init(coordinator: Coordinating) {
		self.coordinator = coordinator
		self.viewState = LoginViewState()
		self.viewModel = LoginViewModel(coordinator: coordinator, viewState: viewState)
		self.view = LoginFormView(viewState: viewState, handler: FormEventHandler(viewModel))
	}
}