//
//  FormViewModel.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation
import PageKit

/// Protocol for form-specific view models.
///
/// FormViewModel extends PageViewModel with form-specific functionality
/// such as submission and validation.
///
/// Example:
/// ```swift
/// class LoginFormViewModel: FormViewModel<LoginFormPage> {
///     override func submit() async throws {
///         let credentials = (email: viewState.email, password: viewState.password)
///         try await authService.login(credentials)
///     }
/// }
/// ```
open class FormViewModel<P: Page>: PageViewModel<P> where P.ViewState: FormViewState {
	/// Typed access to the form view state
	public var formViewState: P.ViewState {
		viewState
	}

	// MARK: - Form Submission

	/// Submit the form. Override this method to implement submission logic.
	///
	/// This method is called when the user submits the form. It should:
	/// 1. Validate the form
	/// 2. Call the API or perform the submission action
	/// 3. Handle success/failure
	///
	/// The base implementation validates the form and throws an error if invalid.
	///
	/// Example:
	/// ```swift
	/// override func submit() async throws {
	///     let credentials = (
	///         email: formViewState.email,
	///         password: formViewState.password
	///     )
	///     try await authService.login(credentials)
	///     coordinator.send(action: .loginSuccess)
	/// }
	/// ```
	open func submit() async throws {
		// Validate before submitting
		guard formViewState.validate() else {
			throw FormError.validationFailed
		}

		// Override in subclass to implement submission logic
	}

	/// Handle form submission with automatic state management.
	///
	/// This is a convenience method that:
	/// 1. Sets `isSubmitting = true`
	/// 2. Calls your `submit()` implementation
	/// 3. Sets `isSubmitting = false` when done
	/// 4. Handles errors by setting `formError`
	///
	/// Use this from your view's submit button:
	/// ```swift
	/// FormSubmitButton("Login") {
	///     await viewModel.handleSubmit()
	/// }
	/// ```
	public func handleSubmit() async {
		formViewState.beginSubmission()

		do {
			try await submit()
			formViewState.endSubmission()
		} catch {
			formViewState.handleSubmissionError(error)
		}
	}

	// MARK: - Validation

	/// Validate the entire form.
	///
	/// - Returns: True if the form is valid, false otherwise
	@discardableResult
	public func validate() -> Bool {
		formViewState.validate()
	}

	/// Validate a single field.
	///
	/// - Parameter field: The field name
	/// - Returns: True if the field is valid, false otherwise
	@discardableResult
	open func validateField(_ field: String) -> Bool {
		// Subclasses can override to implement field-specific validation
		formViewState.validate()
	}
}

// MARK: - Form Errors

/// Errors that can occur during form operations
public enum FormError: LocalizedError {
	case validationFailed
	case submissionFailed(String)
	case networkError
	case unknown

	public var errorDescription: String? {
		switch self {
		case .validationFailed:
			"Please fix the errors above"
		case .submissionFailed(let message):
			message
		case .networkError:
			"Network error. Please check your connection and try again."
		case .unknown:
			"An unknown error occurred. Please try again."
		}
	}
}
