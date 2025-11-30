# PageKitContainers

A multi-page container system for PageKit that enables iPad-style layouts with multiple Pages displayed simultaneously.

## Overview

PageKitContainers extends PageKit with the ability to display multiple Pages on screen at the same time. This is essential for iPad apps that need split views, multi-column layouts, or dashboard-style interfaces.

### Key Features

- **Multiple Layout Types**: Split view, triple column, grid, and stack layouts
- **Unified Lifecycle**: Pages work identically whether standalone or in containers
- **Coordinator Integration**: Seamless integration with PageKit's coordinator pattern
- **Signal-Based Communication**: Cross-page communication via the coordinator's signal system
- **Size Class Adaptation**: Layouts can adapt to compact/regular size classes

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Coordinator                               │
│                   (ContainerCoordinating)                        │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                    PageContainer                         │    │
│  │                   (UIViewController)                     │    │
│  │  ┌─────────────────────────────────────────────────┐    │    │
│  │  │              ContainerLayout                     │    │    │
│  │  │            (e.g. SplitLayout)                    │    │    │
│  │  │  ┌──────────────┐    ┌──────────────┐          │    │    │
│  │  │  │   PageSlot   │    │   PageSlot   │          │    │    │
│  │  │  │  (sidebar)   │    │   (detail)   │          │    │    │
│  │  │  │  ┌────────┐  │    │  ┌────────┐  │          │    │    │
│  │  │  │  │  Page  │  │    │  │  Page  │  │          │    │    │
│  │  │  │  └────────┘  │    │  └────────┘  │          │    │    │
│  │  │  └──────────────┘    └──────────────┘          │    │    │
│  │  └─────────────────────────────────────────────────┘    │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

## Core Components

### ContainerSlot

Defines named regions in a container layout:

```swift
enum SettingsSlots: String, ContainerSlot {
    case menu, detail
    static var primary: SettingsSlots { .menu }
}
```

### ContainerLayout

Defines how slots are visually arranged:

```swift
public protocol ContainerLayout {
    associatedtype Slot: ContainerSlot
    associatedtype Body: View

    @MainActor @ViewBuilder
    func body(slots: SlotContentProvider<Slot>) -> Body
}
```

### PageContainer

The UIViewController that hosts multiple Pages:

```swift
let container = PageContainer(layout: layout, coordinator: self)
container.assign(MenuPage(coordinator: self), to: .menu)
container.assign(DetailPage(coordinator: self), to: .detail)
navigate(to: container, with: .push(rewindStyle: .chevron))
```

### PageSlot

SwiftUI view that wraps a Page with lifecycle management:

```swift
// Internally used by PageContainer
// Calls onStart/onResume when appearing, onPause when disappearing
PageSlot(page: myPage)
```

## Available Layouts

### SplitLayout

Two-column split view using NavigationSplitView:

```
┌─────────────┬─────────────────────────┐
│             │                         │
│   Sidebar   │        Detail           │
│    Slot     │         Slot            │
│             │                         │
└─────────────┴─────────────────────────┘
```

```swift
let layout = SplitLayout<SettingsSlots>(
    sidebarSlot: .menu,
    detailSlot: .detail,
    preferredSidebarWidth: 320
)
```

### TripleColumnLayout

Three-column layout (Mail.app style):

```
┌──────────┬──────────┬───────────────────┐
│          │          │                   │
│ Sidebar  │ Content  │      Detail       │
│   Slot   │   Slot   │       Slot        │
│          │          │                   │
└──────────┴──────────┴───────────────────┘
```

```swift
let layout = TripleColumnLayout<MailSlots>(
    sidebarSlot: .folders,
    contentSlot: .messages,
    detailSlot: .preview
)
```

### GridContainerLayout

Flexible grid for dashboard-style interfaces:

```
┌─────────────┬─────────────┐
│   Slot 1    │   Slot 2    │
├─────────────┼─────────────┤
│   Slot 3    │   Slot 4    │
└─────────────┴─────────────┘
```

```swift
let layout = GridContainerLayout<DashboardSlots>(
    columns: 2,
    slots: [.stats, .chart, .activity, .alerts],
    spacing: 16,
    minItemHeight: 200
)
```

### StackLayout

Simple vertical or horizontal stacking:

```
┌─────────────────────────┐
│         Slot 1          │
├─────────────────────────┤
│         Slot 2          │
└─────────────────────────┘
```

```swift
let layout = StackLayout<PanelSlots>(
    axis: .vertical,
    slots: [.header, .content],
    spacing: 8
)
```

