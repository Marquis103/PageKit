//
//  BottomPinnedViewModifier.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

// MARK: - BottomPinnedViewModifier

struct BottomPinnedViewModifier<Content: View>: ViewModifier {
	let pinnedContent: Content

	@State
	private var pinnedContentHeight: CGFloat = 0

	init(@ViewBuilder pinnedContent: () -> Content) {
		self.pinnedContent = pinnedContent()
	}

	func body(content: Self.Content) -> some View {
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
	func bottomPinnedView(
		@ViewBuilder _ pinnedContent: @escaping () -> some View
	) -> some View {
		modifier(BottomPinnedViewModifier(pinnedContent: pinnedContent))
	}
}
