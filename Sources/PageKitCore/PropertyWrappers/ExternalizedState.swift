// PE-536/E4 spike/android: @ObservedObject-backed wrapper — Android variant uses an @Observable box.
#if !os(Android)
//
//  ExternalizedState.swift
//
//  Copyright © 2025 PageKit All rights reserved.
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

#else
import Foundation
import Observation
import SwiftUI

@Observable
private final class ExternalizedBox<Value> {
	var value: Value
	init(_ v: Value) { value = v }
}

@propertyWrapper
public struct ExternalizedState<Value> {
	private let box: ExternalizedBox<Value>

	public var wrappedValue: Value {
		get { box.value }
		nonmutating set { box.value = newValue }
	}

	public var projectedValue: Binding<Value> {
		Binding(get: { box.value }, set: { box.value = $0 })
	}

	public init(wrappedValue initialValue: Value) {
		box = ExternalizedBox(initialValue)
	}
}
#endif
