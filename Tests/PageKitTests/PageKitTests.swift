//
//  PageKitTests.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import XCTest
@testable import PageKit

// @MainActor since 2.0.0: PageViewState lives in PageKitCore now, and
// cross-module access enforces its MainActor isolation.
@MainActor
final class PageKitTests: XCTestCase {
	func testPageViewStateInit() {
		let viewState = PageViewState()
		XCTAssertFalse(viewState.isRefreshing)
	}
}
