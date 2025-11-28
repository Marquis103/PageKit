//
//  PageKitFormsTests.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import XCTest
@testable import PageKitForms

final class PageKitFormsTests: XCTestCase {
	func testFormValidatorRequired() {
		let validator = FormValidator<String>.required

		XCTAssertNotNil(validator.validate(""))
		XCTAssertNotNil(validator.validate("   "))
		XCTAssertNil(validator.validate("hello"))
	}

	func testFormValidatorEmail() {
		let validator = FormValidator<String>.email

		XCTAssertNotNil(validator.validate("invalid"))
		XCTAssertNotNil(validator.validate("invalid@"))
		XCTAssertNil(validator.validate("valid@example.com"))
	}
}
