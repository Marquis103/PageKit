//
//  ModalPresenter.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

struct ModalPresenter<Content: View>: View {
	private let content: Content

	private let animationDuration: CGFloat = 0.3

	@ExternalizedState
	private var isShowing: Bool = false

	// Note: Navigation preference removed - it was TheCut-specific
	// To add navigation headers, implement your own preference system

	@Environment(\.rewinder)
	private var rewinder: Rewinder

	@Environment(\.theme)
	private var theme: Theme

	init(
		@ViewBuilder content: () -> Content
	) {
		self.content = content()
	}

	var body: some View {
		ZStack {
			Color.black
				.opacity(isShowing ? 0.5 : 0)
				.transition(.opacity)
				.onTapGesture {
					rewind()
				}

			VStack {
				Spacer()

				if isShowing {
					VStack {
						// Note: NavigationHeader removed - was part of TheCut's Navigation preference system
						// Implement your own header if needed

						content
							.padding(theme.spacing.large)
					}
					.frame(maxWidth: .infinity)
					.background(theme.colors.background.secondary)
					.environment(
						\.rewinder,
						Rewinder(rewindStyle: rewinder.rewindStyle) {
							dismissModal {
								rewinder.rewind?()
							}
						}
					)
					.transition(.move(edge: .bottom))
				}
			}
		}
		.ignoresSafeArea(edges: .top)
		.animation(.easeInOut(duration: animationDuration), value: isShowing)
		.onAppear {
			showModal()
		}
	}

	func showModal() {
		if !isShowing {
			isShowing = true
		}
	}

	func dismissModal(_ completion: (() -> Void)? = nil) {
		if isShowing {
			isShowing = false

			// Call completion after the animation is complete
			DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
				completion?()
			}
		} else {
			// Already dismissed, call completion immediately
			completion?()
		}
	}

	private func rewind() {
		dismissModal {
			rewinder.rewind?()
		}
	}
}
