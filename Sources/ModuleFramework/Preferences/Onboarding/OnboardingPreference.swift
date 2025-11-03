//
//  OnboardingPreference.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

// MARK: - OnboardingPreferenceKey

struct OnboardingPreferenceKey: PreferenceKey {
	static var defaultValue: Onboarding?

	static func reduce(value: inout Onboarding?, nextValue: () -> Onboarding?) {
		// Always accept the topmost setting of onboarding
		if value == nil {
			value = nextValue()
		}
	}
}

extension View {
	func onboarding(
		title: String? = nil,
		message: String? = nil,
		action: String,
		onAction: @escaping () -> Void
	) -> some View {
		preference(
			key: OnboardingPreferenceKey.self,
			value: Onboarding(
				title: title,
				message: message,
				action: action,
				onAction: onAction
			)
		)
	}
}
