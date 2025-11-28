//
//  PageSignalPublisher.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Combine

public protocol PageSignalPublisher {
	var signalPublisher: AnyPublisher<PageSignal, Never> { get }
}
