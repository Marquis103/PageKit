//
//  FadeInModifier.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

// MARK: - FadeInModifier

private struct FadeInModifier: Animatable, ViewModifier {
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
	func fadeIn() -> some View {
		modifier(FadeInModifier())
	}
}
