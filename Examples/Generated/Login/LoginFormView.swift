//
//  LoginFormView.swift
//
//  Copyright © 2025 PageKit. All rights reserved.
//

import SwiftUI
import PageKit
import PageKitForms

struct LoginFormView: FormView {
	enum Event { }

	@ObservedObject var viewState: LoginViewState
	let handler: FormEventHandler<Event>

	var body: some View {
		Form {
			// Add form fields here
		}
	}
}