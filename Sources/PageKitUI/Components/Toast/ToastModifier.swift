//
//  ToastModifier.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

// MARK: - Toast Environment Key

private struct ToastManagerEnvironmentKey: EnvironmentKey {
	static let defaultValue: ToastManager? = nil
}

extension EnvironmentValues {
	/// Access to the toast manager via environment
	public var toastManager: ToastManager? {
		get { self[ToastManagerEnvironmentKey.self] }
		set { self[ToastManagerEnvironmentKey.self] = newValue }
	}
}

// MARK: - Toastable Modifier

/// Modifier that installs the toast system on a view hierarchy
private struct ToastableModifier: ViewModifier {
	@State private var toastManager = ToastManager()

	func body(content: Content) -> some View {
		content
			.environment(\.toastManager, toastManager)
			.overlay(alignment: .top) {
				ToastOverlayView(manager: toastManager)
					.padding(.top, topPadding)
			}
			.onAppear {
				Toast.register(toastManager)
			}
	}

	/// Padding from the top to account for safe area
	private var topPadding: CGFloat {
		8
	}
}

// MARK: - View Extension

extension View {
	/// Enables toast notifications for this view hierarchy
	///
	/// Apply this modifier to your root view to enable the static `Toast.show()` API:
	///
	/// ```swift
	/// @main
	/// struct MyApp: App {
	///     var body: some Scene {
	///         WindowGroup {
	///             ContentView()
	///                 .toastable()
	///         }
	///     }
	/// }
	/// ```
	///
	/// Then use the static Toast API anywhere in your app:
	/// ```swift
	/// Toast.show(success: "Saved!")
	/// Toast.show(error: "Failed to save")
	/// ```
	public func toastable() -> some View {
		modifier(ToastableModifier())
	}
}
