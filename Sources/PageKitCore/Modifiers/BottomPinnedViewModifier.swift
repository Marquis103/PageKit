//
//  BottomPinnedViewModifier.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

// MARK: - BottomPinnedViewModifier

public struct BottomPinnedViewModifier<Content: View>: ViewModifier {
	let pinnedContent: Content

	@State
	private var pinnedContentHeight: CGFloat = 0

	public init(@ViewBuilder pinnedContent: () -> Content) {
		self.pinnedContent = pinnedContent()
	}

	public func body(content: Self.Content) -> some View {
		ZStack {
			content
				.padding(.bottom, pinnedContentHeight)

			GeometryReader { geometry in
				VStack {
					Spacer()

					pinnedContent
						.onSizeChange { size in
							pinnedContentHeight = size.height
						}
				}
				.frame(width: geometry.size.width, height: geometry.size.height)
			}
		}
	}
}

extension View {
	public func bottomPinnedView(
		@ViewBuilder _ pinnedContent: @escaping () -> some View
	) -> some View {
		modifier(BottomPinnedViewModifier(pinnedContent: pinnedContent))
	}
}
