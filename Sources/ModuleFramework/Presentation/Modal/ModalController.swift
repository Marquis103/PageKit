//
//  ModalController.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

// MARK: - ModalDismissable

protocol ModalDismissable {
	func dismissModal(_ completion: @escaping () -> Void)
}

// MARK: - ModalController

final class ModalController<Mod: Module>: PageController<Mod>, ModalDismissable {
	private var modalPresenter: ModalPresenter<Mod.View>?

	override func setupView() {
		let modalPresenter = ModalPresenter {
			moduleView
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

	func dismissModal(_ completion: @escaping () -> Void) {
		modalPresenter?.dismissModal(completion)
	}
}
