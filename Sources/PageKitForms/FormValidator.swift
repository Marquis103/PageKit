//
//  FormValidator.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation
import UIKit

/// A validator that validates a value and returns an error message if invalid.
public struct FormValidator<Value> {
	private let validation: (Value) -> String?

	/// Create a custom validator.
	///
	/// - Parameter validation: A closure that takes a value and returns an error message if invalid, or nil if valid
	public init(validation: @escaping (Value) -> String?) {
		self.validation = validation
	}

	/// Validate a value.
	///
	/// - Parameter value: The value to validate
	/// - Returns: An error message if invalid, or nil if valid
	public func validate(_ value: Value) -> String? {
		validation(value)
	}
}

// MARK: - Built-in Validators

extension FormValidator where Value == String {
	/// Validator that requires a non-empty string
	public static var required: FormValidator<String> {
		FormValidator { value in
			value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
				? "This field is required"
				: nil
		}
	}

	/// Validator that requires a valid email address
	public static var email: FormValidator<String> {
		FormValidator { value in
			let emailRegex = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
			let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
			return emailPredicate.evaluate(with: value)
				? nil
				: "Please enter a valid email address"
		}
	}

	/// Validator that requires a minimum string length
	///
	/// - Parameter length: The minimum required length
	/// - Returns: A validator
	public static func minLength(_ length: Int) -> FormValidator<String> {
		FormValidator { value in
			value.count >= length
				? nil
				: "Must be at least \(length) characters"
		}
	}

	/// Validator that requires a maximum string length
	///
	/// - Parameter length: The maximum allowed length
	/// - Returns: A validator
	public static func maxLength(_ length: Int) -> FormValidator<String> {
		FormValidator { value in
			value.count <= length
				? nil
				: "Must be no more than \(length) characters"
		}
	}

	/// Validator that requires a specific string length
	///
	/// - Parameter length: The exact required length
	/// - Returns: A validator
	public static func exactLength(_ length: Int) -> FormValidator<String> {
		FormValidator { value in
			value.count == length
				? nil
				: "Must be exactly \(length) characters"
		}
	}

	/// Validator that requires the string to match a regular expression
	///
	/// - Parameters:
	///   - pattern: The regex pattern
	///   - message: Custom error message
	/// - Returns: A validator
	public static func regex(_ pattern: String, message: String = "Invalid format") -> FormValidator<String> {
		FormValidator { value in
			let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
			return predicate.evaluate(with: value) ? nil : message
		}
	}

	/// Validator that requires the string to contain at least one uppercase letter
	public static var containsUppercase: FormValidator<String> {
		regex("[A-Z]", message: "Must contain at least one uppercase letter")
	}

	/// Validator that requires the string to contain at least one lowercase letter
	public static var containsLowercase: FormValidator<String> {
		regex("[a-z]", message: "Must contain at least one lowercase letter")
	}

	/// Validator that requires the string to contain at least one number
	public static var containsNumber: FormValidator<String> {
		regex("[0-9]", message: "Must contain at least one number")
	}

	/// Validator that requires the string to contain at least one special character
	public static var containsSpecialCharacter: FormValidator<String> {
		regex("[^A-Za-z0-9]", message: "Must contain at least one special character")
	}

	/// Validator that requires a valid US phone number
	public static var phoneNumber: FormValidator<String> {
		FormValidator { value in
			let cleaned = value.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
			return cleaned.count == 10 || cleaned.count == 11
				? nil
				: "Please enter a valid phone number"
		}
	}

	/// Validator that requires a valid URL
	public static var url: FormValidator<String> {
		FormValidator { value in
			guard let url = URL(string: value),
			      UIApplication.shared.canOpenURL(url) else {
				return "Please enter a valid URL"
			}
			return nil
		}
	}
}

extension FormValidator where Value: Comparable {
	/// Validator that requires a minimum value
	///
	/// - Parameter minimum: The minimum allowed value
	/// - Returns: A validator
	public static func min(_ minimum: Value) -> FormValidator<Value> {
		FormValidator { value in
			value >= minimum
				? nil
				: "Must be at least \(minimum)"
		}
	}

	/// Validator that requires a maximum value
	///
	/// - Parameter maximum: The maximum allowed value
	/// - Returns: A validator
	public static func max(_ maximum: Value) -> FormValidator<Value> {
		FormValidator { value in
			value <= maximum
				? nil
				: "Must be no more than \(maximum)"
		}
	}

	/// Validator that requires a value within a range
	///
	/// - Parameters:
	///   - minimum: The minimum allowed value
	///   - maximum: The maximum allowed value
	/// - Returns: A validator
	public static func range(_ minimum: Value, _ maximum: Value) -> FormValidator<Value> {
		FormValidator { value in
			value >= minimum && value <= maximum
				? nil
				: "Must be between \(minimum) and \(maximum)"
		}
	}
}

// MARK: - Validator Composition

extension FormValidator {
	/// Compose multiple validators into a single validator.
	/// Returns the first error encountered, or nil if all validators pass.
	///
	/// - Parameter validators: Array of validators to compose
	/// - Returns: A single validator that runs all validators
	public static func compose(_ validators: [FormValidator<Value>]) -> FormValidator<Value> {
		FormValidator { value in
			for validator in validators {
				if let error = validator.validate(value) {
					return error
				}
			}
			return nil
		}
	}

	/// Combine this validator with another validator.
	///
	/// - Parameter other: Another validator
	/// - Returns: A composed validator
	public func and(_ other: FormValidator<Value>) -> FormValidator<Value> {
		FormValidator { value in
			if let error = self.validate(value) {
				return error
			}
			return other.validate(value)
		}
	}

	/// Create a validator that passes if either this or the other validator passes.
	///
	/// - Parameter other: Another validator
	/// - Returns: A composed validator
	public func or(_ other: FormValidator<Value>) -> FormValidator<Value> {
		FormValidator { value in
			let error1 = self.validate(value)
			let error2 = other.validate(value)

			// If either passes, return nil
			if error1 == nil || error2 == nil {
				return nil
			}

			// Both failed, return the first error
			return error1
		}
	}
}

// MARK: - Optional Validators

extension FormValidator {
	/// Make this validator optional (allows nil values)
	///
	/// - Returns: A validator that passes if the value is nil or passes this validator
	public func optional() -> FormValidator<Value?> {
		FormValidator<Value?> { optionalValue in
			guard let value = optionalValue else {
				return nil // nil is valid
			}
			return self.validate(value)
		}
	}
}
