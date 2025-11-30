//
//  Toast.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import UIKit
import SwiftUI

/// Static API for showing toast notifications
///
/// Toast provides a simple static interface for showing notifications from anywhere
/// in your app, including ViewModels where @Environment is not available.
///
/// No setup required - just call it anywhere:
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
	/// The toast window - created lazily on first use
	@MainActor
	private static var window: ToastWindow?

	/// The toast manager - created lazily on first use
	@MainActor
	private static var manager: ToastManager?

	/// Lazily initializes the toast system on first use
	@MainActor
	private static func ensureInitialized() {
		guard window == nil else { return }

		let manager = ToastManager()
		self.manager = manager

		// Get the active window scene
		guard let windowScene = UIApplication.shared.connectedScenes
			.compactMap({ $0 as? UIWindowScene })
			.first(where: { $0.activationState == .foregroundActive })
			?? UIApplication.shared.connectedScenes
			.compactMap({ $0 as? UIWindowScene })
			.first
		else {
			return
		}

		// Create a passthrough window above all content
		let window = ToastWindow(windowScene: windowScene)
		window.windowLevel = .alert + 1
		window.backgroundColor = .clear
		window.isUserInteractionEnabled = true

		let hostingController = UIHostingController(
			rootView: ToastOverlayView(manager: manager)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		)
		hostingController.view.backgroundColor = .clear
		window.rootViewController = hostingController

		window.isHidden = false
		self.window = window
	}

	// MARK: - Static API

	/// Shows a success toast
	/// - Parameters:
	///   - message: The success message
	///   - duration: Optional custom duration
	@MainActor
	public static func show(success message: String, duration: TimeInterval? = nil) {
		ensureInitialized()
		manager?.success(message, duration: duration)
	}

	/// Shows an error toast
	/// - Parameters:
	///   - message: The error message
	///   - duration: Optional custom duration
	@MainActor
	public static func show(error message: String, duration: TimeInterval? = nil) {
		ensureInitialized()
		manager?.error(message, duration: duration)
	}

	/// Shows an info toast
	/// - Parameters:
	///   - message: The info message
	///   - duration: Optional custom duration
	@MainActor
	public static func show(info message: String, duration: TimeInterval? = nil) {
		ensureInitialized()
		manager?.info(message, duration: duration)
	}

	/// Shows a warning toast
	/// - Parameters:
	///   - message: The warning message
	///   - duration: Optional custom duration
	@MainActor
	public static func show(warning message: String, duration: TimeInterval? = nil) {
		ensureInitialized()
		manager?.warning(message, duration: duration)
	}

	/// Shows a custom toast message
	/// - Parameter toast: The toast message to show
	@MainActor
	public static func show(_ toast: ToastMessage) {
		ensureInitialized()
		manager?.show(toast)
	}

	/// Dismisses the current toast
	@MainActor
	public static func dismiss() {
		manager?.dismiss()
	}

	/// Dismisses all toasts and clears the queue
	@MainActor
	public static func dismissAll() {
		manager?.dismissAll()
	}
}

// MARK: - ToastWindow

/// Custom UIWindow that passes through touches except on the toast view itself
private class ToastWindow: UIWindow {
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		guard let hitView = super.hitTest(point, with: event) else {
			return nil
		}

		// Pass through touches unless they're on a view that handles them
		// The hosting controller's root view will be clear, so we check if
		// the hit view is something other than the root hosting view
		if hitView === rootViewController?.view {
			return nil
		}

		return hitView
	}
}
