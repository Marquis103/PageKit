//
//  PageContentWrapper.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import PageKitCore
import SwiftUI

public struct PageContentWrapper<Content: View>: View {
	@ObservedObject
	private var interaction: Interaction

	private let content: Content
	private let dynamicType: PageDynamicType

	/// Wraps a page with the app-wide text-size setting, ``PageHosting/dynamicType``, read now.
	public init(@ViewBuilder content: () -> Content) {
		self.init(dynamicType: PageHosting.dynamicType, content: content)
	}

	/// Wraps a page with an explicit text-size setting. Snapshot tests use this to render a page
	/// the way the app's hosts present it.
	public init(dynamicType: PageDynamicType, @ViewBuilder content: () -> Content) {
		self.content = content()
		self.dynamicType = dynamicType
		interaction = Interaction(disabled: false)
	}

	public var body: some View {
		sizedContent
			.environment(\.interaction, interaction)
			.disabled(interaction.disabled)
	}

	@ViewBuilder
	private var sizedContent: some View {
		switch dynamicType {
			case .pinned:
				content
					.environment(\.sizeCategory, .large)
			case .system:
				content
		}
	}
}
