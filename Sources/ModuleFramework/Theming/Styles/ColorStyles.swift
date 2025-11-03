//
//  ColorStyles.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

struct ColorStyles {
	struct TextColors {
		let primary: Color
		let secondary: Color
		let tertiary: Color
		let inverted: Color
	}

	struct BackgroundColors {
		let primary: Color
		let secondary: Color
		let tertiary: Color
	}

	struct AccentColors {
		let aqua: Color
		let blue: Color
		let gold: Color
		let green: Color
		let lime: Color
		let orange: Color
		let purple: Color
		let red: Color
		let salmon: Color
		let silver: Color
		let yellow: Color
	}

	let primary: Color
	let positive: Color
	let destructive: Color
	let text: TextColors
	let background: BackgroundColors
	let accent: AccentColors
	let divider: Color
}
