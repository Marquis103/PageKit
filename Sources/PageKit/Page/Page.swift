//
//  Page.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation

// MARK: - Page

public protocol Page {
	associatedtype Action: CoordinatableAction
	associatedtype Signal = Void

	associatedtype ViewModel: PageViewModel<Self>
	associatedtype ViewState: PageViewState
	associatedtype View: PageView

	var coordinator: Coordinating { get }
	var viewModel: ViewModel { get }
	var viewState: ViewState { get }
	var view: View { get }
}
