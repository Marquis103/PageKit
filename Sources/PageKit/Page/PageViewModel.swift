//
//  PageViewModel.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Combine

// MARK: - PageViewModelProtocol

public protocol PageViewModelProtocol {
	associatedtype P: Page

	var viewState: P.ViewState { get }
}

// MARK: - PageViewModel

open class PageViewModel<P: Page>: PageViewModelProtocol, PageEventHandlable {
	private let coordinator: Coordinating
	private var signalCancellables: Set<AnyCancellable> = []

	public let viewState: P.ViewState

	public init(coordinator: Coordinating, viewState: P.ViewState) {
		self.coordinator = coordinator
		self.viewState = viewState

		subscribeToSignals(coordinator)
	}

	open func onStart() async {
		// Override
	}

	open func onResume() async {
		// Override
	}

	open func onPause() async {
		// Override
	}

	// onEnd cannot be async
	open func onEnd() {
		// Override
	}

	// TODO: Remove this in favor of async function
	open func onStart() {
		// Override
	}

	// TODO: Remove this in favor of async function
	open func onResume() {
		// Override
	}

	// TODO: Remove this in favor of async function
	open func onPause() {
		// Override
	}

	// TODO: Make this async
	open func handle(event _: P.Content.Event) {
		// Override
	}

	// TODO: Make this async
	open func handle(signal _: P.Signal) {
		// Override
	}

	public final func coordinate(action: P.Action) {
		coordinator.coordinate(action: action)
	}

	private func subscribeToSignals(_ publisher: some PageSignalPublisher) {
		publisher.signalPublisher
			.sink { [weak self] signal in
				if let signal = signal as? P.Signal {
					self?.handle(signal: signal)
				}
			}
			.store(in: &signalCancellables)
	}
}
