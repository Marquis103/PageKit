//
//  OnSizeChangeModifier.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

extension View {
	public func onSizeChange(_ perform: @escaping (CGSize) -> Void) -> some View {
		overlay(
			GeometryReader { geo in
				Color.clear
					.onAppear {
						perform(geo.frame(in: .global).size)
					}
					.onChange(of: geo.size) { _ in
						perform(geo.frame(in: .global).size)
					}
			}
		)
	}
}
