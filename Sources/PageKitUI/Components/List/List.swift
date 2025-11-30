//
//  List.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI
import PageKit
import PageKitTheming

/// A vertical list with optional pull-to-refresh and separators
///
/// PageKit's List provides a performant, theme-aware list component built on LazyVStack.
/// It integrates with the refresh system from ScrollView and uses theme colors for separators.
///
/// Usage:
/// ```swift
/// // Basic list with refresh
/// List(items, onRefresh: { await viewModel.refresh() }) { item in
///     ItemRow(item: item)
/// }
///
/// // List with custom separators
/// List(items, showSeparators: true, separatorColor: .gray.opacity(0.3)) { item in
///     ItemRow(item: item)
/// }
///
/// // List without separators
/// List(items, showSeparators: false) { item in
///     ItemRow(item: item)
/// }
///
/// // List with PageEventHandler
/// List(items, handler: handler) { item in
///     ItemRow(item: item)
/// }
/// ```
public struct List<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
	private let data: Data
	private let spacing: CGFloat
	private let horizontalPadding: CGFloat
	private let verticalPadding: CGFloat
	private let alignment: HorizontalAlignment
	private let showSeparators: Bool
	private let separatorColor: Color?
	private let separatorHeight: CGFloat
	private let separatorPadding: CGFloat
	private let onRefresh: (() async -> Void)?
	private let content: (Data.Element) -> Content

	@Environment(\.optionalTheme)
	private var theme: AnyTheme?

	@Environment(\.interaction)
	private var interaction: Interaction

	/// Creates a List with customizable appearance and optional refresh
	/// - Parameters:
	///   - data: The collection of identifiable items
	///   - spacing: Vertical spacing between items (default: 16)
	///   - horizontalPadding: Horizontal padding for the list (default: 16)
	///   - verticalPadding: Vertical padding for the list (default: 0)
	///   - alignment: Horizontal alignment of items (default: .leading)
	///   - showSeparators: Whether to show separators between items (default: true)
	///   - separatorColor: Optional custom separator color (uses theme divider color if nil)
	///   - separatorHeight: Height of separators (default: 1)
	///   - separatorPadding: Horizontal padding for separators (default: 16)
	///   - onRefresh: Optional async closure for pull-to-refresh
	///   - content: ViewBuilder closure for each item
	public init(
		_ data: Data,
		spacing: CGFloat = 16,
		horizontalPadding: CGFloat = 16,
		verticalPadding: CGFloat = 0,
		alignment: HorizontalAlignment = .leading,
		showSeparators: Bool = true,
		separatorColor: Color? = nil,
		separatorHeight: CGFloat = 1,
		separatorPadding: CGFloat = 16,
		onRefresh: (() async -> Void)? = nil,
		@ViewBuilder content: @escaping (Data.Element) -> Content
	) {
		self.data = data
		self.spacing = spacing
		self.horizontalPadding = horizontalPadding
		self.verticalPadding = verticalPadding
		self.alignment = alignment
		self.showSeparators = showSeparators
		self.separatorColor = separatorColor
		self.separatorHeight = separatorHeight
		self.separatorPadding = separatorPadding
		self.onRefresh = onRefresh
		self.content = content
	}

	/// Creates a List with PageEventHandler for automatic refresh integration
	/// - Parameters:
	///   - data: The collection of identifiable items
	///   - spacing: Vertical spacing between items (default: 16)
	///   - horizontalPadding: Horizontal padding for the list (default: 16)
	///   - verticalPadding: Vertical padding for the list (default: 0)
	///   - alignment: Horizontal alignment of items (default: .leading)
	///   - showSeparators: Whether to show separators between items (default: true)
	///   - separatorColor: Optional custom separator color
	///   - separatorHeight: Height of separators (default: 1)
	///   - separatorPadding: Horizontal padding for separators (default: 16)
	///   - handler: PageEventHandler for refresh integration
	///   - content: ViewBuilder closure for each item
	public init<Event>(
		_ data: Data,
		spacing: CGFloat = 16,
		horizontalPadding: CGFloat = 16,
		verticalPadding: CGFloat = 0,
		alignment: HorizontalAlignment = .leading,
		showSeparators: Bool = true,
		separatorColor: Color? = nil,
		separatorHeight: CGFloat = 1,
		separatorPadding: CGFloat = 16,
		handler: PageEventHandler<Event>,
		@ViewBuilder content: @escaping (Data.Element) -> Content
	) {
		self.data = data
		self.spacing = spacing
		self.horizontalPadding = horizontalPadding
		self.verticalPadding = verticalPadding
		self.alignment = alignment
		self.showSeparators = showSeparators
		self.separatorColor = separatorColor
		self.separatorHeight = separatorHeight
		self.separatorPadding = separatorPadding
		self.onRefresh = handler.onRefresh
		self.content = content
	}

	public var body: some View {
		SwiftUI.ScrollView {
			LazyVStack(alignment: alignment, spacing: spacing) {
				ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
					content(item)

					if showSeparators && index < data.count - 1 {
						Rectangle()
							.fill(resolvedSeparatorColor)
							.frame(height: separatorHeight)
							.padding(.horizontal, separatorPadding)
					}
				}
			}
			.padding(.horizontal, horizontalPadding)
			.padding(.vertical, verticalPadding)
		}
		.modifier(ListRefreshableModifier(
			isEnabled: onRefresh != nil && !interaction.disabled,
			onRefresh: onRefresh
		))
	}

	private var resolvedSeparatorColor: Color {
		separatorColor ?? theme?.colors.divider ?? Color.gray.opacity(0.2)
	}
}

// MARK: - ListRefreshableModifier

/// Internal modifier that conditionally applies .refreshable
private struct ListRefreshableModifier: ViewModifier {
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
private struct PreviewItem: Identifiable {
	let id = UUID()
	let title: String
}

#Preview("List") {
	let items = [
		PreviewItem(title: "Item 1"),
		PreviewItem(title: "Item 2"),
		PreviewItem(title: "Item 3"),
		PreviewItem(title: "Item 4"),
		PreviewItem(title: "Item 5")
	]

	List(items) { item in
		Text(item.title)
			.padding(.vertical, 8)
	}
}

#Preview("List Without Separators") {
	let items = [
		PreviewItem(title: "Item 1"),
		PreviewItem(title: "Item 2"),
		PreviewItem(title: "Item 3")
	]

	List(items, showSeparators: false) { item in
		Text(item.title)
			.padding()
			.background(Color.gray.opacity(0.1))
			.cornerRadius(8)
	}
}
#endif
