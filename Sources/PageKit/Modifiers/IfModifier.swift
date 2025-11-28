//
//  IfModifier.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

extension View {
	@ViewBuilder
	public func `if`(
		_ condition: Bool,
		transform: (Self) -> some View
	) -> some View {
		if condition {
			transform(self)
		} else {
			self
		}
	}

	@ViewBuilder
	public func `if`(
		_ condition: Bool,
		if ifTransform: (Self) -> some View,
		else elseTransform: (Self) -> some View
	) -> some View {
		if condition {
			ifTransform(self)
		} else {
			elseTransform(self)
		}
	}
}
