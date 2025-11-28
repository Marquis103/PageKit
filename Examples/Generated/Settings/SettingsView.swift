//
//  SettingsView.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI
import ModuleFramework

struct SettingsView: ModuleView {
    enum Event {
        // Define view events here if needed
        // Example: case buttonTapped, case itemSelected(String)
    }

    @StateObject
    var viewState: SettingsViewState

    var handler: ModuleViewEventHandler<Event>

    // Additional properties go here

    var body: some View {
        // Build your view here
        VStack {
            // Add your view content here
            Text("Hello from Settings!")
        }
        .navigationTitle("Settings")
    }
}

// MARK: - Preview

#if DEBUG
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            viewState: SettingsViewState(),
            handler: ModuleViewEventHandler { _ in }
        )
    }
}
#endif