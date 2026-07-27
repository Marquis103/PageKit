//
//  RewinderEnvironment.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

// MARK: - RewinderEnvironmentKey

private struct RewinderEnvironmentKey: EnvironmentKey {
	static let defaultValue: Rewinder = .init(rewindStyle: nil, rewind: nil)
}

extension EnvironmentValues {
	public var rewinder: Rewinder {
		get { self[RewinderEnvironmentKey.self] }
		set { self[RewinderEnvironmentKey.self] = newValue }
	}
}
