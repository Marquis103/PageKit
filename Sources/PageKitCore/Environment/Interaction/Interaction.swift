// PE-536/E4 spike/android: ObservableObject/@Published are Combine-semantic — unavailable in Fuse-native; @Observable variant.
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
