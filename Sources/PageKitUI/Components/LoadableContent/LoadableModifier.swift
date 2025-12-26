//
//  LoadableModifier.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

/// A view modifier that applies loading state handling to any view
///
/// This modifier allows any view to respond to `LoadingState` changes.
/// Unlike `LoadableContent` (wrapper view), this modifier works with views
/// that manage their own content separately from the loading state.
///
/// **Key Behaviors:**
/// - `.idle`, `.loading` → Content hidden, spinner shown (initial load)
/// - `.loaded(StateContent)` → Content visible (ViewModel populates data)
/// - `.empty` → Content hidden, default empty state shown
/// - `.failed(Failure)` → Content hidden, default error state shown
/// - `.disabled` → Content visible but dimmed with overlay spinner (form submission)
///
/// **Usage:**
/// ```swift
/// // Form submission pattern
/// LoginForm(email: $viewState.email, password: $viewState.password)
///     .loadable(viewState.loadingState) {
///         await viewModel.login()
///     }
///
/// // Initial load pattern (data stored separately in viewState)
/// RecipeList(recipes: viewState.recipes)
///     .loadable(viewState.loadingState) {
///         await viewModel.loadRecipes()
///     }
/// ```
public struct LoadableModifier<StateContent, Failure: Error>: ViewModifier {
	let state: LoadingState<StateContent, Failure>
	let onRetry: (() async -> Void)?

	public init(
		state: LoadingState<StateContent, Failure>,
		onRetry: (() async -> Void)? = nil
	) {
		self.state = state
		self.onRetry = onRetry
	}

	// MARK: - State Properties

	private var isDisabled: Bool { state.isDisabled }
	private var isLoading: Bool { state.isLoading || state.isIdle }
	private var isEmpty: Bool { state.isEmpty }
	private var isFailed: Bool { state.isFailed }

	// MARK: - Body

	public func body(content: Content) -> some View {
		content
			// Disabled state: show content dimmed with spinner overlay
			.if(isDisabled) { view in
				view
					.disabled(true)
					.overlay {
						ZStack {
							Color.black.opacity(0.4)
								.ignoresSafeArea()
							ProgressView()
								.tint(.white)
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
						DefaultEmptyStateView { await retry() }
					}
			}
			// Failed state: hide content, show error view
			.if(isFailed) { view in
				view
					.hidden()
					.overlay {
						errorOverlay
					}
			}
			.animation(.easeInOut(duration: 0.2), value: stateKey)
	}

	// MARK: - Private Helpers

	@ViewBuilder
	private var errorOverlay: some View {
		if case .failed(let error) = state {
			DefaultErrorStateView(error: error) { await retry() }
		}
	}

	private func retry() async {
		await onRetry?()
	}

	/// Key for animation - changes when state type changes
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
}

// MARK: - Conditional View Modifier

extension View {
	/// Conditionally applies a transformation to the view
	///
	/// This modifier preserves view identity when the condition is false,
	/// which is essential for proper SwiftUI state management and animations.
	///
	/// - Parameters:
	///   - condition: Whether to apply the transformation
	///   - transform: The transformation to apply when condition is true
	/// - Returns: Either the transformed view or the original view
	@ViewBuilder
	func `if`<Transform: View>(
		_ condition: Bool,
		transform: (Self) -> Transform
	) -> some View {
		if condition {
			transform(self)
		} else {
			self
		}
	}
}

// MARK: - View Extension

extension View {
	/// Apply loadable state handling to any view
	///
	/// This modifier allows views to respond to loading state changes.
	/// Use this when data is managed separately from the loading state.
	///
	/// - Parameters:
	///   - state: The current loading state
	///   - onRetry: Optional async closure called when retry is triggered
	/// - Returns: A view that responds to loading state changes
	///
	/// **Form Submission Example:**
	/// ```swift
	/// @Observable
	/// class LoginViewState: PageViewState {
	///     var email: String = ""
	///     var password: String = ""
	///     var loadingState: LoadingState<Void, Error> = .idle
	/// }
	///
	/// // ViewModel
	/// func login() async {
	///     viewState.loadingState = .disabled  // Show overlay
	///     do {
	///         try await authService.login(...)
	///         viewState.loadingState = .loaded(())
	///     } catch {
	///         viewState.loadingState = .failed(error)
	///     }
	/// }
	///
	/// // View
	/// LoginForm(...)
	///     .loadable(viewState.loadingState)
	/// ```
	public func loadable<StateContent, Failure: Error>(
		_ state: LoadingState<StateContent, Failure>,
		onRetry: (() async -> Void)? = nil
	) -> some View {
		modifier(LoadableModifier(state: state, onRetry: onRetry))
	}
}
