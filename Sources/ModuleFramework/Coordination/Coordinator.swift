//
//  Coordinator.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Combine
import UIKit

// MARK: - CoordinatorDelegate

protocol CoordinatorDelegate: AnyObject {
	func coordinatorWillStart(_ coordinator: Coordinator)
	func coordinatorDidStart(_ coordinator: Coordinator)
	func coordinatorWillEnd(_ coordinator: Coordinator)
	func coordinatorDidEnd(_ coordinator: Coordinator)
}

extension CoordinatorDelegate {
	func coordinatorWillStart(_: Coordinator) {}
	func coordinatorDidStart(_: Coordinator) {}
	func coordinatorWillEnd(_: Coordinator) {}
	func coordinatorDidEnd(_: Coordinator) {}
}

// MARK: - Coordinator

class Coordinator:
	NSObject,
	Coordinating,
	CoordinatingAction
{
	var coordinators: [Coordinator?] = []

	private var hasStarted: Bool = false

	private var _hasEnded = false
	var hasEnded: Bool { _hasEnded }

	/// The view controller that started this coordinator
	private(set) var rootViewController: UIViewController

	/// Navigation history of this coordinator
	var history: [CoordinatorHistoryItem] = []

	/// Private subject for module signal publishing
	private lazy var _signalPublisher = PassthroughSubject<ModuleSignal, Never>()

	private var didStartCompletion: (() -> Void)?

	/// Publicly exposed read-only access to the signal publisher
	var signalPublisher: AnyPublisher<ModuleSignal, Never> {
		_signalPublisher.eraseToAnyPublisher()
	}

	var activeNavigationController: UINavigationController? {
		history.last?.viewController.navigationController ?? rootViewController.navigationController
	}

	var activeViewController: UIViewController {
		history.last?.viewController ?? rootViewController
	}

	weak var delegate: CoordinatorDelegate?

	init(rootViewController: UIViewController) {
		self.rootViewController = rootViewController
		super.init()
	}

	// MARK: Lifecycle

	func start(with _: NavigationAction) {
		assertionFailure("Subclass should override start(with action)")
	}

	final func end(animated: Bool = true) {
		guard !hasEnded else { return }

		_hasEnded = true

		willEnd()

		// End all child coordinators
		for coordinator in coordinators {
			coordinator?.end(animated: animated)
		}

		coordinators = []

		// Determine root presenting controller
		let rootPresentingViewController = rootViewController.navigationController ?? rootViewController

		// Dismiss any presented view controllers that are a part of the coordinator's history
		if let presentedViewController = rootPresentingViewController.presentedViewController {
			let isPresentedViewControllerInHistory = history.contains {
				$0.viewController.navigationController === presentedViewController
					|| $0.viewController === presentedViewController
			}

			if isPresentedViewControllerInHistory {
				// viewDidAppear doesn't get called when a view controller dismisses a presented view controller
				// Manually calling viewDidAppear on a view controller is not recommended
				// The recommended way is to call beginAppearanceTransition and endAppearanceTransition
				rootViewController.beginAppearanceTransition(true, animated: animated)

				presentedViewController.presentingViewController?
					.dismiss(animated: animated) { [weak self] in
						self?.rootViewController.endAppearanceTransition()
					}
			}
		}

		// Pop to root view controller
		rootViewController.navigationController?.popToViewController(rootViewController, animated: animated)

		// Clear history
		history = []

		didEnd()
	}

	private func willStartIfNeeded() {
		if history.isEmpty, !hasStarted, !hasEnded {
			willStart()
			didStartCompletion = { [weak self] in
				guard let self else { return }
				didStartCompletion = nil
				hasStarted = true
				didStart()
			}
		}
	}

	private func endIfNeeded() {
		if history.isEmpty, coordinators.isEmpty {
			end()
		}
	}

	/// Called directly before coordinator is going to present its first view
	func willStart() {
		delegate?.coordinatorWillStart(self)
	}

	/// Called immediately after coordinator has finished presenting first view
	func didStart() {
		delegate?.coordinatorDidStart(self)
	}

	/// Called directly before coordinator is ended
	func willEnd() {
		delegate?.coordinatorWillEnd(self)
	}

	/// Called immediately after coordinator has finished ending
	func didEnd() {
		delegate?.coordinatorDidEnd(self)
	}

	// MARK: Child Lifecycle

	func coordinatorWillStart(_: Coordinator) {
		// Can be overriden
	}

	func coordinatorDidStart(_: Coordinator) {
		// Can be overriden
	}

	func coordinatorWillEnd(_ coordinator: Coordinator) {
		activeNavigationController?.delegate = self
		coordinators.removeAll(where: { $0 === coordinator })
	}

	func coordinatorDidEnd(_ coordinator: Coordinator) {
		coordinators.removeAll(where: { $0 === coordinator })
		endIfNeeded()
	}

	// MARK: Navigation

	func navigate(to viewController: UIViewController, with action: NavigationAction) {
		willStartIfNeeded()

		let activeController = activeNavigationController ?? activeViewController

		switch action {
			case let .push(rewindStyle):
				viewController.hidesBottomBarWhenPushed = true

				configure(rewindStyle: rewindStyle, to: viewController)

				activeNavigationController?.delegate = self
				activeNavigationController?.pushViewController(viewController, animated: true)
			case let .present(rewindStyle, transition):
				configure(rewindStyle: rewindStyle, to: viewController)

				let navigationController = UINavigationController(rootViewController: viewController)
				navigationController.delegate = self
				navigationController.modalPresentationStyle = .fullScreen

				if let transition {
					navigationController.modalTransitionStyle = transition
				}

				activeController.present(navigationController, animated: true, completion: didStartCompletion)
			case .modal:
				// Note: ModalDismissable and ModalViewControllerDelegatable protocols removed
				// Implement custom modal presentation in your app if needed
				activeController.present(viewController, animated: true, completion: didStartCompletion)
			case .system:
				activeController.present(viewController, animated: true, completion: didStartCompletion)
			case .none:
				didStartCompletion?()
			case .window:
				viewController.loadViewIfNeeded()
				// Note: Window presentation removed - implement in your app coordinator
				// Example: UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController = viewController
				didStartCompletion?()
		}

		let historyItem = CoordinatorHistoryItem(
			navigationAction: action,
			viewController: viewController
		)

		history.append(historyItem)
	}

	func rewind(
		animated: Bool = true,
		shouldEndIfNeeded: Bool = true,
		completion: (() -> Void)? = nil
	) {
		guard let last = history.popLast() else { return }

		if shouldEndIfNeeded {
			endIfNeeded()
		}

		// Handle rewind based on navigation action
		last.navigationAction.rewind(
			viewController: last.viewController,
			animated: animated,
			completion: completion
		)
	}

	func coordinate(action _: CoordinatableAction) {
		// Can be overriden
	}

	func configure(rewindStyle: RewindStyle, to viewController: UIViewController) {
		// Can't style back bar button item, use left bar button item instead
		viewController.navigationItem.hidesBackButton = true

		let barButtonItem: UIBarButtonItem? =
			switch rewindStyle {
				case .cancel:
					UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
				case .chevron:
					UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: nil, action: nil)
				case .none:
					nil
				case .x:
					UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: nil, action: nil)
			}

		// Add rewind action if bar button exists
		if let barButtonItem = barButtonItem {
			barButtonItem.target = self
			barButtonItem.action = #selector(rewindFromBarButton)
		}

		viewController.navigationItem.leftBarButtonItem = barButtonItem
	}

	@objc private func rewindFromBarButton() {
		rewind()
	}

	// MARK: - Tab Coordination
	// Note: Specific tab coordinator methods removed - implement in your app's coordinator subclasses

	// MARK: - Modal Handling
	// Note: ModalViewController delegate methods removed - framework uses standard UIKit modal presentation

	// MARK: - ModuleSignalPublisher

	func send(signal: ModuleSignal) {
		_signalPublisher.send(signal)
	}
}

// MARK: UINavigationControllerDelegate

extension Coordinator: UINavigationControllerDelegate {
	func navigationController(
		_ navigationController: UINavigationController,
		didShow viewController: UIViewController,
		animated _: Bool
	) {
		if
			history.count == 1,
			viewController == history.first?.viewController,
			!hasStarted,
			!hasEnded
		{
			didStartCompletion?()
		}

		guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
			return
		}

		if navigationController.viewControllers.contains(fromViewController) {
			return
		}

		if history.last?.viewController == fromViewController {
			history.removeLast()
			endIfNeeded()
		}
	}
}

// MARK: - Business Logic Methods Removed
// The following methods were removed as they contain app-specific business logic:
// - showConfirmation() - Use standard UIAlertController or implement in your app
// - navigateToDeviceSettings() - Implement in your app coordinator
// - navigateToMapsApp() - Implement in your app coordinator
// - openURL() - Implement in your app coordinator with your analytics
// - share() - Implement in your app coordinator with your types
// - initiateCall() - Implement in your app coordinator
