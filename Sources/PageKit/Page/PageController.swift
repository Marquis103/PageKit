//
//  PageController.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation
import UIKit

public protocol PageController<P>: UIViewController {
	associatedtype P: Page
}
