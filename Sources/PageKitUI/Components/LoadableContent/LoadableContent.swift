//
//  LoadableContent.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI
import PageKitTheming

/// A container view that manages loading, loaded, empty, and error states
///
/// LoadableContent renders different views based on the current `LoadingState`.
/// It provides sensible defaults but allows full customization via ViewBuilder closures.
///
/// Basic usage with defaults:
/// ```swift
/// LoadableContent(state: viewState.productsState) { products in
///     ForEach(products) { product in
///         ProductRow(product: product)
///     }
/// } onRetry: {
///     await handler.onRefresh?()
/// }
/// ```
///
/// Full customization:
/// ```swift
/// LoadableContent(state: viewState.productsState) { products in
///     ProductList(products: products)
/// } empty: { retry in
///     CustomEmptyView(onRetry: retry)
/// } error: { error, retry in
///     CustomErrorView(error: error, onRetry: retry)
/// } loading: {
///     CustomLoadingView()
/// } onRetry: {
///     await viewModel.refresh()
/// }
/// ```
public struct LoadableContent<
	Content,
	LoadedView: View,
	EmptyStateView: View,
	ErrorStateView: View,
	LoadingStateView: View
>: View {
	private let state: LoadingState<Content, any Error>
	private let loadedView: (Content) -> LoadedView
	private let emptyView: (@escaping () async -> Void) -> EmptyStateView
	private let errorView: (Error, @escaping () async -> Void) -> ErrorStateView
	private let loadingView: () -> LoadingStateView
	private let onRetry: (() async -> Void)?

	@Environment(\.optionalTheme)
	private var theme: AnyTheme?

	/// Creates a LoadableContent view with full customization
	/// - Parameters:
	///   - state: The current loading state
	///   - content: ViewBuilder for the loaded content
	///   - empty: ViewBuilder for the empty state (receives retry closure)
	///   - error: ViewBuilder for the error state (receives error and retry closure)
	///   - loading: ViewBuilder for the loading state
	///   - onRetry: Optional async closure to call when retrying
	public init<F: Error>(
		state: LoadingState<Content, F>,
		@ViewBuilder content: @escaping (Content) -> LoadedView,
		@ViewBuilder empty: @escaping (@escaping () async -> Void) -> EmptyStateView,
		@ViewBuilder error: @escaping (Error, @escaping () async -> Void) -> ErrorStateView,
		@ViewBuilder loading: @escaping () -> LoadingStateView,
		onRetry: (() async -> Void)? = nil
	) {
		// Type-erase the error to allow any Error type
		switch state {
		case .idle:
			self.state = .idle
		case .loading:
			self.state = .loading
		case .loaded(let content):
			self.state = .loaded(content)
		case .empty:
			self.state = .empty
		case .failed(let error):
			self.state = .failed(error)
		}
		self.loadedView = content
		self.emptyView = empty
		self.errorView = error
		self.loadingView = loading
		self.onRetry = onRetry
	}

	public var body: some View {
		Group {
			switch state {
			case .idle, .loading:
				loadingView()

			case .loaded(let content):
				loadedView(content)

			case .empty:
				emptyView(retry)

			case .failed(let error):
				errorView(error, retry)
			}
		}
		.animation(.easeInOut(duration: 0.2), value: stateKey)
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
		}
	}
}

// MARK: - Convenience Initializer with Default Views

extension LoadableContent where
	EmptyStateView == DefaultEmptyStateView,
	ErrorStateView == DefaultErrorStateView,
	LoadingStateView == DefaultLoadingStateView
{
	/// Creates a LoadableContent view with default loading, empty, and error views
	/// - Parameters:
	///   - state: The current loading state
	///   - content: ViewBuilder for the loaded content
	///   - onRetry: Optional async closure to call when retrying
	public init<F: Error>(
		state: LoadingState<Content, F>,
		@ViewBuilder content: @escaping (Content) -> LoadedView,
		onRetry: (() async -> Void)? = nil
	) {
		self.init(
			state: state,
			content: content,
			empty: { retry in DefaultEmptyStateView(onRetry: retry) },
			error: { error, retry in DefaultErrorStateView(error: error, onRetry: retry) },
			loading: { DefaultLoadingStateView() },
			onRetry: onRetry
		)
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
