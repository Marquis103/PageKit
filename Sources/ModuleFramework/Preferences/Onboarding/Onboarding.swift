//
//  Onboarding.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

struct Onboarding: Equatable {
	private(set) var title: String?
	private(set) var message: String?
	let action: String
	let onAction: () -> Void

	static func == (lhs: Onboarding, rhs: Onboarding) -> Bool {
		lhs.title == rhs.title
			&& lhs.message == rhs.message
			&& lhs.action == rhs.action
	}
}
