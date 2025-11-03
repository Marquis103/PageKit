//
//  PageContentWrapper.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

struct PageContentWrapper<Content: View>: View {
	@ObservedObject
	private var interaction: Interaction

	private let content: Content

	init(@ViewBuilder content: () -> Content) {
		self.content = content()
		interaction = Interaction(disabled: false)
	}

	var body: some View {
		content
			.environment(\.sizeCategory, .large)
			.environment(\.interaction, interaction)
			.disabled(interaction.disabled)
	}
}
