//
//  HiddenModifier.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

extension View {
	func hidden(_ hide: Bool) -> some View {
		self.if(hide) { $0.hidden() }
	}
}
