//
//  ToastMessage.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation

/// Represents a toast notification message
public struct ToastMessage: Identifiable, Equatable, Sendable {
	/// Unique identifier for the toast
	public let id: UUID

	/// The visual style of the toast
	public let style: ToastStyle

	/// The message to display
	public let message: String

	/// How long to display the toast in seconds
	public let duration: TimeInterval

	/// Creates a new toast message
	/// - Parameters:
	///   - id: Unique identifier (auto-generated if not provided)
	///   - style: The visual style
	///   - message: The message text
	///   - duration: Display duration in seconds (defaults to style's default)
	public init(
		id: UUID = UUID(),
		style: ToastStyle,
		message: String,
		duration: TimeInterval? = nil
	) {
		self.id = id
		self.style = style
		self.message = message
		self.duration = duration ?? style.defaultDuration
	}
}

// MARK: - Convenience Initializers

extension ToastMessage {
	/// Creates a success toast
	/// - Parameters:
	///   - message: The success message
	///   - duration: Optional custom duration
	public static func success(_ message: String, duration: TimeInterval? = nil) -> ToastMessage {
		ToastMessage(style: .success, message: message, duration: duration)
	}

	/// Creates an error toast
	/// - Parameters:
	///   - message: The error message
	///   - duration: Optional custom duration
	public static func error(_ message: String, duration: TimeInterval? = nil) -> ToastMessage {
		ToastMessage(style: .error, message: message, duration: duration)
	}

	/// Creates an info toast
	/// - Parameters:
	///   - message: The info message
	///   - duration: Optional custom duration
	public static func info(_ message: String, duration: TimeInterval? = nil) -> ToastMessage {
		ToastMessage(style: .info, message: message, duration: duration)
	}

	/// Creates a warning toast
	/// - Parameters:
	///   - message: The warning message
	///   - duration: Optional custom duration
	public static func warning(_ message: String, duration: TimeInterval? = nil) -> ToastMessage {
		ToastMessage(style: .warning, message: message, duration: duration)
	}
}
