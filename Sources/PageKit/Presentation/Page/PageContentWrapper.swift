//
//  PageContentWrapper.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

public struct PageContentWrapper<Content: View>: View {
	@ObservedObject
	private var interaction: Interaction

	private let content: Content

	public init(@ViewBuilder content: () -> Content) {
		self.content = content()
		interaction = Interaction(disabled: false)
	}

	public var body: some View {
		content
			.environment(\.sizeCategory, .large)
			.environment(\.interaction, interaction)
			.disabled(interaction.disabled)
	}
}
