//
//  ModuleViewModel.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Combine

// MARK: - ModuleViewModelable

protocol ModuleViewModelable {
	associatedtype Mod: Module

	var viewState: Mod.ViewState { get }
}

// MARK: - ModuleViewModel

class ModuleViewModel<Mod: Module>: ModuleViewModelable, ModuleViewEventHandlable {
	private let coordinator: Coordinating
	private var signalCancellables: Set<AnyCancellable> = []

	let viewState: Mod.ViewState

	init(coordinator: Coordinating, viewState: Mod.ViewState) {
		self.coordinator = coordinator
		self.viewState = viewState

		subscribeToSignals(coordinator)
	}

	func onStart() async {
		// Override
	}

	func onResume() async {
		// Override
	}

	func onPause() async {
		// Override
	}

	// onEnd cannot be async
	func onEnd() {
		// Override
	}

	// TODO: Remove this in favor of async function
	func onStart() {
		// Override
	}

	// TODO: Remove this in favor of async function
	func onResume() {
		// Override
	}

	// TODO: Remove this in favor of async function
	func onPause() {
		// Override
	}

	// TODO: Make this async
	func handle(event _: Mod.View.Event) {
		// Override
	}

	// TODO: Make this async
	func handle(signal _: Mod.Signal) {
		// Override
	}

	final func coordinate(action: Mod.Action) {
		coordinator.coordinate(action: action)
	}

	// Note: showConfirmation method removed - implement confirmation dialogs in your app using UIAlertController

	private func subscribeToSignals(_ publisher: some ModuleSignalPublisher) {
		publisher.signalPublisher
			.sink { [weak self] signal in
				if let signal = signal as? Mod.Signal {
					self?.handle(signal: signal)
				}
			}
			.store(in: &signalCancellables)
	}
}
