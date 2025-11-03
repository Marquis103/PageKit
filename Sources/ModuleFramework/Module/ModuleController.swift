//
//  ModuleController.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation
import UIKit

protocol ModuleController<Mod>: UIViewController {
	associatedtype Mod: Module
}
