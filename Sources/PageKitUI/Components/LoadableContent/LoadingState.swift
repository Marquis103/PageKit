//
//  LoadingState.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation

/// Represents the state of loadable content
///
/// LoadingState is a generic enum that tracks async data loading operations.
/// It carries the loaded data directly in the `.loaded` case for type safety.
///
/// Example usage:
/// ```swift
/// @Observable
/// class ProductListViewState: PageViewState {
///     var productsState: LoadingState<[Product], Error> = .idle
/// }
///
/// // In ViewModel
/// func loadProducts() async {
///     viewState.productsState = .loading
///     do {
///         let products = try await api.fetchProducts()
///         viewState.productsState = products.isEmpty ? .empty : .loaded(products)
///     } catch {
///         viewState.productsState = .failed(error)
///     }
/// }
/// ```
public enum LoadingState<Content, Failure: Error> {
	/// Initial state before any loading has occurred
	case idle

	/// Currently loading data
	case loading

	/// Data loaded successfully
	case loaded(Content)

	/// Data loaded but result is empty
	case empty

	/// Loading failed with an error
	case failed(Failure)
}

// MARK: - Convenience Properties

extension LoadingState {
	/// Returns true if currently in the loading state
	public var isLoading: Bool {
		if case .loading = self { return true }
		return false
	}

	/// Returns true if in idle state
	public var isIdle: Bool {
		if case .idle = self { return true }
		return false
	}

	/// Returns true if in empty state
	public var isEmpty: Bool {
		if case .empty = self { return true }
		return false
	}

	/// Returns true if in failed state
	public var isFailed: Bool {
		if case .failed = self { return true }
		return false
	}

	/// Returns true if data has been loaded successfully
	public var isLoaded: Bool {
		if case .loaded = self { return true }
		return false
	}

	/// Returns the loaded content if available
	public var content: Content? {
		if case .loaded(let content) = self { return content }
		return nil
	}

	/// Returns the error if in failed state
	public var error: Failure? {
		if case .failed(let error) = self { return error }
		return nil
	}
}

// MARK: - Equatable Conformance

extension LoadingState: Equatable where Content: Equatable, Failure: Equatable {}

// MARK: - Hashable Conformance

extension LoadingState: Hashable where Content: Hashable, Failure: Hashable {}

// MARK: - Sendable Conformance

extension LoadingState: Sendable where Content: Sendable, Failure: Sendable {}
