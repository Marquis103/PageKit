//
//  LoadingView.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI
import PageKitTheming

/// A centered loading indicator with optional text
///
/// LoadingView displays a ProgressView centered in its container. It integrates
/// with PageKit's theming system to use the primary color.
///
/// Usage:
/// ```swift
/// // Simple loading indicator
/// LoadingView()
///
/// // With loading text
/// LoadingView(text: "Loading...")
///
/// // Custom spacing
/// LoadingView(text: "Please wait", spacing: 12)
/// ```
public struct LoadingView: View {
	private let text: String?
	private let spacing: CGFloat

	@Environment(\.optionalTheme)
	private var theme: AnyTheme?

	/// Creates a loading view
	/// - Parameters:
	///   - text: Optional text to display below the spinner
	///   - spacing: Spacing between spinner and text (default: 8)
	public init(text: String? = nil, spacing: CGFloat = 8) {
		self.text = text
		self.spacing = spacing
	}

	public var body: some View {
		VStack(spacing: spacing) {
			ProgressView()
				.tint(theme?.colors.primary)

			if let text {
				Text(text)
					.font(.subheadline)
					.foregroundStyle(theme?.colors.text.primary ?? .primary)
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}

// MARK: - Preview

#if DEBUG
#Preview("Loading View") {
	VStack(spacing: 40) {
		LoadingView()
			.frame(height: 100)
			.background(Color.gray.opacity(0.1))

		LoadingView(text: "Loading...")
			.frame(height: 100)
			.background(Color.gray.opacity(0.1))
	}
	.padding()
}
#endif
