//
//  LetModifier.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

extension View {
	@ViewBuilder
	public func `let`<V>(
		_ value: V?,
		transform: (Self, V) -> some View
	) -> some View {
		if let value {
			transform(self, value)
		} else {
			self
		}
	}

	@ViewBuilder
	public func `let`<V>(
		_ value: V?,
		if ifTransform: (Self, V) -> some View,
		else elseTransform: (Self) -> some View
	) -> some View {
		if let value {
			ifTransform(self, value)
		} else {
			elseTransform(self)
		}
	}
}
