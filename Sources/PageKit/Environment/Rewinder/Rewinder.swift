//
//  Rewinder.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

public struct Rewinder {
	public let rewindStyle: RewindStyle?
	public let rewind: (() -> Void)?

	public init(rewindStyle: RewindStyle?, rewind: (() -> Void)?) {
		self.rewindStyle = rewindStyle
		self.rewind = rewind
	}
}
