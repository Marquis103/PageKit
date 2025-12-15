//
//  ModalController.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

// MARK: - ModalDismissable

public protocol ModalDismissable {
	func dismissModal(_ completion: @escaping () -> Void)
}

// MARK: - ModalController

public final class ModalController<P: Page>: PageHostController<P>, ModalDismissable {
	private var modalPresenter: ModalPresenter<P.View>?

	override public func setupView() {
		let modalPresenter = ModalPresenter {
			pageView
		}

		let hostingController = UIHostingController(
			rootView: ModalContentWrapper {
				modalPresenter
			}
			.environment(\.rewinder, rewinder)
		)

		hostingController.view.backgroundColor = UIColor.clear
		hostingController.view.isOpaque = false

		addChild(hostingController)
		view.addSubview(hostingController.view)
		hostingController.view.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
			hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
		hostingController.didMove(toParent: self)

		self.modalPresenter = modalPresenter
	}

	public func dismissModal(_ completion: @escaping () -> Void) {
		modalPresenter?.dismissModal(completion)
	}
}
