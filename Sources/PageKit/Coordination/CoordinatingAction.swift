//
//  CoordinatingAction.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation

public protocol CoordinatingAction where Self: Coordinator {
	func coordinate(action: CoordinatableAction)
}
