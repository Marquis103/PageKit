//
//  Page.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation

// MARK: - Page

public protocol Page {
	associatedtype Action: CoordinatableAction
	associatedtype Signal = Void

	associatedtype ViewModel: PageViewModel<Self>
	associatedtype ViewState: PageViewState
	associatedtype Content: PageContent

	var coordinator: Coordinating { get }
	var viewModel: ViewModel { get }
	var viewState: ViewState { get }
	var content: Content { get }
}
