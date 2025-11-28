//
//  LoginFormView.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI
import ModuleFramework

struct LoginFormView: FormView {
    enum Event {
        // Define view events here if needed
        // Example: case buttonTapped, case itemSelected(String)
    }

    @StateObject
    var viewState: LoginFormViewState

    var handler: FormViewEventHandler<Event>

    // Additional properties go here

    var body: some View {
        // Build your view here
        Form {
            FormSection("Section Title") {
                // Add form fields here
                // Example:
                // FormField("Email", text: $viewState.email, validators: [.required, .email])
                // FormField("Password", text: $viewState.password, isSecure: true, validators: [.required, .minLength(6)])
            }

            FormSection {
                FormSubmitButton("Submit") {
                    await viewModel.handleSubmit()
                }
                .environmentObject(viewState)
            }

            FormErrorView()
                .environmentObject(viewState)
        }
        .navigationTitle("LoginForm")
    }
}

// MARK: - Preview

#if DEBUG
struct LoginFormView_Previews: PreviewProvider {
    static var previews: some View {
        LoginFormView(
            viewState: LoginFormViewState(),
            handler: FormViewEventHandler { _ in }
        )
    }
}
#endif