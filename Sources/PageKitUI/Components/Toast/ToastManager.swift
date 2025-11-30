//
//  ToastManager.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

/// Observable manager for toast notifications with queue support
///
/// ToastManager handles displaying toasts one at a time. When a toast is shown
/// while another is already visible, the new toast is queued and shown after
/// the current one is dismissed.
@Observable
@MainActor
public final class ToastManager {
	/// The currently displayed toast, if any
	public private(set) var currentToast: ToastMessage?

	/// Queue of pending toasts
	private var queue: [ToastMessage] = []

	/// Task for auto-dismissal
	private var dismissTask: Task<Void, Never>?

	public init() {}

	// MARK: - Public Methods

	/// Shows a toast message
	///
	/// If a toast is already showing, the new toast is queued and will be
	/// displayed after the current one is dismissed.
	///
	/// - Parameter toast: The toast message to show
	public func show(_ toast: ToastMessage) {
		if currentToast != nil {
			queue.append(toast)
		} else {
			present(toast)
		}
	}

	/// Shows a success toast
	/// - Parameters:
	///   - message: The success message
	///   - duration: Optional custom duration
	public func success(_ message: String, duration: TimeInterval? = nil) {
		show(.success(message, duration: duration))
	}

	/// Shows an error toast
	/// - Parameters:
	///   - message: The error message
	///   - duration: Optional custom duration
	public func error(_ message: String, duration: TimeInterval? = nil) {
		show(.error(message, duration: duration))
	}

	/// Shows an info toast
	/// - Parameters:
	///   - message: The info message
	///   - duration: Optional custom duration
	public func info(_ message: String, duration: TimeInterval? = nil) {
		show(.info(message, duration: duration))
	}

	/// Shows a warning toast
	/// - Parameters:
	///   - message: The warning message
	///   - duration: Optional custom duration
	public func warning(_ message: String, duration: TimeInterval? = nil) {
		show(.warning(message, duration: duration))
	}

	/// Dismisses the current toast
	///
	/// If there are queued toasts, the next one will be shown after a brief delay.
	public func dismiss() {
		dismissTask?.cancel()
		dismissTask = nil

		withAnimation(.easeOut(duration: 0.2)) {
			currentToast = nil
		}

		// Show next toast after animation completes
		Task { @MainActor in
			try? await Task.sleep(nanoseconds: 250_000_000) // 0.25s
			showNextIfNeeded()
		}
	}

	/// Clears all queued toasts (does not dismiss current toast)
	public func clearQueue() {
		queue.removeAll()
	}

	/// Dismisses current toast and clears the queue
	public func dismissAll() {
		clearQueue()
		dismiss()
	}

	// MARK: - Private Methods

	private func present(_ toast: ToastMessage) {
		withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
			currentToast = toast
		}
		scheduleDismissal(after: toast.duration)
	}

	private func scheduleDismissal(after duration: TimeInterval) {
		dismissTask?.cancel()
		dismissTask = Task { @MainActor in
			try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
			guard !Task.isCancelled else { return }
			dismiss()
		}
	}

	private func showNextIfNeeded() {
		guard currentToast == nil, !queue.isEmpty else { return }
		let next = queue.removeFirst()
		present(next)
	}
}
