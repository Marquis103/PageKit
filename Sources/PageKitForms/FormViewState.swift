//
//  FormViewState.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Combine
import Foundation
import SwiftUI
import PageKit

/// Base class for form view states with built-in validation support.
///
/// FormViewState provides infrastructure for managing form validation state,
/// field-level errors, and submission state. Subclass this for any form-based page.
///
/// Example:
/// ```swift
/// class LoginFormViewState: FormViewState {
///     var email = ""
///     var password = ""
///
///     override func validate() -> Bool {
///         validateField("email", value: email, validators: [.required, .email])
///         validateField("password", value: password, validators: [.required, .minLength(6)])
///         return isValid
///     }
/// }
/// ```
open class FormViewState: PageViewState {
	/// Whether the entire form is valid
	public private(set) var isValid: Bool = false

	/// Field-level validation errors (key: field name, value: error message)
	public private(set) var errors: [String: String] = [:]

	/// Whether the form is currently being submitted
	public var isSubmitting: Bool = false

	/// Whether the form has been modified by the user
	public var isDirty: Bool = false

	/// Form-level error message (e.g., API error)
	public var formError: String?

	// MARK: - FormField Support

	/// Auto-discovers all FormField properties via reflection.
	///
	/// This property uses Mirror to find all FormFieldObservable properties
	/// on the view state, including fields in arrays.
	public var fields: [FormFieldObservable] {
		let mirror = Mirror(reflecting: self)
		var allFields: [FormFieldObservable] = []

		for child in mirror.children {
			// Handle individual FormFieldObservable properties
			if let field = child.value as? FormFieldObservable {
				allFields.append(field)
			}
			// Handle array properties
			else if let array = child.value as? [Any] {
				for element in array {
					if let field = element as? FormFieldObservable {
						allFields.append(field)
					}
				}
			}
		}

		return allFields
	}

	/// Whether all FormField properties are valid.
	///
	/// Returns true only when every discovered FormField passes validation.
	public var validated: Bool {
		fields.allSatisfy(\.isValid)
	}

	// MARK: - Field Observers

	/// Cancellables for single field observers (set once)
	private var singleFieldCancellables = Set<AnyCancellable>()

	/// Cancellables for array field observers (can be refreshed)
	private var arrayFieldCancellables = Set<AnyCancellable>()

	public override init() {
		super.init()
		observeFields()
	}

	/// Refreshes array field observers after dynamically modifying array properties.
	public func refreshFieldObservers() {
		refreshArrayFieldObservers()
	}

	private func observeFields() {
		let mirror = Mirror(reflecting: self)

		for child in mirror.children {
			if let field = child.value as? FormFieldObservable {
				let publisher: ObservableObjectPublisher = field.objectWillChange
				publisher
					.sink { [weak self] _ in
						self?.objectWillChange.send()
					}
					.store(in: &singleFieldCancellables)
			} else if let array = child.value as? [Any] {
				observeArrayFields(array)
			}
		}
	}

	private func observeArrayFields(_ array: [Any]) {
		for element in array {
			if let field = element as? FormFieldObservable {
				let publisher: ObservableObjectPublisher = field.objectWillChange
				publisher
					.sink { [weak self] _ in
						self?.objectWillChange.send()
					}
					.store(in: &arrayFieldCancellables)
			}
		}
	}

	private func refreshArrayFieldObservers() {
		arrayFieldCancellables.removeAll()

		let mirror = Mirror(reflecting: self)
		for child in mirror.children {
			if let array = child.value as? [Any] {
				observeArrayFields(array)
			}
		}
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
	open func validate() -> Bool {
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
	public func validateField<Value>(
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
	public func errorForField(_ field: String) -> String? {
		errors[field]
	}

	/// Check if a specific field has an error.
	///
	/// - Parameter field: The field name
	/// - Returns: True if the field has an error, false otherwise
	public func hasError(for field: String) -> Bool {
		errors[field] != nil
	}

	// MARK: - Form State Management

	/// Clear all validation errors
	public func clearErrors() {
		errors.removeAll()
		formError = nil
		isValid = validate()
	}

	/// Clear a specific field's error
	///
	/// - Parameter field: The field name
	public func clearError(for field: String) {
		errors.removeValue(forKey: field)
		isValid = errors.isEmpty
	}

	/// Set a field error manually
	///
	/// - Parameters:
	///   - field: The field name
	///   - error: The error message
	public func setError(for field: String, error: String) {
		errors[field] = error
		isValid = false
	}

	/// Reset the form to its initial state
	public func reset() {
		errors.removeAll()
		formError = nil
		isSubmitting = false
		isDirty = false
		isValid = false
	}

	// MARK: - Submission State

	/// Begin form submission (sets isSubmitting = true)
	public func beginSubmission() {
		isSubmitting = true
		formError = nil
	}

	/// End form submission (sets isSubmitting = false)
	public func endSubmission() {
		isSubmitting = false
	}

	/// Handle submission error
	///
	/// - Parameter error: The error that occurred
	public func handleSubmissionError(_ error: Error) {
		isSubmitting = false
		formError = error.localizedDescription
	}
}
