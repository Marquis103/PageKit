//
//  PageKitUITests.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import XCTest
@testable import PageKitUI
@testable import PageKitTheming

final class PageKitUITests: XCTestCase {
	func testTextSizeResolution() {
		let theme = DefaultTheme.light
		let anyTheme = AnyTheme(theme)

		let size = TextSize.medium.resolve(from: anyTheme)
		XCTAssertGreaterThan(size, 0)
	}
}
