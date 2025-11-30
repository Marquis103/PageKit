//
//  PageHostController.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

// MARK: - PageHostController

public class PageHostController<P: Page>: UIViewController, PageController {
	public let pageViewModel: P.ViewModel
	public let pageViewState: P.ViewState
	public let pageView: P.View

	public let mode: PageMode
	public let rewinder: Rewinder

	private var isInitialViewDidAppear: Bool = true

	private var isVisible: Bool {
		isViewLoaded && view.window != nil
	}

	private var didBecomeActiveNotificationToken: NSObjectProtocol?

	public init(page: P, mode: PageMode = .normal, rewinder: Rewinder) {
		pageViewModel = page.viewModel
		pageViewState = page.viewState
		pageView = page.view

		self.mode = mode
		self.rewinder = rewinder

		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit {
		end()
	}

	// MARK: View Controller Lifecycle

	override public func viewDidLoad() {
		super.viewDidLoad()

		setupView()
		start()
	}

	override public func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}

	override public func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		resume()
		registerObservers()
	}

	override public func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		pause()
		removeObservers()
	}

	// MARK: Page Lifecycle

	public func setupView() {
		addChild(
			UIHostingController(
				rootView: PageContentWrapper {
					PagePresenter(mode: mode) {
						pageView
					}
				}
				.environment(\.rewinder, rewinder)
			)
		)
	}

	public func start() {
		Task {
			await pageViewModel.onStart()
		}
	}

	public func resume() {
		if !isInitialViewDidAppear {
			Task {
				await pageViewModel.onResume()
			}
		}

		isInitialViewDidAppear = false
	}

	public func pause() {
		Task {
			await pageViewModel.onPause()
		}
	}

	public func end() {
		pageViewModel.onEnd()
	}

	// MARK: Internals

	private func registerObservers() {
		if didBecomeActiveNotificationToken == nil {
			didBecomeActiveNotificationToken = NotificationCenter.default.addObserver(
				forName: UIApplication.didBecomeActiveNotification,
				object: UIApplication.shared,
				queue: .main
			) { [weak self] _ in
				guard let self else { return }
				if isVisible {
					resume()
				}
			}
		}
	}

	private func removeObservers() {
		if let token = didBecomeActiveNotificationToken {
			NotificationCenter.default.removeObserver(token)
			didBecomeActiveNotificationToken = nil
		}
	}
}
