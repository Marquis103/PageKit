# ModuleFramework

A Swift Package providing a modular architecture framework for iOS applications, featuring a coordinator-based navigation pattern and a module composition system.

## Overview

ModuleFramework provides the foundational components for building modular iOS applications with:

- **Coordinator Pattern**: UIKit-based navigation management
- **Module System**: Protocol-oriented feature composition
- **SwiftUI Integration**: Modern UI components with backward compatibility
- **Property Wrappers**: Reactive state management helpers
- **Themeable UI**: Environment-based theming system

## Requirements

- iOS 16.0+
- Swift 5.9+
- Xcode 16.0+

## Installation

### Swift Package Manager

Add ModuleFramework to your project using Xcode:

1. File > Add Package Dependencies
2. Enter the repository URL
3. Select the version or branch

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "your-repo-url", from: "1.0.0")
]
```

## Core Concepts

### Module

A `Module` represents a self-contained feature with its own view, state, and business logic:

```swift
protocol Module {
    associatedtype View: SwiftUI.View
    associatedtype ViewModel: ModuleViewModel
    associatedtype ViewState: ModuleViewState

    var view: View { get }
    var viewModel: ViewModel { get }
    var viewState: ViewState { get }
}
```

### Coordinator

Coordinators manage navigation flow and handle child coordinator lifecycle:

```swift
class MyCoordinator: Coordinator {
    func start() {
        let module = MyModule()
        push(module: module)
    }
}
```

Navigation actions:
- `push`: Push onto navigation stack
- `present`: Modal presentation
- `modal`: Bottom sheet modal
- `system`: System-level presentation
- `handoff`: Transfer to another coordinator

### Module Lifecycle

ViewModels can respond to lifecycle events:

```swift
class MyViewModel: ModuleViewModel {
    func onStart() {
        // Called when module first appears
    }

    func onResume() {
        // Called when returning to module
    }

    func onPause() {
        // Called when navigating away
    }

    func onEnd() {
        // Called on deallocation
    }
}
```

### State Management

#### ExternalizedState

Share state across view hierarchy:

```swift
struct ParentView: View {
    @ExternalizedState var counter = 0

    var body: some View {
        ChildView(counter: $counter)
    }
}

struct ChildView: View {
    @ExternalizedState var counter: Int

    var body: some View {
        Button("Increment") { counter += 1 }
    }
}
```

#### AnimatedState

Animated property wrapper for smooth transitions:

```swift
@AnimatedState var isExpanded = false

Button("Toggle") {
    isExpanded.toggle()
}
```

#### OptionalBinding

Convert optional bindings to non-optional:

```swift
@State var text: String?

TextField("Enter text", text: OptionalBinding($text))
```

### Theming

Define your theme conforming to the `Theme` protocol:

```swift
struct MyTheme: Theme {
    var colors: Colors {
        Colors(
            background: BackgroundColors(
                primary: Color.white,
                secondary: Color.gray
            ),
            // ... other colors
        )
    }

    var spacing: Spacing {
        Spacing(small: 8, medium: 16, large: 24)
    }

    // ... other theme properties
}
```

Apply theme at app root:

```swift
MyRootView()
    .environment(\.theme, MyTheme())
```

### Navigation and Rewinding

The `Rewinder` manages back navigation:

```swift
PagePresenter(mode: .normal) {
    MyView()
}
.environment(\.rewinder, Rewinder(rewindStyle: .chevron) {
    // Handle back navigation
})
```

Rewind styles:
- `.chevron`: Left chevron button
- `.cancel`: "Cancel" text button
- `.x`: X mark button

### Keyboard Adaptability

Control keyboard behavior with preferences:

```swift
MyView()
    .preference(
        key: KeyboardAdaptabilityPreferenceKey.self,
        value: KeyboardAdaptability(
            preventDismissOnTap: false,
            preventResizing: true,
            preventShifting: false
        )
    )
```

## Architecture Example

```swift
// 1. Define your module
struct ProfileModule: ConfigurableModule {
    typealias View = ProfileView
    typealias ViewModel = ProfileViewModel
    typealias ViewState = ProfileViewState

    let view: ProfileView
    let viewModel: ProfileViewModel
    let viewState: ProfileViewState

    init(userId: String) {
        let viewState = ProfileViewState()
        let viewModel = ProfileViewModel(userId: userId, viewState: viewState)
        let view = ProfileView(viewModel: viewModel, viewState: viewState)

        self.view = view
        self.viewModel = viewModel
        self.viewState = viewState
    }
}

// 2. Define your coordinator
class ProfileCoordinator: Coordinator {
    let userId: String

    init(userId: String, navigationController: UINavigationController) {
        self.userId = userId
        super.init(navigationController: navigationController)
    }

    override func start() {
        let module = ProfileModule(userId: userId)
        push(module: module)
    }
}

// 3. Launch from parent coordinator
func showProfile(userId: String) {
    let coordinator = ProfileCoordinator(
        userId: userId,
        navigationController: navigationController
    )
    coordinate(coordinator)
}
```

## View Helpers

### Conditional View Modifiers

Apply modifiers conditionally:

```swift
Text("Hello")
    .if(isHighlighted) { view in
        view.foregroundColor(.red)
    }
```

### Lazy View

Defer view creation until needed:

```swift
LazyView {
    ExpensiveView()
}
```

## Property Wrappers Reference

| Wrapper | Purpose | Example |
|---------|---------|---------|
| `@ExternalizedState` | Share state across views | `@ExternalizedState var count = 0` |
| `@AnimatedState` | Animated value changes | `@AnimatedState var progress = 0.5` |
| `@OptionalBinding` | Unwrap optional bindings | `OptionalBinding($text)` |

## Navigation Actions

| Action | Description | Usage |
|--------|-------------|-------|
| `push` | Push onto stack | Standard hierarchical navigation |
| `present` | Modal presentation | Full-screen modal |
| `modal` | Bottom sheet | Custom bottom sheet modal |
| `system` | System presentation | Use system presentation |
| `handoff` | Coordinator handoff | Transfer to another coordinator |

## Presentation Modes

### PageController

Standard full-page presentation with navigation bar:

```swift
let controller = PageController(
    module: myModule,
    mode: .normal,
    rewinder: rewinder
)
```

### ModalController

Bottom sheet modal presentation:

```swift
let controller = ModalController(
    module: myModule,
    mode: .normal,
    rewinder: rewinder
)
```

## Notes

This framework was extracted from a larger application and has been cleaned to remove project-specific dependencies. Some features have been simplified or removed:

- **Navigation Preferences**: The original navigation header preference system has been removed. Implement your own preference system if needed.
- **Onboarding**: Project-specific onboarding mode was removed. Implement your own onboarding flow if needed.
- **Theme Implementation**: You must provide your own `Theme` implementation. The framework provides the protocol and environment key.
- **Form Modules**: Form-specific modules were removed. Build your own form modules using the base `Module` protocol.
- **Tab Navigation**: Tab-based navigation was removed. Use standard UIKit tab bar controllers.

## License

Copyright © 2025 theCut, Inc. All rights reserved.
