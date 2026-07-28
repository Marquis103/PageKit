//
//  PageViewModel.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

// MARK: - PageViewModelProtocol

public protocol PageViewModelProtocol {
	associatedtype P: Page

	var viewState: P.ViewState { get }
}

// MARK: - PageViewModel

@MainActor
open class PageViewModel<P: Page>: PageViewModelProtocol, PageEventHandlable {
	private let coordinator: Coordinating

	/// Iterates the coordinator's signal stream for this page's lifetime.
	/// Since 2.0.0 (PE-533) signals arrive via `AsyncStream`, not Combine —
	/// the task ends when the stream finishes or the model deallocates
	/// (`[weak self]` + explicit cancel in `deinit`).
	private var signalTask: Task<Void, Never>?

	public let viewState: P.ViewState

	public init(coordinator: Coordinating, viewState: P.ViewState) {
		self.coordinator = coordinator
		self.viewState = viewState

		subscribeToSignals(coordinator)
	}

	deinit {
		signalTask?.cancel()
	}

	// MARK: - Lifecycle (Sync)

	/// Called synchronously when the page starts. Use for immediate UI updates.
	/// Data loading should spawn its own Task to avoid blocking the main actor.
	open func onStartSync() {
		// Override
	}

	/// Called synchronously when the page resumes. Use for immediate UI updates.
	open func onResumeSync() {
		// Override
	}

	/// Called synchronously when the page pauses. Use for immediate cleanup.
	open func onPauseSync() {
		// Override
	}

	// MARK: - Lifecycle (Async)

	/// Called after `onStartSync()`. Can be used for awaited operations.
	/// Note: Awaiting here blocks other @MainActor tasks. Prefer spawning
	/// independent Tasks in `onStartSync()` for non-blocking behavior.
	open func onStart() async {
		// Override
	}

	/// Called after `onResumeSync()`. Can be used for awaited operations.
	open func onResume() async {
		// Override
	}

	/// Called after `onPauseSync()`. Can be used for awaited operations.
	open func onPause() async {
		// Override
	}

	/// Called when the page is being deallocated.
	/// Must be nonisolated because it's called from deinit.
	nonisolated open func onEnd() {
		// Override
	}

	// MARK: - Event Handling

	open func handle(event _: P.View.Event) async {
		// Override
	}

	open func handle(signal _: P.Signal) async {
		// Override
	}

	// MARK: - Coordination

	public final func coordinate(action: P.Action) {
		coordinator.coordinate(action: action)
	}

	// MARK: - Signal Subscription

	private func subscribeToSignals(_ publisher: some PageSignalPublisher) {
		let stream = publisher.signals()
		signalTask = Task { @MainActor [weak self] in
			for await signal in stream {
				guard self != nil else { return }
				if let signal = signal as? P.Signal {
					await self?.handle(signal: signal)
				}
			}
		}
	}
}
