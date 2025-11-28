//
//  Interaction.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation

public class Interaction: ObservableObject {
	@Published
	public var disabled: Bool

	public init(disabled: Bool) {
		self.disabled = disabled
	}
}
