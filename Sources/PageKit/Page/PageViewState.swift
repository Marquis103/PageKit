//
//  PageViewState.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation
import SwiftUI

open class PageViewState: ObservableObject {
	@Published
	public var isRefreshing = false

	public init() {}
}
