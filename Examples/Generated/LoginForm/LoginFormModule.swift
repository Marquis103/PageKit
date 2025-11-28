//
//  LoginFormModule.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI
import ModuleFramework

final class LoginFormModule: FormModule {
    enum Action: CoordinatableAction {
        // Define actions that can be sent to the coordinator
        // Example: case didComplete, case showDetail(String)
    }

    enum Signal: ModuleSignal {
        // Define signals that can be published (optional)
        // Example: case dataUpdated, case errorOccurred(Error)
    }

    let coordinator: Coordinating
    let viewState: LoginFormViewState

    // Additional dependencies (add as needed)
    // Example: let apiService: APIService

    lazy var viewModel: LoginFormViewModel = .init(
        coordinator: self.coordinator,
        viewState: self.viewState
        // Pass additional dependencies here
        // apiService: self.apiService
    )

    lazy var view: LoginFormView = .init(
        viewState: self.viewState,
        handler: FormViewEventHandler(viewModel)
    )

    init(coordinator: Coordinating /* add dependencies here if needed */) {
        self.coordinator = coordinator
        self.viewState = .init()

        // Store additional dependencies
        // self.apiService = apiService
    }
}