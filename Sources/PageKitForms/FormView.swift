//
//  FormView.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI
import PageKit

#if canImport(UIKit)
import UIKit
#endif

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
	/// This method:
	/// 1. Dismisses the keyboard (resignFirstResponder)
	/// 2. Calls the handler's validateAndSubmit()
	///
	/// Use this from submit buttons:
	/// ```swift
	/// Button("Submit") {
	///     validateAndSubmit()
	/// }
	/// ```
	public func validateAndSubmit() {
		resignFirstResponder()
		handler.validateAndSubmit()
	}

	/// Dismisses the keyboard by resigning the first responder.
	private func resignFirstResponder() {
		#if canImport(UIKit)
		DispatchQueue.main.async {
			UIApplication.shared.sendAction(
				#selector(UIResponder.resignFirstResponder),
				to: nil,
				from: nil,
				for: nil
			)
		}
		#endif
	}
}
