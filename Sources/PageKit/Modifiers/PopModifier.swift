//
//  PopModifier.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

// MARK: - PopModifier

private struct PopModifier: Animatable, ViewModifier {
	@Binding
	var popTrigger: Bool

	let duration: Double
	let maxScale: CGFloat

	@State
	private var scale: CGFloat = 1

	func body(content: Content) -> some View {
		content
			.scaleEffect(scale)
			.onChange(of: popTrigger) { _ in
				let iterationDuration = duration / 2

				withAnimation(
					.linear(duration: iterationDuration)
				) {
					scale = maxScale
				}

				withAnimation(
					.linear(duration: iterationDuration).delay(iterationDuration)
				) {
					scale = 1.0
				}
			}
	}
}

extension View {
	public func pop(
		_ popTrigger: Binding<Bool>,
		duration: Double = 0.25,
		maxScale: CGFloat = 1.25
	) -> some View {
		modifier(PopModifier(popTrigger: popTrigger, duration: duration, maxScale: maxScale))
	}
}
