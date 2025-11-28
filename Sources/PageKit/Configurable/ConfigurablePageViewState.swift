//
//  ConfigurablePageViewState.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation

open class ConfigurablePageViewState<C: PageConfiguration>: PageViewState {
	public let configuration: C

	public init(configuration: C) {
		self.configuration = configuration
	}
}
