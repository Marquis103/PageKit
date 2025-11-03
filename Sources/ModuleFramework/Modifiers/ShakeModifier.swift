//
//  ShakeModifier.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

// MARK: - ShakeModifier

private struct ShakeModifier: Animatable, ViewModifier {
	@Binding
	var shakeTrigger: Bool

	let count: Int
	let duration: Double
	let maxOffset: CGFloat

	@State
	private var offset: CGFloat = 0

	func body(content: Content) -> some View {
		content
			.offset(x: offset)
			.onChange(of: shakeTrigger) { _ in
				let iterationDuration = duration / Double(count)
				var negativeOffset = false

				for i in (0 ... count).reversed() {
					withAnimation(
						.linear(duration: iterationDuration).delay(iterationDuration * Double(count - i))
					) {
						if i == 0 {
							offset = 0
						} else {
							offset = maxOffset * CGFloat(i) / CGFloat(count) * (negativeOffset ? -1 : 1)
						}
					}

					negativeOffset.toggle()
				}
			}
	}
}

extension View {
	func shake(
		_ shakeTrigger: Binding<Bool>,
		count: Int = 5,
		duration: Double = 0.25,
		maxOffset: CGFloat = 20
	) -> some View {
		modifier(ShakeModifier(shakeTrigger: shakeTrigger, count: count, duration: duration, maxOffset: maxOffset))
	}
}
