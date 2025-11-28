//
//  PagePresenter.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

public struct PagePresenter<Content: View>: View {
	public let mode: PageMode
	public let content: Content

	@State
	private var onboarding: Onboarding?

	@State
	private var keyboardAdaptability: KeyboardAdaptability?

	@FocusState
	private var isFocused: Bool

	@Environment(\.rewinder)
	private var rewinder: Rewinder

	public init(
		mode: PageMode,
		@ViewBuilder content: () -> Content
	) {
		self.mode = mode
		self.content = content()
	}

	public var body: some View {
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

		keyboardAdaptedContent
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
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
