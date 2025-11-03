//
//  TypographyStyles.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

struct TypographyStyles {
	struct TextStyles {
		struct TextStyle {
			let color: Color
			let fontFamily: FontFamily
			let fontWeight: FontWeight
		}

		let hero: TextStyle
		let h1: TextStyle
		let h2: TextStyle
		let h3: TextStyle
		let title: TextStyle
		let subtitle: TextStyle
		let body: TextStyle
		let link: TextStyle
	}

	let fontFamily: FontFamily
	let textStyles: TextStyles
}
