//
//  Icon.swift
//
//  Copyright © 2025 theCut, Inc. All rights reserved.
//

import SwiftUI
import PageKitTheming

/// A SwiftUI view component for displaying icons with theme-integrated sizing and coloring
///
/// Icon accepts any type conforming to ImageIconProtocol, allowing consuming applications
/// to provide their own icon asset types (typically SwiftGen-generated).
///
/// Example usage:
/// ```swift
/// // In consuming app, make your ImageIcon conform to protocol:
/// extension ImageIcon: ImageIconProtocol {
///     public var asSwiftUIImage: SwiftUI.Image { swiftUIImage }
/// }
///
/// // Then use Icon component:
/// Icon(icon: Icons.Bold.calendar)
///     .iconSize(.large)
///     .iconColor(.blue)
/// ```
public struct Icon<T: ImageIconProtocol>: View {
	public let icon: T

	private(set) var iconColor: Color?
	private(set) var iconSize: IconSize = .medium
	private(set) var multiColorIcon: Bool = false

	@Environment(\.theme)
	private var theme: AnyTheme

	/// Creates an icon view
	/// - Parameter icon: The icon asset conforming to ImageIconProtocol
	public init(icon: T) {
		self.icon = icon
	}

	public var body: some View {
		let size = iconSize.resolve(from: theme)

		icon.asSwiftUIImage
			.resizable()
			.renderingMode(multiColorIcon ? .original : .template)
			.aspectRatio(contentMode: .fit)
			.foregroundColor(iconColor ?? theme.colors.primary)
			.frame(width: size, height: size)
	}

	/// Sets the icon color
	/// - Parameter iconColor: The desired color for the icon
	/// - Returns: A modified icon with the new color
	public func iconColor(_ iconColor: Color) -> Self {
		var this = self
		this.iconColor = iconColor
		return this
	}

	/// Sets the icon size
	/// - Parameter iconSize: The desired size for the icon
	/// - Returns: A modified icon with the new size
	public func iconSize(_ iconSize: IconSize) -> Self {
		var this = self
		this.iconSize = iconSize
		return this
	}

	/// Configures whether the icon should render in multi-color mode
	/// - Parameter multiColorIcon: If true, renders the icon in its original colors
	/// - Returns: A modified icon with the new rendering mode
	public func multiColorIcon(_ multiColorIcon: Bool) -> Self {
		var this = self
		this.multiColorIcon = multiColorIcon
		return this
	}
}
