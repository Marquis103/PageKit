//
//  Module.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation

// MARK: - Module

protocol Module {
	associatedtype Action: CoordinatableAction
	associatedtype Signal = Void

	associatedtype ViewModel: ModuleViewModel<Self>
	associatedtype ViewState: ModuleViewState
	associatedtype View: ModuleView

	var coordinator: Coordinating { get }
	var viewModel: ViewModel { get }
	var viewState: ViewState { get }
	var view: View { get }
}
