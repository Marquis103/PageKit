//
//  PageSignalPublisher.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation

// MARK: - PageSignalPublisher

/// Something pages can subscribe to for cross-page signals.
///
/// Since 2.0.0 (PE-533) the signal surface is an `AsyncStream` rather than a
/// Combine publisher, so the portable core carries no Combine dependency.
/// Each call to `signals()` returns an independent stream — every subscriber
/// sees every signal sent after it subscribes (multicast semantics, provided
/// by `PageSignalBus`).
public protocol PageSignalPublisher {
	/// A fresh, independent stream of signals for one subscriber.
	func signals() -> AsyncStream<PageSignal>
}

extension PageSignalPublisher {
	/// Non-publishing conformers vend an immediately-finished stream.
	public func signals() -> AsyncStream<PageSignal> {
		AsyncStream { continuation in
			continuation.finish()
		}
	}
}

// MARK: - PageSignalBus

/// Multicast backing store for `PageSignalPublisher` conformers that actually
/// publish (the `Coordinator` base class, or any custom coordinator).
///
/// Same shape as an AsyncStream event bus: one continuation per subscriber,
/// appended on subscribe, removed on termination; `send` fan-outs to all.
/// MainActor-bound — signals are a UI coordination concern.
@MainActor
public final class PageSignalBus {
	private var continuations: [UUID: AsyncStream<PageSignal>.Continuation] = [:]

	public init() {}

	/// A fresh stream for one subscriber. Signals sent before subscription
	/// are not replayed.
	public func stream() -> AsyncStream<PageSignal> {
		AsyncStream { continuation in
			let id = UUID()
			continuations[id] = continuation
			continuation.onTermination = { [weak self] _ in
				Task { @MainActor [weak self] in
					self?.continuations[id] = nil
				}
			}
		}
	}

	/// Fan the signal out to every live subscriber.
	public func send(_ signal: PageSignal) {
		for continuation in continuations.values {
			continuation.yield(signal)
		}
	}

	/// Finish every subscriber's stream (e.g. on teardown).
	public func finish() {
		for continuation in continuations.values {
			continuation.finish()
		}
		continuations = [:]
	}
}
