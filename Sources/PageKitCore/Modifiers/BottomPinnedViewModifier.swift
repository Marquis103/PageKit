//
//  BottomPinnedViewModifier.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

// MARK: - BottomPinnedViewModifier

struct BottomPinnedViewModifier<Content: View>: ViewModifier {  // PE-536/E4: internal — bridge codegen chokes on the builder init; the .bottomPinned extension is the API
	let pinnedContent: Content

	@State
	var pinnedContentHeight: CGFloat = 0

	init(@ViewBuilder pinnedContent: () -> Content) {
		self.pinnedContent = pinnedContent()
	}

	func body(content: Content) -> some View {
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
	func bottomPinnedView(  // PE-536/E4: internal — bridge codegen limitation on @ViewBuilder params
		@ViewBuilder _ pinnedContent: @escaping () -> some View
	) -> some View {
		modifier(BottomPinnedViewModifier(pinnedContent: pinnedContent))
	}
}
