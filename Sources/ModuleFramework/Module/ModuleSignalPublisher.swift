//
//  ModuleSignalPublisher.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import Combine

protocol ModuleSignalPublisher {
	var signalPublisher: AnyPublisher<ModuleSignal, Never> { get }
}
