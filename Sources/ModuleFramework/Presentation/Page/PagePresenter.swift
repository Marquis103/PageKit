//
//  PagePresenter.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

// swiftlint:disable weak_self_closure

struct PagePresenter<Content: View>: View {
	let mode: PageMode
	let content: Content

	// Note: Navigation preference removed - it was TheCut-specific
	// To add navigation headers, implement your own preference system

	@State
	private var onboarding: Onboarding?

	@State
	private var keyboardAdaptability: KeyboardAdaptability?

	@FocusState
	private var isFocused: Bool

	@Environment(\.rewinder)
	private var rewinder: Rewinder

	@Environment(\.theme)
	private var theme: Theme

	init(
		mode: PageMode,
		@ViewBuilder content: () -> Content
	) {
		self.mode = mode
		self.content = content()
	}

	var body: some View {
		let preferenceKeyContent =
			content
				.onPreferenceChange(KeyboardAdaptabilityPreferenceKey.self) { newValue in
					keyboardAdaptability = newValue
				}
				.onPreferenceChange(OnboardingPreferenceKey.self) { newValue in
					onboarding = newValue
				}

		let keyboardAdaptedContent =
			preferenceKeyContent
				.if(keyboardAdaptability?.preventDismissOnTap != true) {
					$0
						.focused($isFocused)
						.simultaneousGesture(
							TapGesture()
								.onEnded {
									isFocused = false
								}
						)
				}
				.if(keyboardAdaptability?.preventResizing == true) {
					// Ignoring the keyboard safe area prevents SwiftUI from
					// resizing the view when the keyboard is presented
					$0.ignoresSafeArea(.keyboard)
				}
				.if(keyboardAdaptability?.preventShifting == true) { view in
					GeometryReader { _ in
						// Wrapping the content in a GeometryReader prevents SwiftUI from
						// shifting the view up when keyboard is presented
						view
					}
				}

		// Note: Onboarding mode removed - it was TheCut-specific
		// Only normal mode is now supported
		keyboardAdaptedContent
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				// Note: Navigation content removed - implement your own toolbar items if needed

				ToolbarItemGroup(placement: .navigationBarLeading) {
					let rewindStyle = rewinder.rewindStyle
					let rewind = rewinder.rewind ?? {}

					if rewindStyle == .cancel {
						Button("Cancel", action: rewind)
					} else if rewindStyle == .chevron {
						Button(action: rewind) {
							Image(systemName: "chevron.left")
						}
					} else if rewindStyle == .x {
						Button(action: rewind) {
							Image(systemName: "xmark")
						}
					}
				}
			}
			.if(true) { view in
				Group {
					if #available(iOS 16.0, *) {
						NavigationStack {
							view
								.toolbarBackground(.hidden, for: .navigationBar)
						}
					} else {
						NavigationView {
							view
						}
					}
				}
			}
	}
}

// swiftlint:enable weak_self_closure
