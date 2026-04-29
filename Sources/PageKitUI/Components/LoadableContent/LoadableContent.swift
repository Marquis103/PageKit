//
//  LoadableContent.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI
import PageKit
import PageKitTheming

/// A container view that manages loading, loaded, empty, error, and disabled states
///
/// LoadableContent wraps your content and applies the appropriate overlay based on state.
/// Accepts a plain value (not Binding) to ensure proper `@Observable` tracking - the caller
/// must READ the property, which establishes observation.
///
/// **Key Behaviors:**
/// - `.idle`, `.loading` → Content hidden, spinner shown (initial load)
/// - `.loaded(Content)` → Content visible
/// - `.empty` → Content hidden, empty state shown
/// - `.failed(Error)` → Content hidden, error state shown
/// - `.disabled` → Content visible but dimmed with overlay spinner (form submission)
///
/// **Customization:**
/// LoadableContent is parameterized over the empty / error view types so callers can
/// inject brand-disciplined views without subclassing or styling-by-environment. The
/// default initializer uses `DefaultEmptyStateView` / `DefaultErrorStateView`. The
/// custom-slot initializer (and the `.loadable(state:onRetry:emptyView:errorView:)`
/// modifier) lets the caller pass `@ViewBuilder` closures for either slot.
///
/// Basic usage (default views):
/// ```swift
/// var body: some View {
///     MyFormContent()
///         .loadable(viewState.loadingState)
/// }
/// ```
///
/// Custom views (host app's branded placeholders):
/// ```swift
/// var body: some View {
///     MyFormContent()
///         .loadable(viewState.loadingState, onRetry: viewModel.retry) {
///             BrandedEmptyView(...)
///         } errorView: { error in
///             BrandedErrorView(error: error, ...)
///         }
/// }
/// ```
public struct LoadableContent<
	StateContent,
	Failure: Error,
	Content: View,
	EmptyContent: View,
	ErrorContent: View
>: View {
	let state: LoadingState<StateContent, Failure>
	let content: Content
	let emptyContent: () -> EmptyContent
	let errorContent: (Failure) -> ErrorContent
	let onRetry: (() async -> Void)?

	@State private var animatedState: LoadingState<StateContent, Failure>

	@Environment(\.optionalTheme)
	private var theme: AnyTheme?

	/// Designated initializer — fully custom empty / error views.
	public init(
		state: LoadingState<StateContent, Failure>,
		onRetry: (() async -> Void)? = nil,
		@ViewBuilder content: () -> Content,
		@ViewBuilder emptyContent: @escaping () -> EmptyContent,
		@ViewBuilder errorContent: @escaping (Failure) -> ErrorContent
	) {
		self.state = state
		_animatedState = State(initialValue: state)
		self.content = content()
		self.emptyContent = emptyContent
		self.errorContent = errorContent
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
							LoadingSpinner()
								.frame(width: 40, height: 40)
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
						emptyContent()
					}
			}
			// Failed state: hide content, show error view
			.if(isFailed) { view in
				view
					.hidden()
					.overlay {
						if case .failed(let error) = animatedState {
							errorContent(error)
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

// MARK: - Default-View Convenience

/// When the caller doesn't provide custom slots, the empty / error views
/// fall back to the framework defaults. The `where` clause specializes
/// the generic parameters so callers don't have to write them out.
public extension LoadableContent
where EmptyContent == DefaultEmptyStateView, ErrorContent == DefaultErrorStateView {

	/// Convenience initializer using the default empty / error views.
	/// Preserves the v1 LoadableContent call shape; any caller written
	/// against `init(state:onRetry:content:)` keeps working unchanged.
	init(
		state: LoadingState<StateContent, Failure>,
		onRetry: (() async -> Void)? = nil,
		@ViewBuilder content: () -> Content
	) {
		self.init(
			state: state,
			onRetry: onRetry,
			content: content,
			emptyContent: {
				DefaultEmptyStateView { await onRetry?() }
			},
			errorContent: { error in
				DefaultErrorStateView(error: error) { await onRetry?() }
			}
		)
	}
}

// MARK: - View Extensions

public extension View {

	/// Apply loadable state handling with the framework's default
	/// empty / error views. Shorter call shape for cases where the
	/// app is happy with PageKit's defaults.
	///
	/// - Parameters:
	///   - state: The current loading state value (read directly,
	///     not as Binding — the read establishes `@Observable`
	///     tracking).
	///   - onRetry: Optional async closure called when retry is
	///     triggered.
	/// - Returns: A view that responds to loading state changes.
	func loadable<StateContent, Failure: Error>(
		_ state: LoadingState<StateContent, Failure>,
		onRetry: (() async -> Void)? = nil
	) -> some View {
		LoadableContent(state: state, onRetry: onRetry) {
			self
		}
	}

	/// Apply loadable state handling with caller-supplied empty
	/// and error views. Use this when the host app needs branded
	/// placeholders (different copy, icons, layout) than PageKit's
	/// neutral defaults.
	///
	/// The empty view is built unconditionally; the error view
	/// receives the typed `Failure` so it can render different
	/// copy per error case (e.g., `.notFound` vs `.unavailable`).
	///
	/// - Parameters:
	///   - state: The current loading state value.
	///   - onRetry: Optional async closure called when retry is
	///     triggered. If your custom views call retry themselves,
	///     pass `nil` here and wire the closure inside the slot
	///     bodies.
	///   - emptyView: View shown for `.empty` state.
	///   - errorView: View shown for `.failed`, given the error.
	/// - Returns: A view that responds to loading state changes.
	func loadable<StateContent, Failure: Error, EmptyContent: View, ErrorContent: View>(
		_ state: LoadingState<StateContent, Failure>,
		onRetry: (() async -> Void)? = nil,
		@ViewBuilder emptyView: @escaping () -> EmptyContent,
		@ViewBuilder errorView: @escaping (Failure) -> ErrorContent
	) -> some View {
		LoadableContent(
			state: state,
			onRetry: onRetry,
			content: { self },
			emptyContent: emptyView,
			errorContent: errorView
		)
	}
}

// MARK: - Default Loading View

/// Default view displayed during loading state
public struct DefaultLoadingStateView: View {
	public init() {}

	public var body: some View {
		LoadingSpinner()
			.frame(width: 32, height: 32)
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
