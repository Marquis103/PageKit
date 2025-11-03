//
//  OptionalBinding.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

@propertyWrapper
struct OptionalBinding<Value>: DynamicProperty {
	private var stateValue: State<Value>
	private var bindingValue: Binding<Value>?

	var wrappedValue: Value {
		bindingValue?.wrappedValue ?? stateValue.wrappedValue
	}

	var projectedValue: Binding<Value> {
		get { bindingValue ?? stateValue.projectedValue }
		set { bindingValue = newValue }
	}

	init(wrappedValue defaultValue: Value) {
		stateValue = State(initialValue: defaultValue)
	}
}
