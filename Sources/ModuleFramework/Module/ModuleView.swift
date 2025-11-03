//
//  ModuleView.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

// MARK: - ModuleView

protocol ModuleView: View {
	associatedtype State: ModuleViewState
	associatedtype Event = Void

	var viewState: State { get }
}
