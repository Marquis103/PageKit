//
//  ToastView.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI
import PageKitTheming

/// The visual representation of a toast notification
public struct ToastView: View {
	let toast: ToastMessage
	let onDismiss: () -> Void

	@Environment(\.optionalTheme)
	private var theme: AnyTheme?

	public init(toast: ToastMessage, onDismiss: @escaping () -> Void) {
		self.toast = toast
		self.onDismiss = onDismiss
	}

	public var body: some View {
		HStack(spacing: 12) {
			Image(systemName: toast.style.iconName)
				.font(.system(size: 20, weight: .semibold))
				.foregroundStyle(iconColor)

			Text(toast.message)
				.font(.subheadline)
				.fontWeight(.medium)
				.foregroundStyle(textColor)
				.multilineTextAlignment(.leading)
				.lineLimit(3)

			Spacer(minLength: 0)

			Button {
				onDismiss()
			} label: {
				Image(systemName: "xmark")
					.font(.system(size: 12, weight: .semibold))
					.foregroundStyle(textColor.opacity(0.6))
			}
		}
		.padding(.horizontal, 16)
		.padding(.vertical, 14)
		.background(backgroundColor)
		.clipShape(RoundedRectangle(cornerRadius: 12))
		.shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
		.padding(.horizontal, 16)
		.contentShape(Rectangle())
		.onTapGesture {
			onDismiss()
		}
		.gesture(
			DragGesture(minimumDistance: 20)
				.onEnded { value in
					if value.translation.height < -20 {
						onDismiss()
					}
				}
		)
	}

	// MARK: - Colors

	private var backgroundColor: Color {
		// Use theme colors if available, otherwise use style defaults
		switch toast.style {
		case .success:
			return theme?.colors.positive ?? toast.style.tintColor
		case .error:
			return theme?.colors.destructive ?? toast.style.tintColor
		case .info:
			return theme?.colors.primary ?? toast.style.tintColor
		case .warning:
			return toast.style.tintColor // No theme equivalent, use default
		}
	}

	private var textColor: Color {
		.white
	}

	private var iconColor: Color {
		.white
	}
}

// MARK: - Toast Overlay View

/// Internal view that renders the toast overlay at the top of the screen
struct ToastOverlayView: View {
	let manager: ToastManager

	var body: some View {
		VStack {
			if let toast = manager.currentToast {
				ToastView(toast: toast) {
					manager.dismiss()
				}
				.transition(.asymmetric(
					insertion: .move(edge: .top).combined(with: .opacity),
					removal: .opacity
				))
			}

			Spacer()
		}
		.animation(.spring(response: 0.3, dampingFraction: 0.8), value: manager.currentToast?.id)
	}
}

// MARK: - Preview

#if DEBUG
#Preview("Toast Styles") {
	VStack(spacing: 20) {
		ToastView(toast: .success("Item saved successfully!")) {}
		ToastView(toast: .error("Failed to save item")) {}
		ToastView(toast: .info("Tap to view details")) {}
		ToastView(toast: .warning("Your session will expire soon")) {}
	}
	.padding()
	.background(Color.gray.opacity(0.2))
}
#endif
