//
//  ConfigurableModule.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation

// MARK: - ModuleConfiguration

protocol ModuleConfiguration {
	associatedtype Action: CoordinatableAction

	// Note: theme property removed - it used TheCut's DI container
	// Access theme via @Environment(\.theme) in your views instead
}

// MARK: - ConfigurableModule

protocol ConfigurableModule<Configuration>: Module {
	associatedtype Configuration: ModuleConfiguration

	var configuration: Configuration { get }
}
