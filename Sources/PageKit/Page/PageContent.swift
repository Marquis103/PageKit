//
//  PageContent.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

// MARK: - PageContent

public protocol PageContent: View {
	associatedtype State: PageViewState
	associatedtype Event = Void

	var viewState: State { get }
}
