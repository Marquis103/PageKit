//
//  LoadingSpinner.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI
import PageKit
import PageKitTheming

/// A custom animated loading spinner that uses the theme's primary color.
///
/// LoadingSpinner displays a circular arc that rotates and pulses, providing
/// a more polished loading indicator than the standard `ProgressView`.
///
/// The spinner automatically starts animating when it appears and stops
/// when it disappears to conserve resources.
///
/// Example:
/// ```swift
/// LoadingSpinner()
///     .frame(width: 40, height: 40)
/// ```
public struct LoadingSpinner: View {
	@Environment(\.optionalTheme)
	private var theme: AnyTheme?

	@AnimatedState(animation: .linear(duration: 0.75).repeatForever(autoreverses: false))
	private var rotation: Double = 0

	@AnimatedState(animation: .easeInOut(duration: 1).repeatForever(autoreverses: true))
	private var trimStart: CGFloat = 0.025

	@AnimatedState(animation: .easeInOut(duration: 1).repeatForever(autoreverses: true))
	private var trimEnd: CGFloat = 0.975

	@State
	private var isAnimating: Bool = false

	public init() {}

	public var body: some View {
		Circle()
			.trim(from: trimStart, to: trimEnd)
			.stroke(theme?.colors.primary ?? .accentColor, lineWidth: 2)
			.rotationEffect(Angle(degrees: rotation), anchor: .center)
			.onAppear { startAnimating() }
			.onDisappear { stopAnimating() }
	}

	private func startAnimating() {
		guard !isAnimating else { return }
		isAnimating = true

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.010) {
			rotation = 360
			trimStart = 0.475
			trimEnd = 0.525
		}
	}

	private func stopAnimating() {
		isAnimating = false

		_rotation.disableAnimation()
		_trimStart.disableAnimation()
		_trimEnd.disableAnimation()

		rotation = 0
		trimStart = 0.025
		trimEnd = 0.975
	}
}
