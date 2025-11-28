//
//  KeyboardAdaptability.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation

public struct KeyboardAdaptability: Equatable {
	/// Prevent SwiftUI from resizing the view when the keyboard is shown
	public private(set) var preventResizing: Bool = false

	/// Prevent SwiftUI from shifting the view up when the keyboard is shown
	public private(set) var preventShifting: Bool = false

	public private(set) var preventDismissOnTap: Bool = false

	public init(
		preventResizing: Bool = false,
		preventShifting: Bool = false,
		preventDismissOnTap: Bool = false
	) {
		self.preventResizing = preventResizing
		self.preventShifting = preventShifting
		self.preventDismissOnTap = preventDismissOnTap
	}
}
