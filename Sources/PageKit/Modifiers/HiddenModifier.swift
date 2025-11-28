//
//  HiddenModifier.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

extension View {
	public func hidden(_ hide: Bool) -> some View {
		self.if(hide) { $0.hidden() }
	}
}
