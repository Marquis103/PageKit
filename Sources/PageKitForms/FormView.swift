//
//  FormView.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI
import PageKit

// MARK: - FormView

/// Protocol for views that contain forms.
///
/// FormView extends PageView with form-specific functionality like
/// keyboard dismissal and validate-and-submit flow.
///
/// Example:
/// ```swift
/// struct LoginPageView: FormView {
///     var viewState: LoginPageViewState
///     let handler: FormViewEventHandler<Event>
///
///     var body: some View {
///         VStack {
///             TextField("Email", text: $viewState.email.value)
///             SecureField("Password", text: $viewState.password.value)
///
///             Button("Login") {
///                 validateAndSubmit()
///             }
///         }
///     }
/// }
/// ```
public protocol FormView: PageView where State: FormViewState {
	associatedtype Event

	var handler: FormViewEventHandler<Event> { get }
}

// MARK: - FormView Extension

extension FormView {
	/// Validates all form fields and submits if valid.
	///
	/// This method dismisses the keyboard and validates/submits via the handler.
	/// The handler internally handles keyboard dismissal and ViewModel validation.
	///
	/// Use this from submit buttons:
	/// ```swift
	/// Button("Submit") {
	///     validateAndSubmit()
	/// }
	/// ```
	public func validateAndSubmit() {
		handler.validateAndSubmit()
	}
}
