//
//  PageHosting.swift
//
//  Copyright © 2026 PageKit All rights reserved.
//

// MARK: - PageHosting

/// App-wide settings for PageKit's UIKit hosts: `PageHostController`, `SheetController` and
/// `ModalController`.
@MainActor
public enum PageHosting {
	/// Whether pages follow the user's text size. Defaults to ``PageDynamicType/pinned``, so an
	/// app that never sets it renders exactly as before.
	///
	/// A host reads this when it builds its page, so set it once at launch, before the first page
	/// is presented. A page already on screen keeps the value it was built with.
	///
	/// ```swift
	/// // In the App's init, or application(_:didFinishLaunchingWithOptions:):
	/// PageHosting.dynamicType = .system
	/// ```
	public static var dynamicType: PageDynamicType = .pinned
}
