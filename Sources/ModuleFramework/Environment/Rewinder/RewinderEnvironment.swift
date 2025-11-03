//
//  RewinderEnvironment.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

// MARK: - RewinderEnvironmentKey

private struct RewinderEnvironmentKey: EnvironmentKey {
	static let defaultValue: Rewinder = .init(rewindStyle: nil, rewind: nil)
}

extension EnvironmentValues {
	var rewinder: Rewinder {
		get { self[RewinderEnvironmentKey.self] }
		set { self[RewinderEnvironmentKey.self] = newValue }
	}
}
