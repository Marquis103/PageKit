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
	let content: LoginContent

	init(coordinator: Coordinating) {
		self.coordinator = coordinator
		self.viewState = LoginViewState()
		self.viewModel = LoginViewModel(coordinator: coordinator, viewState: viewState)
		self.content = LoginContent(viewState: viewState, handler: FormEventHandler(viewModel))
	}
}