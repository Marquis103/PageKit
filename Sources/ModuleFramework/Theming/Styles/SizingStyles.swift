//
//  SizingStyles.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

struct SizingStyles {
	struct TextSizes {
		let xxsmall: CGFloat
		let xsmall: CGFloat
		let small: CGFloat
		let medium: CGFloat
		let large: CGFloat
		let xlarge: CGFloat
		let xxlarge: CGFloat
		let hero: CGFloat
	}

	struct IconSizes {
		let xxsmall: CGFloat
		let xsmall: CGFloat
		let small: CGFloat
		let medium: CGFloat
		let large: CGFloat
		let xlarge: CGFloat
	}

	struct ButtonSizes {
		struct ButtonSize {
			let textSize: CGFloat
			let contentPadding: EdgeInsets
		}

		let small: ButtonSize
		let medium: ButtonSize
		let large: ButtonSize
		let xlarge: ButtonSize
	}

	let text: TextSizes
	let icons: IconSizes
	let buttons: ButtonSizes
}
