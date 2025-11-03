//
//  CoordinatorHistoryItem.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation
import UIKit

struct CoordinatorHistoryItem: Equatable {
	let navigationAction: NavigationAction
	let viewController: UIViewController

	var identifier: String { String(describing: type(of: viewController)) }

	init(
		navigationAction: NavigationAction,
		viewController: UIViewController
	) {
		self.navigationAction = navigationAction
		self.viewController = viewController
	}

	static func == (lhs: CoordinatorHistoryItem, rhs: CoordinatorHistoryItem) -> Bool {
		lhs.identifier == rhs.identifier
	}
}
