//
//  SizingStyles.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI

public struct SizingStyles {
	public struct TextSizes {
		public let xxsmall: CGFloat
		public let xsmall: CGFloat
		public let small: CGFloat
		public let medium: CGFloat
		public let large: CGFloat
		public let xlarge: CGFloat
		public let xxlarge: CGFloat
		public let hero: CGFloat

		public init(xxsmall: CGFloat, xsmall: CGFloat, small: CGFloat, medium: CGFloat, large: CGFloat, xlarge: CGFloat, xxlarge: CGFloat, hero: CGFloat) {
			self.xxsmall = xxsmall
			self.xsmall = xsmall
			self.small = small
			self.medium = medium
			self.large = large
			self.xlarge = xlarge
			self.xxlarge = xxlarge
			self.hero = hero
		}
	}

	public struct IconSizes {
		public let xxsmall: CGFloat
		public let xsmall: CGFloat
		public let small: CGFloat
		public let medium: CGFloat
		public let large: CGFloat
		public let xlarge: CGFloat

		public init(xxsmall: CGFloat, xsmall: CGFloat, small: CGFloat, medium: CGFloat, large: CGFloat, xlarge: CGFloat) {
			self.xxsmall = xxsmall
			self.xsmall = xsmall
			self.small = small
			self.medium = medium
			self.large = large
			self.xlarge = xlarge
		}
	}

	public struct ButtonSizes {
		public struct ButtonSize {
			public let textSize: CGFloat
			public let contentPadding: EdgeInsets

			public init(textSize: CGFloat, contentPadding: EdgeInsets) {
				self.textSize = textSize
				self.contentPadding = contentPadding
			}
		}

		public let small: ButtonSize
		public let medium: ButtonSize
		public let large: ButtonSize
		public let xlarge: ButtonSize

		public init(small: ButtonSize, medium: ButtonSize, large: ButtonSize, xlarge: ButtonSize) {
			self.small = small
			self.medium = medium
			self.large = large
			self.xlarge = xlarge
		}
	}

	public let text: TextSizes
	public let icons: IconSizes
	public let buttons: ButtonSizes

	public init(text: TextSizes, icons: IconSizes, buttons: ButtonSizes) {
		self.text = text
		self.icons = icons
		self.buttons = buttons
	}
}
