//
//  ExternalizedState.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

@propertyWrapper
public struct ExternalizedState<Value>: DynamicProperty {
	private class ObservableValue<Value>: ObservableObject {
		@Published
		var value: Value

		init(initialValue: Value) {
			value = initialValue
		}
	}

	@ObservedObject
	private var observableValue: ObservableValue<Value>

	public var wrappedValue: Value {
		get { observableValue.value }
		nonmutating set { observableValue.value = newValue }
	}

	public init(wrappedValue initialValue: Value) {
		observableValue = ObservableValue(initialValue: initialValue)
	}
}
