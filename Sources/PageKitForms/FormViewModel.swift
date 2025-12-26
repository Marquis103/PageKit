//
//  FormViewModel.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation
import PageKit

// MARK: - FormViewModelable

/// Protocol for view models that support form validation and submission.
///
/// This protocol defines the contract for form view models, enabling
/// FormPage to use a protocol constraint instead of a class constraint.
public protocol FormViewModelable: PageViewModelProtocol {
	func validateAndSubmit()
}

// MARK: - FormViewModel

/// Base class for form-specific view models.
///
/// FormViewModel extends PageViewModel with form-specific functionality
/// such as validation and submission.
///
/// Example:
/// ```swift
/// final class LoginFormViewModel: FormViewModel<LoginFormPage>, FormViewEventHandlable {
///     override func submit() async {
///         formViewState.beginSubmission()
///         do {
///             let credentials = (email: viewState.email.value, password: viewState.password.value)
///             let user = try await authService.login(credentials)
///             formViewState.endSubmission()
///             coordinate(action: .loginSuccess(user))
///         } catch {
///             formViewState.handleSubmissionError(error)
///         }
///     }
/// }
/// ```
open class FormViewModel<P: Page>: PageViewModel<P>, FormViewModelable, FormViewEventHandlable where P.ViewState: FormViewState {
	/// Typed access to the form view state
	public var formViewState: P.ViewState {
		viewState
	}

	// MARK: - FormViewEventHandlable

	/// Validates all FormField properties then submits if valid.
	///
	/// This method:
	/// 1. Iterates through all FormField properties on the view state
	/// 2. Calls `.validate()` on each field
	/// 3. If all fields are valid, calls `submit()`
	public final func validateAndSubmit() {
		Task {
			await MainActor.run {
				for field in viewState.fields {
					field.validate()
				}
			}

			await MainActor.run {
				if viewState.validated {
					Task {
						await submit()
					}
				}
			}
		}
	}

	// MARK: - Form Submission

	/// Submit the form. Override this method to implement submission logic.
	///
	/// This method is called when all fields are valid. Override in subclass
	/// to implement your submission logic.
	///
	/// Example:
	/// ```swift
	/// override func submit() async {
	///     formViewState.beginSubmission()
	///     do {
	///         try await authService.login(email: viewState.email.value, password: viewState.password.value)
	///         formViewState.endSubmission()
	///         coordinate(action: .loginSuccess)
	///     } catch {
	///         formViewState.handleSubmissionError(error)
	///     }
	/// }
	/// ```
	open func submit() async {
		// Override in subclass to implement submission logic
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
