//
//  PageController.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

// MARK: - PageController

class PageController<Mod: Module>: UIViewController, ModuleController {
	let moduleViewModel: Mod.ViewModel
	let moduleViewState: Mod.ViewState
	let moduleView: Mod.View

	let mode: PageMode
	let rewinder: Rewinder

	private var isInitialViewDidAppear: Bool = true

	// Note: isVisible property removed - it used TheCut's UIWindow extensions
	// Implement your own visibility detection if needed
	private var isVisible: Bool {
		isViewLoaded && view.window != nil
	}

	private var didBecomeActiveNotificationToken: NSObjectProtocol?

	init(module: Mod, mode: PageMode = .normal, rewinder: Rewinder) {
		moduleViewModel = module.viewModel
		moduleViewState = module.viewState
		moduleView = module.view

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

	override func viewDidLoad() {
		super.viewDidLoad()

		setupView()
		start()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		// Note: setNavigationBarStyle removed - it was a TheCut extension
		// Use standard UIKit navigation bar configuration if needed
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		resume()
		registerObservers()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		pause()
		removeObservers()
	}

	// MARK: Module Lifecycle

	func setupView() {
		addChild(
			UIHostingController(
				rootView: PageContentWrapper {
					PagePresenter(mode: mode) {
						moduleView
					}
				}
				.environment(\.rewinder, rewinder)
			)
		)
	}

	func start() {
		moduleViewModel.onStart()

		Task {
			await moduleViewModel.onStart()
		}
	}

	func resume() {
		if !isInitialViewDidAppear {
			moduleViewModel.onResume()

			Task {
				await moduleViewModel.onResume()
			}
		}

		isInitialViewDidAppear = false
	}

	func pause() {
		moduleViewModel.onPause()

		Task {
			await moduleViewModel.onPause()
		}
	}

	func end() {
		moduleViewModel.onEnd()
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
