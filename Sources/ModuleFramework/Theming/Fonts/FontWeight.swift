//
//  FontWeight.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Foundation
import UIKit

public enum FontWeight {
	case light
	case medium
	case semiBold
	case bold
	case extraBold
	case black

	public var uiFontWeight: UIFont.Weight {
		switch self {
			case .light: .light
			case .medium: .medium
			case .semiBold: .semibold
			case .bold: .bold
			case .extraBold: .heavy
			case .black: .black
		}
	}
}
