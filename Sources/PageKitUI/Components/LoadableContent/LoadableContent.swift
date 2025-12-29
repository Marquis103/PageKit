//
//  LoadableContent.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI
import PageKitTheming

/// A container view that manages loading, loaded, empty, error, and disabled states
///
/// LoadableContent wraps your content and applies the appropriate overlay based on state.
/// Unlike a ViewModifier, this wrapper view uses `@Binding` for proper state observation.
///
/// **Key Behaviors:**
/// - `.idle`, `.loading` → Content hidden, spinner shown (initial load)
/// - `.loaded(Content)` → Content visible
/// - `.empty` → Content hidden, empty state shown
/// - `.failed(Error)` → Content hidden, error state shown
/// - `.disabled` → Content visible but dimmed with overlay spinner (form submission)
///
/// Basic usage:
/// ```swift
/// var body: some View {
///     MyFormContent()
///         .loadable($viewState.loadingState)
/// }
/// ```
public struct LoadableContent<StateContent, Failure: Error, Content: View>: View {
	@Binding var state: LoadingState<StateContent, Failure>
	let content: Content
	let onRetry: (() async -> Void)?

	@State private var animatedState: LoadingState<StateContent, Failure>

	@Environment(\.optionalTheme)
	private var theme: AnyTheme?

	public init(
		state: Binding<LoadingState<StateContent, Failure>>,
		onRetry: (() async -> Void)? = nil,
		@ViewBuilder content: () -> Content
	) {
		_state = state
		_animatedState = State(initialValue: state.wrappedValue)
		self.content = content()
		self.onRetry = onRetry
	}

	// MARK: - State Properties

	private var isDisabled: Bool {
		if case .disabled = animatedState { return true }
		return false
	}

	private var isLoading: Bool {
		switch animatedState {
		case .idle, .loading: return true
		default: return false
		}
	}

	private var isEmpty: Bool {
		if case .empty = animatedState { return true }
		return false
	}

	private var isFailed: Bool {
		if case .failed = animatedState { return true }
		return false
	}

	/// Key for animation - changes when state case changes
	private var stateKey: Int {
		switch state {
		case .idle: return 0
		case .loading: return 1
		case .loaded: return 2
		case .empty: return 3
		case .failed: return 4
		case .disabled: return 5
		}
	}

	// MARK: - Body

	public var body: some View {
		content
			// Disabled state: show content dimmed with spinner overlay
			.if(isDisabled) { view in
				view
					.disabled(true)
					.overlay {
						ZStack {
							Color.black.opacity(0.5)
								.ignoresSafeArea()
							ProgressView()
								.tint(.white)
								.scaleEffect(1.5)
						}
					}
			}
			// Loading state: hide content, show spinner
			.if(isLoading) { view in
				view
					.hidden()
					.overlay {
						DefaultLoadingStateView()
					}
			}
			// Empty state: hide content, show empty view
			.if(isEmpty) { view in
				view
					.hidden()
					.overlay {
						DefaultEmptyStateView { await onRetry?() }
					}
			}
			// Failed state: hide content, show error view
			.if(isFailed) { view in
				view
					.hidden()
					.overlay {
						if case .failed(let error) = animatedState {
							DefaultErrorStateView(error: error) { await onRetry?() }
						}
					}
			}
			.onChange(of: stateKey) { _, _ in
				withAnimation(.easeInOut(duration: 0.2)) {
					animatedState = state
				}
			}
	}
}

// MARK: - View Extension

extension View {
	/// Apply loadable state handling to any view
	///
	/// This modifier wraps your view and applies the appropriate overlay based on state.
	/// Uses a `Binding` for proper state observation and transitions.
	///
	/// - Parameters:
	///   - state: Binding to the current loading state
	///   - onRetry: Optional async closure called when retry is triggered
	/// - Returns: A view that responds to loading state changes
	///
	/// **Usage:**
	/// ```swift
	/// var body: some View {
	///     LoginForm(...)
	///         .loadable($viewState.loadingState)
	/// }
	/// ```
	public func loadable<StateContent, Failure: Error>(
		_ state: Binding<LoadingState<StateContent, Failure>>,
		onRetry: (() async -> Void)? = nil
	) -> some View {
		LoadableContent(state: state, onRetry: onRetry) {
			self
		}
	}
}

// MARK: - Default Loading View

/// Default view displayed during loading state
public struct DefaultLoadingStateView: View {
	public init() {}

	public var body: some View {
		ProgressView()
			.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}

// MARK: - Default Empty View

/// Default view displayed when content is empty
public struct DefaultEmptyStateView: View {
	let onRetry: () async -> Void

	@Environment(\.optionalTheme)
	private var theme: AnyTheme?

	public init(onRetry: @escaping () async -> Void) {
		self.onRetry = onRetry
	}

	public var body: some View {
		VStack(spacing: theme?.spacing.medium ?? 16) {
			Image(systemName: "tray")
				.font(.system(size: 48))
				.foregroundStyle(.secondary)

			Text("No Content")
				.font(.headline)
				.foregroundStyle(.secondary)

			Button("Retry") {
				Task { await onRetry() }
			}
			.buttonStyle(.bordered)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}

// MARK: - Default Error View

/// Default view displayed when loading fails
public struct DefaultErrorStateView: View {
	let error: Error
	let onRetry: () async -> Void

	@Environment(\.optionalTheme)
	private var theme: AnyTheme?

	public init(error: Error, onRetry: @escaping () async -> Void) {
		self.error = error
		self.onRetry = onRetry
	}

	public var body: some View {
		VStack(spacing: theme?.spacing.medium ?? 16) {
			Image(systemName: "exclamationmark.triangle")
				.font(.system(size: 48))
				.foregroundStyle(theme?.colors.destructive ?? .red)

			Text("Something went wrong")
				.font(.headline)

			Text(error.localizedDescription)
				.font(.caption)
				.foregroundStyle(.secondary)
				.multilineTextAlignment(.center)
				.padding(.horizontal)

			Button("Try Again") {
				Task { await onRetry() }
			}
			.buttonStyle(.bordered)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}
