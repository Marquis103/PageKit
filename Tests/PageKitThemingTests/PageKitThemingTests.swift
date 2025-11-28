//
//  PageKitThemingTests.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import XCTest
@testable import PageKitTheming

final class PageKitThemingTests: XCTestCase {
	func testDefaultThemeCreation() {
		let theme = DefaultTheme.light
		XCTAssertNotNil(theme.colors)
		XCTAssertNotNil(theme.buttons)
		XCTAssertNotNil(theme.sizing)
		XCTAssertNotNil(theme.spacing)
		XCTAssertNotNil(theme.typography)
	}
}
