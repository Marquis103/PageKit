//
//  OnLongPressModifier.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import Foundation
import SwiftUI

extension View {
	public func onLongPress(
		gestureState: GestureState<Bool>,
		minimumDuration: Double = 0.5,
		completion: @escaping () -> Void
	) -> some View {
		simultaneousGesture(
			LongPressGesture(minimumDuration: minimumDuration)
				.sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .local))
				.updating(gestureState) { value, gestureState, _ in
					switch value {
						case .first(true):
							gestureState = true
						default:
							break
					}
				}
				.onEnded { value in
					switch value {
						case .second(true, _):
							completion()
						default:
							break
					}
				}
		)
	}
}
