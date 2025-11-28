//
//  Coordinator.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Combine
import UIKit

// MARK: - CoordinatorDelegate

public protocol CoordinatorDelegate: AnyObject {
	func coordinatorWillStart(_ coordinator: Coordinator)
	func coordinatorDidStart(_ coordinator: Coordinator)
	func coordinatorWillEnd(_ coordinator: Coordinator)
	func coordinatorDidEnd(_ coordinator: Coordinator)
}

extension CoordinatorDelegate {
	public func coordinatorWillStart(_: Coordinator) {}
	public func coordinatorDidStart(_: Coordinator) {}
	public func coordinatorWillEnd(_: Coordinator) {}
	public func coordinatorDidEnd(_: Coordinator) {}
}

// MARK: - Coordinator

open class Coordinator:
	NSObject,
	Coordinating,
	CoordinatingAction
{
	public var coordinators: [Coordinator?] = []

	private var hasStarted: Bool = false

	private var _hasEnded = false
	public var hasEnded: Bool { _hasEnded }

	/// The view controller that started this coordinator
	public private(set) var rootViewController: UIViewController

	/// Navigation history of this coordinator
	public var history: [CoordinatorHistoryItem] = []

	/// Private subject for page signal publishing
	private lazy var _signalPublisher = PassthroughSubject<PageSignal, Never>()

	private var didStartCompletion: (() -> Void)?

	/// Publicly exposed read-only access to the signal publisher
	public var signalPublisher: AnyPublisher<PageSignal, Never> {
		_signalPublisher.eraseToAnyPublisher()
	}

	public var activeNavigationController: UINavigationController? {
		history.last?.viewController.navigationController ?? rootViewController.navigationController
	}

	public var activeViewController: UIViewController {
		history.last?.viewController ?? rootViewController
	}

	public weak var delegate: CoordinatorDelegate?

	public init(rootViewController: UIViewController) {
		self.rootViewController = rootViewController
		super.init()
	}

	// MARK: Lifecycle

	open func start(with _: NavigationAction) {
		assertionFailure("Subclass should override start(with action)")
	}

	public final func end(animated: Bool = true) {
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
	open func willStart() {
		delegate?.coordinatorWillStart(self)
	}

	/// Called immediately after coordinator has finished presenting first view
	open func didStart() {
		delegate?.coordinatorDidStart(self)
	}

	/// Called directly before coordinator is ended
	open func willEnd() {
		delegate?.coordinatorWillEnd(self)
	}

	/// Called immediately after coordinator has finished ending
	open func didEnd() {
		delegate?.coordinatorDidEnd(self)
	}

	// MARK: Child Lifecycle

	open func coordinatorWillStart(_: Coordinator) {
		// Can be overriden
	}

	open func coordinatorDidStart(_: Coordinator) {
		// Can be overriden
	}

	open func coordinatorWillEnd(_ coordinator: Coordinator) {
		activeNavigationController?.delegate = self
		coordinators.removeAll(where: { $0 === coordinator })
	}

	open func coordinatorDidEnd(_ coordinator: Coordinator) {
		coordinators.removeAll(where: { $0 === coordinator })
		endIfNeeded()
	}

	// MARK: Navigation

	public func navigate(to viewController: UIViewController, with action: NavigationAction) {
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
				activeController.present(viewController, animated: true, completion: didStartCompletion)
			case .system:
				activeController.present(viewController, animated: true, completion: didStartCompletion)
			case .none:
				didStartCompletion?()
			case .window:
				viewController.loadViewIfNeeded()
				didStartCompletion?()
		}

		let historyItem = CoordinatorHistoryItem(
			navigationAction: action,
			viewController: viewController
		)

		history.append(historyItem)
	}

	public func rewind(
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

	open func coordinate(action _: CoordinatableAction) {
		// Can be overriden
	}

	public func configure(rewindStyle: RewindStyle, to viewController: UIViewController) {
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

	// MARK: - PageSignalPublisher

	public func send(signal: PageSignal) {
		_signalPublisher.send(signal)
	}
}

// MARK: UINavigationControllerDelegate

extension Coordinator: UINavigationControllerDelegate {
	public func navigationController(
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
