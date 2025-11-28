//
//  ModalPresenter.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

public struct ModalPresenter<Content: View>: View {
	private let content: Content

	private let animationDuration: CGFloat = 0.3

	@ExternalizedState
	private var isShowing: Bool = false

	@Environment(\.rewinder)
	private var rewinder: Rewinder

	public init(
		@ViewBuilder content: () -> Content
	) {
		self.content = content()
	}

	public var body: some View {
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
						content
							.padding()
					}
					.frame(maxWidth: .infinity)
					.background(Color(uiColor: .systemBackground))
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

	public func showModal() {
		if !isShowing {
			isShowing = true
		}
	}

	public func dismissModal(_ completion: (() -> Void)? = nil) {
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
