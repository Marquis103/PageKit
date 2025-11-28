//
//  LoginViewModel.swift
//
//  Copyright © 2025 PageKit. All rights reserved.
//

import PageKit
import PageKitForms

@MainActor
final class LoginViewModel: FormViewModel<LoginForm> {
	override func onStart() async { }

	override func handle(event: LoginContent.Event) async { }
	override func submit() async throws {
		// Implement form submission
	}
}