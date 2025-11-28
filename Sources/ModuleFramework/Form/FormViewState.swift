//
//  FormViewState.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation
import SwiftUI

/// Base class for form view states with built-in validation support.
///
/// FormViewState provides infrastructure for managing form validation state,
/// field-level errors, and submission state. Subclass this for any form-based module.
///
/// Example:
/// ```swift
/// class LoginFormViewState: FormViewState {
///     @Published var email = ""
///     @Published var password = ""
///
///     override func validate() -> Bool {
///         validateField("email", value: email, validators: [.required, .email])
///         validateField("password", value: password, validators: [.required, .minLength(6)])
///         return isValid
///     }
/// }
/// ```
class FormViewState: ModuleViewState {
	/// Whether the entire form is valid
	@Published private(set) var isValid: Bool = false

	/// Field-level validation errors (key: field name, value: error message)
	@Published private(set) var errors: [String: String] = [:]

	/// Whether the form is currently being submitted
	@Published var isSubmitting: Bool = false

	/// Whether the form has been modified by the user
	@Published var isDirty: Bool = false

	/// Form-level error message (e.g., API error)
	@Published var formError: String?

	override init() {
		super.init()
	}

	// MARK: - Validation

	/// Validate the entire form. Override this method in subclasses.
	///
	/// Example:
	/// ```swift
	/// override func validate() -> Bool {
	///     validateField("email", value: email, validators: [.required, .email])
	///     validateField("password", value: password, validators: [.required, .minLength(6)])
	///     return isValid
	/// }
	/// ```
	///
	/// - Returns: True if the form is valid, false otherwise
	@discardableResult
	func validate() -> Bool {
		// Override in subclasses
		isValid = errors.isEmpty
		return isValid
	}

	/// Validate a single field with the given validators.
	///
	/// - Parameters:
	///   - field: The field name (used as key for error messages)
	///   - value: The field value to validate
	///   - validators: Array of validators to apply
	/// - Returns: True if the field is valid, false otherwise
	@discardableResult
	func validateField<Value>(
		_ field: String,
		value: Value,
		validators: [FormValidator<Value>]
	) -> Bool {
		// Run all validators
		for validator in validators {
			if let error = validator.validate(value) {
				errors[field] = error
				isValid = false
				return false
			}
		}

		// Field is valid - remove any existing error
		errors.removeValue(forKey: field)

		// Revalidate form
		isValid = errors.isEmpty
		return true
	}

	/// Get the error message for a specific field.
	///
	/// - Parameter field: The field name
	/// - Returns: The error message, or nil if the field is valid
	func errorForField(_ field: String) -> String? {
		errors[field]
	}

	/// Check if a specific field has an error.
	///
	/// - Parameter field: The field name
	/// - Returns: True if the field has an error, false otherwise
	func hasError(for field: String) -> Bool {
		errors[field] != nil
	}

	// MARK: - Form State Management

	/// Clear all validation errors
	func clearErrors() {
		errors.removeAll()
		formError = nil
		isValid = validate()
	}

	/// Clear a specific field's error
	///
	/// - Parameter field: The field name
	func clearError(for field: String) {
		errors.removeValue(forKey: field)
		isValid = errors.isEmpty
	}

	/// Set a field error manually
	///
	/// - Parameters:
	///   - field: The field name
	///   - error: The error message
	func setError(for field: String, error: String) {
		errors[field] = error
		isValid = false
	}

	/// Reset the form to its initial state
	func reset() {
		errors.removeAll()
		formError = nil
		isSubmitting = false
		isDirty = false
		isValid = false
	}

	// MARK: - Submission State

	/// Begin form submission (sets isSubmitting = true)
	func beginSubmission() {
		isSubmitting = true
		formError = nil
	}

	/// End form submission (sets isSubmitting = false)
	func endSubmission() {
		isSubmitting = false
	}

	/// Handle submission error
	///
	/// - Parameter error: The error that occurred
	func handleSubmissionError(_ error: Error) {
		isSubmitting = false
		formError = error.localizedDescription
	}
}
