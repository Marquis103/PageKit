//
//  PageSignalPublisher.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Combine

public protocol PageSignalPublisher {
	var signalPublisher: AnyPublisher<PageSignal, Never> { get }
}
