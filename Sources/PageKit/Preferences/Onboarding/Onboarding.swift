//
//  Onboarding.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

public struct Onboarding: Equatable {
	public private(set) var title: String?
	public private(set) var message: String?
	public let action: String
	public let onAction: () -> Void

	public init(
		title: String? = nil,
		message: String? = nil,
		action: String,
		onAction: @escaping () -> Void
	) {
		self.title = title
		self.message = message
		self.action = action
		self.onAction = onAction
	}

	public static func == (lhs: Onboarding, rhs: Onboarding) -> Bool {
		lhs.title == rhs.title
			&& lhs.message == rhs.message
			&& lhs.action == rhs.action
	}
}
