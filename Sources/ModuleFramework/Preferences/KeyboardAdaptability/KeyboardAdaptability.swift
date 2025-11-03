//
//  KeyboardAdaptability.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation

struct KeyboardAdaptability: Equatable {
	/// Prevent SwiftUI from resizing the view when the keyboard is shown
	private(set) var preventResizing: Bool = false

	/// Prevent SwiftUI from shifting the view up when the keyboard is shown
	private(set) var preventShifting: Bool = false

	private(set) var preventDismissOnTap: Bool = false
}
