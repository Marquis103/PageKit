//
//  ModalController.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
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
	private var modalPresenter: ModalPresenter<P.Content>?

	override public func setupView() {
		let modalPresenter = ModalPresenter {
			pageContent
		}

		let hostingController = UIHostingController(
			rootView: ModalContentWrapper {
				modalPresenter
			}
			.environment(\.rewinder, rewinder)
		)

		hostingController.view?.backgroundColor = UIColor.clear
		hostingController.view?.isOpaque = false

		addChild(hostingController)

		self.modalPresenter = modalPresenter
	}

	public func dismissModal(_ completion: @escaping () -> Void) {
		modalPresenter?.dismissModal(completion)
	}
}
