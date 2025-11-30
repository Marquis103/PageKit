//
//  HorizontalList.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI
import PageKit
import PageKitTheming

/// A horizontal scrolling list built on LazyHStack
///
/// PageKit's HorizontalList provides a performant horizontal scrolling list component.
/// It integrates with the refresh system and supports customizable spacing and padding.
///
/// Usage:
/// ```swift
/// // Basic horizontal list
/// HorizontalList(categories) { category in
///     CategoryCard(category: category)
/// }
///
/// // With custom spacing
/// HorizontalList(items, spacing: 16) { item in
///     ItemCard(item: item)
/// }
///
/// // With refresh support
/// HorizontalList(items, onRefresh: { await viewModel.refresh() }) { item in
///     ItemCard(item: item)
/// }
///
/// // With scroll indicators
/// HorizontalList(items, showsIndicators: true) { item in
///     ItemCard(item: item)
/// }
/// ```
public struct HorizontalList<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
	private let data: Data
	private let spacing: CGFloat
	private let horizontalPadding: CGFloat
	private let verticalPadding: CGFloat
	private let showsIndicators: Bool
	private let onRefresh: (() async -> Void)?
	private let content: (Data.Element) -> Content

	@Environment(\.interaction)
	private var interaction: Interaction

	/// Creates a HorizontalList with customizable appearance and optional refresh
	/// - Parameters:
	///   - data: The collection of identifiable items
	///   - spacing: Horizontal spacing between items (default: 12)
	///   - horizontalPadding: Horizontal padding for content (default: 16)
	///   - verticalPadding: Vertical padding for content (default: 0)
	///   - showsIndicators: Whether to show scroll indicators (default: false)
	///   - onRefresh: Optional async closure for pull-to-refresh
	///   - content: ViewBuilder closure for each item
	public init(
		_ data: Data,
		spacing: CGFloat = 12,
		horizontalPadding: CGFloat = 16,
		verticalPadding: CGFloat = 0,
		showsIndicators: Bool = false,
		onRefresh: (() async -> Void)? = nil,
		@ViewBuilder content: @escaping (Data.Element) -> Content
	) {
		self.data = data
		self.spacing = spacing
		self.horizontalPadding = horizontalPadding
		self.verticalPadding = verticalPadding
		self.showsIndicators = showsIndicators
		self.onRefresh = onRefresh
		self.content = content
	}

	/// Creates a HorizontalList with PageEventHandler for automatic refresh integration
	/// - Parameters:
	///   - data: The collection of identifiable items
	///   - spacing: Horizontal spacing between items (default: 12)
	///   - horizontalPadding: Horizontal padding for content (default: 16)
	///   - verticalPadding: Vertical padding for content (default: 0)
	///   - showsIndicators: Whether to show scroll indicators (default: false)
	///   - handler: PageEventHandler for refresh integration
	///   - content: ViewBuilder closure for each item
	public init<Event>(
		_ data: Data,
		spacing: CGFloat = 12,
		horizontalPadding: CGFloat = 16,
		verticalPadding: CGFloat = 0,
		showsIndicators: Bool = false,
		handler: PageEventHandler<Event>,
		@ViewBuilder content: @escaping (Data.Element) -> Content
	) {
		self.data = data
		self.spacing = spacing
		self.horizontalPadding = horizontalPadding
		self.verticalPadding = verticalPadding
		self.showsIndicators = showsIndicators
		self.onRefresh = handler.onRefresh
		self.content = content
	}

	public var body: some View {
		SwiftUI.ScrollView(.horizontal, showsIndicators: showsIndicators) {
			LazyHStack(spacing: spacing) {
				ForEach(data) { item in
					content(item)
				}
			}
			.padding(.horizontal, horizontalPadding)
			.padding(.vertical, verticalPadding)
		}
		.modifier(HorizontalListRefreshableModifier(
			isEnabled: onRefresh != nil && !interaction.disabled,
			onRefresh: onRefresh
		))
	}
}

// MARK: - HorizontalListRefreshableModifier

/// Internal modifier that conditionally applies .refreshable
private struct HorizontalListRefreshableModifier: ViewModifier {
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

// MARK: - Preview

#if DEBUG
private struct PreviewCategory: Identifiable {
	let id = UUID()
	let name: String
	let color: Color
}

#Preview("HorizontalList") {
	let categories = [
		PreviewCategory(name: "Design", color: .blue),
		PreviewCategory(name: "Development", color: .green),
		PreviewCategory(name: "Marketing", color: .orange),
		PreviewCategory(name: "Sales", color: .purple),
		PreviewCategory(name: "Support", color: .red)
	]

	VStack(alignment: .leading, spacing: 16) {
		Text("Categories")
			.font(.headline)
			.padding(.horizontal)

		HorizontalList(categories) { category in
			Text(category.name)
				.padding(.horizontal, 16)
				.padding(.vertical, 8)
				.background(category.color.opacity(0.2))
				.foregroundStyle(category.color)
				.cornerRadius(8)
		}
	}
}
#endif
