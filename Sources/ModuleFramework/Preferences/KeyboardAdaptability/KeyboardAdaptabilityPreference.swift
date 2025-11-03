//
//  KeyboardAdaptabilityPreference.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

// MARK: - KeyboardAdaptabilityPreferenceKey

struct KeyboardAdaptabilityPreferenceKey: PreferenceKey {
	static var defaultValue: KeyboardAdaptability?

	static func reduce(value: inout KeyboardAdaptability?, nextValue: () -> KeyboardAdaptability?) {
		guard let current = value else {
			value = nextValue()
			return
		}

		guard let next = nextValue() else {
			return
		}

		let preventResizing = current.preventResizing || next.preventResizing
		let preventShifting = current.preventShifting || next.preventShifting
		let preventDismissOnTap = current.preventDismissOnTap || next.preventDismissOnTap

		value = KeyboardAdaptability(
			preventResizing: preventResizing,
			preventShifting: preventShifting,
			preventDismissOnTap: preventDismissOnTap
		)
	}
}

extension View {
	func keyboardAdaptability(
		preventResizing: Bool = false,
		preventShifting: Bool = false,
		preventDismissOnTap: Bool = false
	) -> some View {
		preference(
			key: KeyboardAdaptabilityPreferenceKey.self,
			value: KeyboardAdaptability(
				preventResizing: preventResizing,
				preventShifting: preventShifting,
				preventDismissOnTap: preventDismissOnTap
			)
		)
	}
}
