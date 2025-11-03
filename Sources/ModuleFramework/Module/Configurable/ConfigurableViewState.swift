//
//  ConfigurableViewState.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation

class ConfigurableViewState<C: ModuleConfiguration>: ModuleViewState {
	let configuration: C

	init(configuration: C) {
		self.configuration = configuration
	}
}
