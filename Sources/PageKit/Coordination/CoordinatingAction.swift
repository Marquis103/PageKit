//
//  CoordinatingAction.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation

public protocol CoordinatingAction where Self: Coordinator {
	func coordinate(action: CoordinatableAction)
}
