//
//  ConfigurablePageContent.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation

public protocol ConfigurablePageContent<Configuration>: PageContent where State: ConfigurablePageViewState<Configuration> {
	associatedtype Configuration: PageConfiguration
}
