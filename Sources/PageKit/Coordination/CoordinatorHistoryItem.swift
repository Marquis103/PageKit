//
//  CoordinatorHistoryItem.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation
import UIKit

public struct CoordinatorHistoryItem: Equatable {
	public let navigationAction: NavigationAction
	public let viewController: UIViewController

	public var identifier: String { String(describing: type(of: viewController)) }

	public init(
		navigationAction: NavigationAction,
		viewController: UIViewController
	) {
		self.navigationAction = navigationAction
		self.viewController = viewController
	}

	public static func == (lhs: CoordinatorHistoryItem, rhs: CoordinatorHistoryItem) -> Bool {
		lhs.identifier == rhs.identifier
	}
}
