//
//  SettingsPage.swift
//
//  Copyright © 2025 PageKit. All rights reserved.
//

import PageKit

final class SettingsPage: Page {
	enum Action: CoordinatableAction {
		// Define navigation actions
	}

	let coordinator: Coordinating
	let viewState: SettingsViewState
	let viewModel: SettingsViewModel
	let view: SettingsView

	init(coordinator: Coordinating) {
		self.coordinator = coordinator
		self.viewState = SettingsViewState()
		self.viewModel = SettingsViewModel(coordinator: coordinator, viewState: viewState)
		self.view = SettingsView(viewState: viewState, handler: PageEventHandler(viewModel))
	}
}