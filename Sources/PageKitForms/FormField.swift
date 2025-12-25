//
//  FormField.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Combine
import SwiftUI

// MARK: - FormFieldObservable

/// Protocol for observable form fields that support validation.
public protocol FormFieldObservable: AnyObject {
    var objectWillChange: ObservableObjectPublisher { get }
    var isValid: Bool { get }
    func validate()
}

// MARK: - FormField

/// A generic form field that holds a value and its validation state.
///
/// Each FormField owns its own validation logic and error message.
/// Use the fluent `.validator()` API to attach validators.
///
/// Example:
/// ```swift
/// var email = FormField<String>("")
///     .validator({ !$0.isEmpty }, "Email is required")
///     .validator({ $0.contains("@") }, "Invalid email format")
/// ```
public class FormField<Value>: FormFieldObservable, ObservableObject {

    // MARK: - Types

    /// A validation rule consisting of a condition, validator, and error message.
    public typealias Validation = (
        condition: () -> Bool,
        validator: (Value) -> Bool,
        message: String
    )

    // MARK: - Published Properties

    /// The current value of the field.
    @Published
    public var value: Value

    /// Whether the field is currently valid.
    @Published
    public private(set) var isValid: Bool = true

    /// The validation error message, if any.
    @Published
    public private(set) var validationMessage: String?

    // MARK: - Properties

    /// Array of validation rules attached to this field.
    public var validations: [Validation] = []

    // MARK: - Lifecycle

    /// Creates a new form field with an initial value.
    ///
    /// - Parameter initialValue: The initial value for the field.
    public init(_ initialValue: Value) {
        value = initialValue
    }

    // MARK: - Fluent Validators

    /// Adds a simple validator to the field.
    ///
    /// - Parameters:
    ///   - validator: Closure that returns true if the value is valid.
    ///   - message: Error message to display when validation fails.
    /// - Returns: Self for method chaining.
    @discardableResult
    public func validator(
        _ validator: @escaping (Value) -> Bool,
        _ message: String
    ) -> Self {
        self.validator(
            when: { true },
            ensure: validator,
            otherwise: message
        )
    }

    /// Adds a conditional validator to the field.
    ///
    /// Use the `when` parameter to enable/disable the validator based on conditions.
    ///
    /// - Parameters:
    ///   - condition: Closure that returns true when this validator should run.
    ///   - validator: Closure that returns true if the value is valid.
    ///   - message: Error message to display when validation fails.
    /// - Returns: Self for method chaining.
    ///
    /// Example:
    /// ```swift
    /// password = password
    ///     .validator(
    ///         when: { self.isSignUp },
    ///         ensure: { $0.count >= 8 },
    ///         otherwise: "Password must be at least 8 characters"
    ///     )
    /// ```
    @discardableResult
    public func validator(
        when condition: @escaping () -> Bool = { true },
        ensure validator: @escaping (Value) -> Bool,
        otherwise message: String
    ) -> Self {
        validations.append((condition: condition, validator: validator, message: message))
        return self
    }

    // MARK: - Validation

    /// Validates the field against all attached validators.
    ///
    /// Updates `isValid` and `validationMessage` based on the result.
    public func validate() {
        // Filter to only active validators (where condition is true)
        let activeValidations = validations.filter { $0.condition() }

        // Check if all active validators pass
        let isValid = activeValidations.allSatisfy { $0.validator(value) }

        self.isValid = isValid
        validationMessage = isValid ? nil : activeValidations.first { !$0.validator(value) }?.message
    }

    /// Clears any validation error and resets to valid state.
    public func clearValidation() {
        isValid = true
        validationMessage = nil
    }
}
