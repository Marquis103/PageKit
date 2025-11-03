//
//  ConfigurableView.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation

protocol ConfigurableView<Configuration>: ModuleView where State: ConfigurableViewState<Configuration> {
	associatedtype Configuration: ModuleConfiguration
}
