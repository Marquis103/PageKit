//
//  PageKitTests.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import XCTest
@testable import PageKit

final class PageKitTests: XCTestCase {
	func testPageViewStateInit() {
		let viewState = PageViewState()
		XCTAssertFalse(viewState.isRefreshing)
	}
}
