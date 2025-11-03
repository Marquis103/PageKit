//
//  Interaction.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation

class Interaction: ObservableObject {
	@Published
	var disabled: Bool

	init(disabled: Bool) {
		self.disabled = disabled
	}
}
