//
//  FadeInModifier.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

// MARK: - FadeInModifier

struct FadeInModifier: Animatable, ViewModifier {  // skipstone: internal (see PORTABILITY.md)
	@AnimatedState
	private var opacity: CGFloat = 0

	func body(content: Content) -> some View {
		content
			.opacity(opacity)
			.transition(.opacity)
			.onAppear {
				opacity = 1
			}
	}
}

extension View {
	public func fadeIn() -> some View {
		modifier(FadeInModifier())
	}
}
