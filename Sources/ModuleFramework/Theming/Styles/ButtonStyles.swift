//
//  ButtonStyles.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

struct ButtonStyles {
	struct ButtonStyle {
		let backgroundColor: Color
		let contentColor: Color
		let cornerRadius: CGFloat
		let border: (color: Color, width: CGFloat)?
	}

	let primary: ButtonStyle
	let secondary: ButtonStyle
	let destructive: ButtonStyle
	let ghost: ButtonStyle
	let link: ButtonStyle
}
