//
//  ExternalizedState.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

@propertyWrapper
struct ExternalizedState<Value>: DynamicProperty {
	private class ObservableValue<Value>: ObservableObject {
		@Published
		var value: Value

		init(initialValue: Value) {
			value = initialValue
		}
	}

	@ObservedObject
	private var observableValue: ObservableValue<Value>

	var wrappedValue: Value {
		get { observableValue.value }
		nonmutating set { observableValue.value = newValue }
	}

	init(wrappedValue initialValue: Value) {
		observableValue = ObservableValue(initialValue: initialValue)
	}
}
