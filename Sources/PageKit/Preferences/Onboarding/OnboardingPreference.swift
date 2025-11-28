//
//  OnboardingPreference.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

// MARK: - OnboardingPreferenceKey

public struct OnboardingPreferenceKey: PreferenceKey {
	public static var defaultValue: Onboarding?

	public static func reduce(value: inout Onboarding?, nextValue: () -> Onboarding?) {
		// Always accept the topmost setting of onboarding
		if value == nil {
			value = nextValue()
		}
	}
}

extension View {
	public func onboarding(
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
