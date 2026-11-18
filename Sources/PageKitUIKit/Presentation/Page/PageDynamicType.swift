//
//  PageDynamicType.swift
//
//  Copyright © 2026 PageKit All rights reserved.
//

// MARK: - PageDynamicType

/// Whether the pages a PageKit host presents follow the user's text size (Dynamic Type).
///
/// Chosen app-wide through ``PageHosting/dynamicType``. `PageContentWrapper` applies it, so it
/// reaches every page `PageHostController`, `SheetController` and `ModalController` present.
public enum PageDynamicType: Sendable, Equatable {
	/// Every page renders at `ContentSizeCategory.large`, the system's default text size, whatever
	/// the user chose in Settings. The default, and PageKit's behavior since its first release.
	case pinned

	/// Pages inherit the user's text size, accessibility sizes included. Layouts must then hold
	/// up to the largest size (AX5).
	case system
}