## Usage

### Basic Setup

1. Define your slots:

```swift
enum SettingsSlots: String, ContainerSlot {
    case menu, detail
    static var primary: SettingsSlots { .menu }
}
```

2. Create a coordinator that adopts `ContainerCoordinating`:

```swift
class SettingsCoordinator: Coordinator, ContainerCoordinating {
    typealias ContainerSlotType = SettingsSlots
    typealias ContainerLayoutType = SplitLayout<SettingsSlots>

    private(set) var container: PageContainer<SplitLayout<SettingsSlots>>?

    override func start(with action: NavigationAction) {
        let layout = SplitLayout<SettingsSlots>(
            sidebarSlot: .menu,
            detailSlot: .detail
        )

        let container = createContainer(with: layout)
        self.container = container

        container.assign(MenuPage(coordinator: self), to: .menu)
        container.assign(WelcomePage(coordinator: self), to: .detail)

        navigate(to: container, with: action)
    }
}
```

3. Update slots dynamically:

```swift
func showSettings(section: SettingsSection) {
    let page = SettingsDetailPage(section: section, coordinator: self)
    container?.assign(page, to: .detail)
}
```

### Cross-Page Communication

Use signals to communicate between Pages in a container:

```swift
// Define a signal
struct MenuSelection: ContainerSlotSignal {
    typealias Slot = SettingsSlots
    let selectedItem: MenuItem
    var targetSlot: SettingsSlots { .detail }
}

// Send from MenuPage
coordinator.send(signal: MenuSelection(selectedItem: item))

// Receive in DetailPage
coordinator.signalPublisher
    .compactMap { $0 as? MenuSelection }
    .sink { [weak self] signal in
        self?.loadContent(for: signal.selectedItem)
    }
    .store(in: &cancellables)
```

### Size Class Adaptation

Layouts can adapt to different size classes:

```swift
// GridContainerLayout automatically uses single column on compact
public func adapted(for horizontalSizeClass: UserInterfaceSizeClass?) -> any ContainerLayout {
    if horizontalSizeClass == .compact {
        return GridContainerLayout(
            columns: 1,
            slots: slots,
            spacing: spacing,
            minItemHeight: minItemHeight
        )
    }
    return self
}
```

## Page Lifecycle in Containers

Pages in containers receive the same lifecycle callbacks as standalone Pages:

| Event | Callback |
|-------|----------|
| Slot appears (first time) | `onStart()` |
| Slot appears (subsequent) | `onResume()` |
| Slot disappears | `onPause()` |
| Slot cleared/deallocated | `onEnd()` |

## Data Flow

```
┌─────────────────────────────────────────────────────────────┐
│                       Coordinator                            │
│                                                              │
│  send(signal:) ─────────────────────────────────────────┐   │
│                                                          │   │
│  ┌───────────────────┐      ┌───────────────────┐       │   │
│  │    Menu Page      │      │   Detail Page     │       │   │
│  │                   │      │                   │       │   │
│  │ User taps item    │      │ Receives signal   │◄──────┘   │
│  │        │          │      │        │          │           │
│  │        ▼          │      │        ▼          │           │
│  │ coordinator       │      │ Updates content   │           │
│  │ .send(signal)     │      │                   │           │
│  └───────────────────┘      └───────────────────┘           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Requirements

- iOS 17.0+
- Swift 5.9+
- PageKit

## Installation

PageKitContainers is included as a separate library in the PageKit package:

```swift
dependencies: [
    .package(url: "https://github.com/your-org/PageKit.git", from: "1.0.0")
]

targets: [
    .target(
        name: "YourApp",
        dependencies: [
            "PageKit",
            "PageKitContainers"
        ]
    )
]
```

## API Reference

### Protocols

- `ContainerSlot` - Defines slot identifiers
- `ContainerLayout` - Defines visual arrangement
- `ContainerCoordinating` - Coordinator protocol for container management
- `ContainerSlotSignal` - Signal type for slot-based communication
- `ContainerNavigationStep` - Navigation step protocol for slot targeting

### Layouts

- `SplitLayout` - Two-column NavigationSplitView
- `TripleColumnLayout` - Three-column NavigationSplitView
- `GridContainerLayout` - Flexible grid using LazyVGrid
- `StackLayout` - Vertical or horizontal stack

### Views

- `PageContainer` - UIViewController hosting multiple Pages
- `PageSlot` - SwiftUI view wrapping a Page
- `SlotContentProvider` - Type-safe slot content access
