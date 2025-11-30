//
//  PageContainer.swift
//
//  Copyright © 2025 PageKit. All rights reserved.
//

import PageKit
import SwiftUI
import UIKit

// MARK: - PageContainer

/// A UIViewController that hosts multiple Pages in a configurable layout.
///
/// `PageContainer` is the UIKit bridge that enables multi-page layouts within
/// the existing PageKit coordinator system. It hosts a SwiftUI layout view
/// and manages Page assignment to slots.
///
/// ```swift
/// // In a coordinator:
/// let layout = SplitLayout<SettingsSlots>(
///     sidebarSlot: .menu,
///     detailSlot: .detail
/// )
/// let container = PageContainer(layout: layout, coordinator: self)
/// container.assign(MenuPage(coordinator: self), to: .menu)
/// container.assign(DetailPage(coordinator: self), to: .detail)
/// navigate(to: container, with: .push(rewindStyle: .chevron))
/// ```
@available(iOS 17, *)
public class PageContainer<Layout: ContainerLayout>: UIViewController {
	// MARK: - Properties

	private let layout: Layout
	private let coordinator: Coordinating
	private var slotPages: [Layout.Slot: any Page] = [:]
	private var hostingController: UIHostingController<AnyView>?

	/// The current layout being used.
	public var currentLayout: Layout { layout }

	// MARK: - Initialization

	/// Creates a container with the given layout and coordinator.
	/// - Parameters:
	///   - layout: The layout defining how slots are arranged.
	///   - coordinator: The coordinator managing this container's Pages.
	public init(layout: Layout, coordinator: Coordinating) {
		self.layout = layout
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View Lifecycle

	public override func viewDidLoad() {
		super.viewDidLoad()
		setupHostingController()
	}

	// MARK: - Slot Management

	/// Assigns a Page to a slot.
	///
	/// If the slot already has a Page, it will be replaced. The new Page's
	/// lifecycle methods (`onStart`, etc.) will be called when the slot's
	/// view appears.
	///
	/// - Parameters:
	///   - page: The Page to assign.
	///   - slot: The slot to assign it to.
	public func assign<P: Page>(_ page: P, to slot: Layout.Slot) {
		slotPages[slot] = page
		rebuildView()
	}

	/// Clears a slot's content.
	///
	/// The previous Page's `onEnd()` will be called when it's deallocated.
	///
	/// - Parameter slot: The slot to clear.
	public func clear(slot: Layout.Slot) {
		slotPages.removeValue(forKey: slot)
		rebuildView()
	}

	/// Retrieves the Page in a given slot, cast to the expected type.
	///
	/// - Parameters:
	///   - slot: The slot to query.
	///   - type: The expected Page type.
	/// - Returns: The Page if it exists and matches the type, nil otherwise.
	public func page<P: Page>(in slot: Layout.Slot, as type: P.Type) -> P? {
		slotPages[slot] as? P
	}

	/// Returns whether a slot has a Page assigned.
	/// - Parameter slot: The slot to check.
	/// - Returns: `true` if the slot has content.
	public func hasContent(in slot: Layout.Slot) -> Bool {
		slotPages[slot] != nil
	}

	/// Returns all slots that currently have Pages assigned.
	public var populatedSlots: [Layout.Slot] {
		Array(slotPages.keys)
	}

	// MARK: - Private Methods

	private func setupHostingController() {
		let containerView = buildContainerView()
		let hosting = UIHostingController(rootView: AnyView(containerView))

		addChild(hosting)
		view.addSubview(hosting.view)
		hosting.view.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			hosting.view.topAnchor.constraint(equalTo: view.topAnchor),
			hosting.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			hosting.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			hosting.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])

		hosting.didMove(toParent: self)
		self.hostingController = hosting
	}

	private func rebuildView() {
		guard let hosting = hostingController else { return }
		let containerView = buildContainerView()
		hosting.rootView = AnyView(containerView)
	}

	private func buildContainerView() -> some View {
		let provider = buildSlotProvider()
		return layout.body(slots: provider)
	}

	private func buildSlotProvider() -> SlotContentProvider<Layout.Slot> {
		var contents: [Layout.Slot: AnyView] = [:]
		for (slot, page) in slotPages {
			contents[slot] = AnyView(AnyPageSlot(page: page))
		}
		return SlotContentProvider(contents: contents)
	}
}
