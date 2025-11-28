//
//  InteractionEnvironment.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

// MARK: - InteractionEnvironmentKey

private struct InteractionEnvironmentKey: EnvironmentKey {
	static let defaultValue: Interaction = .init(disabled: false)
}

extension EnvironmentValues {
	public var interaction: Interaction {
		get { self[InteractionEnvironmentKey.self] }
		set { self[InteractionEnvironmentKey.self] = newValue }
	}
}
