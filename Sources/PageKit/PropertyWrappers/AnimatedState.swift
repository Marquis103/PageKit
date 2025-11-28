//
//  AnimatedState.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

@propertyWrapper
public struct AnimatedState<Value>: DynamicProperty {
	@State
	private var animatedValue: Value
	@State
	private var isAnimationEnabled: Bool = true

	private var animation: Animation

	public var wrappedValue: Value {
		get { animatedValue }
		nonmutating set {
			if isAnimationEnabled {
				animate(newValue)
			} else {
				withAnimation(nil) {
					animatedValue = newValue
				}
			}
		}
	}

	private func animate(_ newValue: Value) {
		withAnimation(animation) {
			animatedValue = newValue
		}
	}

	public init(wrappedValue initialValue: Value, animation: Animation = .default) {
		_animatedValue = State(initialValue: initialValue)
		self.animation = animation
	}

	public func disableAnimation() {
		isAnimationEnabled = false
	}
}
