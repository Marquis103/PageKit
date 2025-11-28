//
//  LoginFormViewState.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI
import ModuleFramework

class LoginFormViewState: FormViewState {
    // Add @Published properties here
    // Example:
    // @Published var title: String = ""
    // @Published var isLoading: Bool = false
    override func validate() -> Bool {
        // Add your validation logic here
        // Example:
        // validateField("email", value: email, validators: [.required, .email])
        // validateField("password", value: password, validators: [.required, .minLength(6)])
        return isValid
    }
}