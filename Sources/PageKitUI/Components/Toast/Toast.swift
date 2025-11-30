//
//  Toast.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation

/// Static API for showing toast notifications
///
/// Toast provides a simple static interface for showing notifications from anywhere
/// in your app, including ViewModels where @Environment is not available.
///
/// Setup (at app root):
/// ```swift
/// ContentView()
///     .toastable()
/// ```
///
/// Usage (anywhere):
/// ```swift
/// // In ViewModel
/// func save() async {
///     do {
///         try await api.save()
///         Toast.show(success: "Saved!")
///     } catch {
///         Toast.show(error: error.localizedDescription)
///     }
/// }
///
/// // In View
/// Button("Copy") {
///     UIPasteboard.general.string = text
///     Toast.show(info: "Copied to clipboard")
/// }
/// ```
public enum Toast {
	/// Shared toast manager - registered by .toastable() modifier
	@MainActor
	private static var sharedManager: ToastManager?

	/// Registers the toast manager (called by .toastable() modifier)
	@MainActor
	internal static func register(_ manager: ToastManager) {
		sharedManager = manager
	}

	// MARK: - Static API

	/// Shows a success toast
	/// - Parameters:
	///   - message: The success message
	///   - duration: Optional custom duration
	@MainActor
	public static func show(success message: String, duration: TimeInterval? = nil) {
		sharedManager?.success(message, duration: duration)
	}

	/// Shows an error toast
	/// - Parameters:
	///   - message: The error message
	///   - duration: Optional custom duration
	@MainActor
	public static func show(error message: String, duration: TimeInterval? = nil) {
		sharedManager?.error(message, duration: duration)
	}

	/// Shows an info toast
	/// - Parameters:
	///   - message: The info message
	///   - duration: Optional custom duration
	@MainActor
	public static func show(info message: String, duration: TimeInterval? = nil) {
		sharedManager?.info(message, duration: duration)
	}

	/// Shows a warning toast
	/// - Parameters:
	///   - message: The warning message
	///   - duration: Optional custom duration
	@MainActor
	public static func show(warning message: String, duration: TimeInterval? = nil) {
		sharedManager?.warning(message, duration: duration)
	}

	/// Shows a custom toast message
	/// - Parameter toast: The toast message to show
	@MainActor
	public static func show(_ toast: ToastMessage) {
		sharedManager?.show(toast)
	}

	/// Dismisses the current toast
	@MainActor
	public static func dismiss() {
		sharedManager?.dismiss()
	}

	/// Dismisses all toasts and clears the queue
	@MainActor
	public static func dismissAll() {
		sharedManager?.dismissAll()
	}
}
