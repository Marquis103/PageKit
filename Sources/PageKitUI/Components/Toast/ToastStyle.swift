//
//  ToastStyle.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

/// Visual style for toast notifications
public enum ToastStyle: Equatable, Sendable {
	/// Success toast (green, checkmark icon)
	case success

	/// Error toast (red, x icon)
	case error

	/// Info toast (blue, info icon)
	case info

	/// Warning toast (orange, warning icon)
	case warning

	/// The SF Symbol name for this toast style
	public var iconName: String {
		switch self {
		case .success:
			return "checkmark.circle.fill"
		case .error:
			return "xmark.circle.fill"
		case .info:
			return "info.circle.fill"
		case .warning:
			return "exclamationmark.triangle.fill"
		}
	}

	/// The default tint color for this toast style
	public var tintColor: Color {
		switch self {
		case .success:
			return .green
		case .error:
			return .red
		case .info:
			return .blue
		case .warning:
			return .orange
		}
	}

	/// Default duration in seconds for this toast style
	public var defaultDuration: TimeInterval {
		switch self {
		case .success, .info:
			return 3.0
		case .warning:
			return 4.0
		case .error:
			return 5.0
		}
	}
}
