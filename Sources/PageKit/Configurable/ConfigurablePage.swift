//
//  ConfigurablePage.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation

// MARK: - PageConfiguration

public protocol PageConfiguration {
	associatedtype Action: CoordinatableAction
}

// MARK: - ConfigurablePage

public protocol ConfigurablePage<Configuration>: Page {
	associatedtype Configuration: PageConfiguration

	var configuration: Configuration { get }
}
