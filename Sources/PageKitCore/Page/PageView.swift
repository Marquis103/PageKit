//
//  PageView.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

// MARK: - PageView

public protocol PageView: View {
	associatedtype State: PageViewState
	associatedtype Event = Void

	var viewState: State { get }
}
