//
//  StrikethroughModifier.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

// MARK: - StrikethroughModifier

@available(iOS, deprecated: 16, message: "Use native strikethrough modifier.")
private struct StrikethroughModifier: ViewModifier {
	@Environment(\.theme)
	private var theme: Theme

	var color: Color?

	init(color: Color?) {
		self.color = color
	}

	func body(content: Content) -> some View {
		if #available(iOS 16.0, *) {
			content
				.strikethrough(color: color ?? theme.colors.text.tertiary)
		} else {
			ZStack {
				content

				Rectangle()
					.fill(color ?? theme.colors.text.tertiary)
					.frame(height: 2)
					.offset(y: -1)
			}
		}
	}
}

extension View {
	func strikethroughText(
		color: Color? = nil
	) -> some View {
		modifier(
			StrikethroughModifier(
				color: color
			)
		)
	}
}
