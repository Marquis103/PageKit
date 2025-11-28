//
//  SettingsViewModel.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI
import ModuleFramework

@MainActor
class SettingsViewModel: ModuleViewModel<SettingsModule> {
    // CRITICAL: Use weak reference to avoid retain cycle
    // The coordinator reference is inherited from the base class

    // Add properties here
    // Example: let apiService: APIService

    nonisolated init(
        coordinator: Coordinating,
        viewState: SettingsViewState
        // Add dependencies here if needed
        // apiService: APIService
    ) {
        // Store dependencies before calling super.init
        // self.apiService = apiService

        super.init(coordinator: coordinator, viewState: viewState)
    }

    override func onStart() async {
        // Async startup logic goes here
        // No need for Task { @MainActor in } - we're already on MainActor
        // Example:
        // await loadInitialData()
    }

    override func onResume() async {
        // Async resume logic goes here
        // Example:
        // await refreshData()
    }

    override func handle(event _: SettingsView.Event) {
        // View event handling logic goes here
        // This method is already on MainActor
        // Example:
        // switch event {
        // case .buttonTapped:
        //     coordinator.send(action: .showNext)
        // }
    }

    // Private helper methods
    // private func loadInitialData() async {
    //     // API calls automatically run on background thread
    //     // Results automatically return to MainActor
    // }
}