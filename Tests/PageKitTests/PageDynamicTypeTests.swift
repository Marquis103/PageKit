//
//  PageDynamicTypeTests.swift
//
//  Copyright © 2026 PageKit All rights reserved.
//

import SwiftUI
import Testing
import UIKit
import PageKit

// MARK: - The probe

/// Remembers the text size the probe's body last saw.
@MainActor
private final class TextSizeRecorder {
	private(set) var seen: DynamicTypeSize?

	func record(_ size: DynamicTypeSize) {
		seen = size
	}
}

/// A page body that reports the text size its environment carries.
private struct TextSizeProbe: View {
	let recorder: TextSizeRecorder

	@Environment(\.dynamicTypeSize)
	private var dynamicTypeSize

	var body: some View {
		let _ = recorder.record(dynamicTypeSize)
		Text("Probe")
	}
}

// MARK: - A minimal page around the probe

private enum ProbeAction: CoordinatableAction {}

@MainActor
private final class ProbeCoordinator: Coordinating {}

private final class ProbeViewState: PageViewState {}

private final class ProbeViewModel: PageViewModel<ProbePage> {}

private struct ProbePageView: PageView {
	let viewState: ProbeViewState
	let recorder: TextSizeRecorder

	var body: some View {
		TextSizeProbe(recorder: recorder)
	}
}

private final class ProbePage: Page {
	typealias Action = ProbeAction

	let coordinator: Coordinating
	let viewState: ProbeViewState
	let viewModel: ProbeViewModel
	let view: ProbePageView

	@MainActor
	init(recorder: TextSizeRecorder) {
		let coordinator = ProbeCoordinator()
		let viewState = ProbeViewState()
		self.coordinator = coordinator
		self.viewState = viewState
		viewModel = ProbeViewModel(coordinator: coordinator, viewState: viewState)
		view = ProbePageView(viewState: viewState, recorder: recorder)
	}
}

// MARK: - Rendering

/// Puts `controller` in a window with the given system text size and lays it out, then returns
/// the size the probe saw (nil if its body never ran).
@MainActor
private func textSizeSeen(
	by recorder: TextSizeRecorder,
	hostedIn controller: UIViewController,
	systemTextSize: UIContentSizeCategory
) async -> DynamicTypeSize? {
	controller.traitOverrides.preferredContentSizeCategory = systemTextSize
	let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 390, height: 844))
	window.rootViewController = controller
	window.isHidden = false
	defer { window.isHidden = true }

	for _ in 0 ..< 50 where recorder.seen == nil {
		controller.view.setNeedsLayout()
		controller.view.layoutIfNeeded()
		try? await Task.sleep(for: .milliseconds(10))
	}
	return recorder.seen
}

// MARK: - PageContentWrapper

@Suite("PageContentWrapper text size")
@MainActor
struct PageContentWrapperTextSizeTests {

	@Test(
		"A pinned wrapper renders its page at the default size whatever the system text size",
		arguments: [
			UIContentSizeCategory.extraSmall,
			.extraExtraLarge,
			.accessibilityExtraExtraExtraLarge,
		]
	)
	func pinnedIgnoresTheSystemSize(systemTextSize: UIContentSizeCategory) async {
		let recorder = TextSizeRecorder()
		let host = UIHostingController(
			rootView: PageContentWrapper(dynamicType: .pinned) { TextSizeProbe(recorder: recorder) }
		)

		let seen = await textSizeSeen(by: recorder, hostedIn: host, systemTextSize: systemTextSize)

		#expect(seen == .large)
	}

	@Test(
		"A system wrapper passes the user's text size through to its page",
		arguments: [
			(UIContentSizeCategory.extraSmall, DynamicTypeSize.xSmall),
			(.extraExtraLarge, .xxLarge),
			(.accessibilityExtraExtraExtraLarge, .accessibility5),
		]
	)
	func systemFollowsTheSystemSize(systemTextSize: UIContentSizeCategory, expected: DynamicTypeSize) async {
		let recorder = TextSizeRecorder()
		let host = UIHostingController(
			rootView: PageContentWrapper(dynamicType: .system) { TextSizeProbe(recorder: recorder) }
		)

		let seen = await textSizeSeen(by: recorder, hostedIn: host, systemTextSize: systemTextSize)

		#expect(seen == expected)
	}
}

// MARK: - PageHosting.dynamicType through the real hosts

/// `.serialized`: these tests write the app-wide setting, so they must not overlap one another.
/// No other suite reads it.
@Suite("PageHosting.dynamicType", .serialized)
@MainActor
struct PageHostingDynamicTypeTests {

	private enum Host: CaseIterable, CustomTestStringConvertible {
		case page
		case modal

		var testDescription: String {
			switch self {
				case .page: "PageHostController"
				case .modal: "ModalController"
			}
		}

		@MainActor
		func controller(for page: ProbePage) -> UIViewController {
			let rewinder = Rewinder(rewindStyle: nil, rewind: nil)
			switch self {
				case .page: return PageHostController(page: page, rewinder: rewinder)
				case .modal: return ModalController(page: page, rewinder: rewinder)
			}
		}
	}

	@Test("The default is pinned, so an app that sets nothing renders as before")
	func defaultIsPinned() {
		#expect(PageHosting.dynamicType == .pinned)
	}

	@Test(
		"A host pins its page to the default size while the setting is pinned",
		arguments: Host.allCases
	)
	private func pinnedHost(_ host: Host) async {
		let recorder = TextSizeRecorder()
		let controller = host.controller(for: ProbePage(recorder: recorder))

		let seen = await textSizeSeen(
			by: recorder,
			hostedIn: controller,
			systemTextSize: .accessibilityExtraExtraExtraLarge
		)

		#expect(seen == .large)
	}

	@Test(
		"A host built after the app switches to system passes the user's text size to its page",
		arguments: Host.allCases
	)
	private func systemHost(_ host: Host) async {
		PageHosting.dynamicType = .system
		defer { PageHosting.dynamicType = .pinned }
		let recorder = TextSizeRecorder()
		let controller = host.controller(for: ProbePage(recorder: recorder))

		let seen = await textSizeSeen(
			by: recorder,
			hostedIn: controller,
			systemTextSize: .accessibilityExtraExtraExtraLarge
		)

		#expect(seen == .accessibility5)
	}
}
