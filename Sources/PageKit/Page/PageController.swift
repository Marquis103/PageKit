//
//  PageController.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation
import UIKit

public protocol PageController<P>: UIViewController {
	associatedtype P: Page
}
