//
//  SettingsContent.swift
//
//  Copyright © 2025 PageKit. All rights reserved.
//

import SwiftUI
import PageKit

struct SettingsContent: PageContent {
	enum Event { }

	@ObservedObject var viewState: SettingsViewState
	let handler: PageEventHandler<Event>

	var body: some View {
		Text("Hello from Settings!")
	}
}