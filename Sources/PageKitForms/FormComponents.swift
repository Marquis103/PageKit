//
//  FormComponents.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

// MARK: - FormField

/// A text field with built-in validation support.
///
/// Example:
/// ```swift
/// FormField(
///     "Email",
///     text: $viewState.email,
///     validators: [.required, .email]
/// )
/// ```
public struct FormField: View {
	private let title: String
	@Binding private var text: String
	private let placeholder: String
	private let validators: [FormValidator<String>]
	private let isSecure: Bool
	private let keyboardType: UIKeyboardType
	private let autocapitalization: TextInputAutocapitalization
	private let autocorrection: Bool

	@State private var error: String?
	@State private var isFocused: Bool = false

	public init(
		_ title: String,
		text: Binding<String>,
		placeholder: String? = nil,
		validators: [FormValidator<String>] = [],
		isSecure: Bool = false,
		keyboardType: UIKeyboardType = .default,
		autocapitalization: TextInputAutocapitalization = .sentences,
		autocorrection: Bool = true
	) {
		self.title = title
		self._text = text
		self.placeholder = placeholder ?? title
		self.validators = validators
		self.isSecure = isSecure
		self.keyboardType = keyboardType
		self.autocapitalization = autocapitalization
		self.autocorrection = autocorrection
	}

	public var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			if isSecure {
				SecureField(placeholder, text: $text)
					.textFieldStyle(.roundedBorder)
					.keyboardType(keyboardType)
					.textInputAutocapitalization(autocapitalization)
					.onChange(of: text) { newValue in
						validateText(newValue)
					}
			} else {
				TextField(placeholder, text: $text)
					.textFieldStyle(.roundedBorder)
					.keyboardType(keyboardType)
					.textInputAutocapitalization(autocapitalization)
					.autocorrectionDisabled(!autocorrection)
					.onChange(of: text) { newValue in
						validateText(newValue)
					}
			}

			if let error = error, !error.isEmpty {
				Text(error)
					.font(.caption)
					.foregroundColor(.red)
			}
		}
	}

	private func validateText(_ value: String) {
		// Run validators
		for validator in validators {
			if let validationError = validator.validate(value) {
				error = validationError
				return
			}
		}
		error = nil
	}
}

// MARK: - FormSubmitButton

/// A button that automatically disables when the form is invalid or submitting.
///
/// Example:
/// ```swift
/// FormSubmitButton("Login") {
///     await viewModel.handleSubmit()
/// }
/// .environmentObject(viewState)
/// ```
public struct FormSubmitButton<Label: View>: View {
	@EnvironmentObject private var formViewState: FormViewState

	private let action: () async -> Void
	private let label: Label

	public init(
		action: @escaping () async -> Void,
		@ViewBuilder label: () -> Label
	) {
		self.action = action
		self.label = label()
	}

	public var body: some View {
		Button {
			Task {
				await action()
			}
		} label: {
			if formViewState.isSubmitting {
				ProgressView()
					.progressViewStyle(CircularProgressViewStyle())
			} else {
				label
			}
		}
		.disabled(!formViewState.isValid || formViewState.isSubmitting)
	}
}

extension FormSubmitButton where Label == Text {
	/// Create a submit button with a text label
	public init(
		_ title: String,
		action: @escaping () async -> Void
	) {
		self.init(action: action) {
			Text(title)
		}
	}
}

// MARK: - FormSection

/// A section container for grouping form fields.
///
/// Example:
/// ```swift
/// FormSection("Account Information") {
///     FormField("Email", text: $viewState.email)
///     FormField("Password", text: $viewState.password, isSecure: true)
/// }
/// ```
public struct FormSection<Content: View>: View {
	private let header: String?
	private let footer: String?
	private let content: Content

	public init(
		_ header: String? = nil,
		footer: String? = nil,
		@ViewBuilder content: () -> Content
	) {
		self.header = header
		self.footer = footer
		self.content = content()
	}

	public var body: some View {
		Section {
			content
		} header: {
			if let header = header {
				Text(header)
			}
		} footer: {
			if let footer = footer {
				Text(footer)
					.font(.caption)
					.foregroundColor(.secondary)
			}
		}
	}
}

// MARK: - FormErrorView

/// Displays form-level error messages.
///
/// Example:
/// ```swift
/// FormErrorView()
///     .environmentObject(viewState)
/// ```
public struct FormErrorView: View {
	@EnvironmentObject private var formViewState: FormViewState

	public init() {}

	public var body: some View {
		if let error = formViewState.formError, !error.isEmpty {
			HStack {
				Image(systemName: "exclamationmark.triangle.fill")
					.foregroundColor(.red)

				Text(error)
					.font(.subheadline)
					.foregroundColor(.red)

				Spacer()

				Button(action: {
					formViewState.formError = nil
				}) {
					Image(systemName: "xmark.circle.fill")
						.foregroundColor(.red)
				}
			}
			.padding()
			.background(Color.red.opacity(0.1))
			.cornerRadius(8)
		}
	}
}

// MARK: - FormLoadingView

/// Displays a loading overlay when the form is submitting.
///
/// Example:
/// ```swift
/// ZStack {
///     MyFormView()
///     FormLoadingView()
///         .environmentObject(viewState)
/// }
/// ```
public struct FormLoadingView: View {
	@EnvironmentObject private var formViewState: FormViewState

	public init() {}

	public var body: some View {
		if formViewState.isSubmitting {
			ZStack {
				Color.black.opacity(0.3)
					.ignoresSafeArea()

				VStack(spacing: 16) {
					ProgressView()
						.progressViewStyle(CircularProgressViewStyle(tint: .white))
						.scaleEffect(1.5)

					Text("Submitting...")
						.foregroundColor(.white)
						.font(.headline)
				}
				.padding(32)
				.background(Color.black.opacity(0.7))
				.cornerRadius(16)
			}
		}
	}
}

// MARK: - FormFieldError

/// Displays field-specific error messages.
///
/// Example:
/// ```swift
/// TextField("Email", text: $viewState.email)
/// FormFieldError(for: "email")
///     .environmentObject(viewState)
/// ```
public struct FormFieldError: View {
	@EnvironmentObject private var formViewState: FormViewState

	private let field: String

	public init(for field: String) {
		self.field = field
	}

	public var body: some View {
		if let error = formViewState.errorForField(field), !error.isEmpty {
			Text(error)
				.font(.caption)
				.foregroundColor(.red)
		}
	}
}
