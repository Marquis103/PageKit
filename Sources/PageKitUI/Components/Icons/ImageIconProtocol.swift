//
//  ImageIconProtocol.swift
//
//  Copyright © 2025 PageKit All rights reserved.
//

import SwiftUI

/// Protocol that consuming applications must conform to for their icon assets
/// This allows PageKitUI to remain asset-agnostic while supporting
/// icon-based components like buttons and other UI elements.
///
/// Consuming apps should extend their SwiftGen-generated ImageIcon type to conform:
/// ```swift
/// extension ImageIcon: ImageIconProtocol {
///     public var asSwiftUIImage: SwiftUI.Image {
///         swiftUIImage
///     }
/// }
/// ```
public protocol ImageIconProtocol {
	/// The name/identifier of the icon asset
	var name: String { get }

	/// SwiftUI Image representation of the icon
	var asSwiftUIImage: SwiftUI.Image { get }
}
