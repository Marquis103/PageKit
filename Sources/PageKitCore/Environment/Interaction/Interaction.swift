// ObservableObject/@Published are Combine-semantic and do not exist under Skip
// Fuse (E4-F3). Android uses the @Observable variant below — same API, same
// storage; keep the two declarations in sync.
#if !os(Android)
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

#else
import Foundation
import Observation

@Observable
public class Interaction {
	public var disabled: Bool

	public init(disabled: Bool) {
		self.disabled = disabled
	}
}
#endif
