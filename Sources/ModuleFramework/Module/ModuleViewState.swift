//
//  ModuleViewState.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation
import SwiftUI

class ModuleViewState: ObservableObject {
	@Published
	var isRefreshing = false

	// Note: viewMode property removed - it used TheCut's DI container and ViewMode type
	// Implement your own viewMode property in your app if needed
}
