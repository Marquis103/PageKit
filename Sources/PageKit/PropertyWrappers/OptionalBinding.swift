//
//  OptionalBinding.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

@propertyWrapper
public struct OptionalBinding<Value>: DynamicProperty {
	private var stateValue: State<Value>
	private var bindingValue: Binding<Value>?

	public var wrappedValue: Value {
		bindingValue?.wrappedValue ?? stateValue.wrappedValue
	}

	public var projectedValue: Binding<Value> {
		get { bindingValue ?? stateValue.projectedValue }
		set { bindingValue = newValue }
	}

	public init(wrappedValue defaultValue: Value) {
		stateValue = State(initialValue: defaultValue)
	}
}
