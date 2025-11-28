//
//  ConfigurablePageView.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation

public protocol ConfigurablePageView<Configuration>: PageView where State: ConfigurablePageViewState<Configuration> {
	associatedtype Configuration: PageConfiguration
}
