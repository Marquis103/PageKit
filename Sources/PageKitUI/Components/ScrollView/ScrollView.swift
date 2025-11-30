//
//  ScrollView.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI
import PageKit

/// A scroll view with optional pull-to-refresh support
///
/// PageKit's ScrollView integrates with the `PageEventHandler` and `Refreshable` protocol
/// to provide seamless pull-to-refresh functionality. If you need SwiftUI's native ScrollView,
/// use `SwiftUI.ScrollView`.
///
/// Usage with PageEventHandler:
/// ```swift
/// ScrollView(handler: handler) {
///     LazyVStack {
///         ForEach(viewState.items) { item in
///             ItemRow(item: item)
///         }
///     }
/// }
/// ```
///
/// Usage with explicit refresh closure:
/// ```swift
/// ScrollView(onRefresh: { await viewModel.refresh() }) {
///     // content
/// }
/// ```
///
/// Usage without refresh (no pull-to-refresh):
/// ```swift
/// ScrollView {
///     // content
/// }
/// ```
public struct ScrollView<Content: View>: View {
	private let axes: Axis.Set
	private let showsIndicators: Bool
	private let onRefresh: (() async -> Void)?
	private let content: Content

	@Environment(\.interaction)
	private var interaction: Interaction

	/// Creates a ScrollView with an optional refresh closure
	/// - Parameters:
	///   - axes: The scroll axes (default: vertical)
	///   - showsIndicators: Whether to show scroll indicators (default: true)
	///   - onRefresh: Optional async closure to execute on pull-to-refresh
	///   - content: The scroll view content
	public init(
		_ axes: Axis.Set = .vertical,
		showsIndicators: Bool = true,
		onRefresh: (() async -> Void)? = nil,
		@ViewBuilder content: () -> Content
	) {
		self.axes = axes
		self.showsIndicators = showsIndicators
		self.onRefresh = onRefresh
		self.content = content()
	}

	/// Creates a ScrollView with a PageEventHandler for automatic refresh integration
	///
	/// The refresh closure is automatically extracted from the handler if the underlying
	/// ViewModel conforms to `Refreshable`.
	///
	/// - Parameters:
	///   - axes: The scroll axes (default: vertical)
	///   - showsIndicators: Whether to show scroll indicators (default: true)
	///   - handler: The page event handler
	///   - content: The scroll view content
	public init<Event>(
		_ axes: Axis.Set = .vertical,
		showsIndicators: Bool = true,
		handler: PageEventHandler<Event>,
		@ViewBuilder content: () -> Content
	) {
		self.axes = axes
		self.showsIndicators = showsIndicators
		self.onRefresh = handler.onRefresh
		self.content = content()
	}

	public var body: some View {
		SwiftUI.ScrollView(axes, showsIndicators: showsIndicators) {
			content
		}
		.modifier(RefreshableModifier(
			isEnabled: onRefresh != nil && !interaction.disabled,
			onRefresh: onRefresh
		))
	}
}

// MARK: - RefreshableModifier

/// Internal modifier that conditionally applies .refreshable
private struct RefreshableModifier: ViewModifier {
	let isEnabled: Bool
	let onRefresh: (() async -> Void)?

	func body(content: Content) -> some View {
		if isEnabled, let onRefresh {
			content.refreshable {
				await onRefresh()
			}
		} else {
			content
		}
	}
}
