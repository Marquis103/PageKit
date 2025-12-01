# PageKit

A Swift Package providing a modular architecture framework for iOS applications, featuring a coordinator-based navigation pattern and a page composition system.

## Overview

PageKit provides the foundational components for building modular iOS applications with:

- **Coordinator Pattern**: UIKit-based navigation management with full lifecycle support
- **Page System**: Protocol-oriented feature composition (Page + View + ViewModel + ViewState)
- **SwiftUI Integration**: Modern UI components with UIKit navigation backbone
- **Property Wrappers**: Reactive state management helpers
- **Themeable UI**: Environment-based theming system
- **Forms**: Built-in form handling with validation and submission

## Requirements

- iOS 16.0+
- Swift 5.9+
- Xcode 16.0+

## Installation

### Swift Package Manager

Add PageKit to your project using Xcode:

1. File > Add Package Dependencies
2. Enter: `https://github.com/Marquis103/PageKit`
3. Select "Branch" and use `main`

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Marquis103/PageKit", branch: "main")
]
```

> **Note**: This is a private repository. Ensure you have access and your SSH keys are configured for GitHub.

Then import the packages you need:

```swift
import PageKit        // Core framework
import PageKitForms   // Form handling
import PageKitTheming // Theming system
import PageKitUI      // UI components
```

---

## Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         AppCoordinator                          │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │  SettingsPage   │  │    LoginForm    │  │   ProfilePage   │ │
│  │  ┌───────────┐  │  │  ┌───────────┐  │  │  ┌───────────┐  │ │
│  │  │   View    │  │  │  │   View    │  │  │  │   View    │  │ │
│  │  └─────┬─────┘  │  │  └─────┬─────┘  │  │  └─────┬─────┘  │ │
│  │        │        │  │        │        │  │        │        │ │
│  │  ┌─────▼─────┐  │  │  ┌─────▼─────┐  │  │  ┌─────▼─────┐  │ │
│  │  │ ViewModel │  │  │  │ ViewModel │  │  │  │ ViewModel │  │ │
│  │  └─────┬─────┘  │  │  └─────┬─────┘  │  │  └─────┬─────┘  │ │
│  │        │        │  │        │        │  │        │        │ │
│  │  ┌─────▼─────┐  │  │  ┌─────▼─────┐  │  │  ┌─────▼─────┐  │ │
│  │  │ ViewState │  │  │  │ ViewState │  │  │  │ ViewState │  │ │
│  │  └───────────┘  │  │  └───────────┘  │  │  └───────────┘  │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### Data Flow

```
┌──────────────┐     events      ┌──────────────┐    mutations    ┌──────────────┐
│              │ ───────────────▶│              │ ───────────────▶│              │
│   PageView   │                 │ PageViewModel│                 │ PageViewState│
│              │◀─────────────── │              │◀─────────────── │              │
└──────────────┘  @ObservedObject└──────────────┘    @Published   └──────────────┘
       │                                │
       │         PageEventHandler       │
       └────────────────────────────────┘
```

- **PageView** observes ViewState for UI updates
- **PageView** sends events to ViewModel via PageEventHandler
- **PageViewModel** mutates ViewState in response to events
- **PageViewModel** coordinates navigation actions via Coordinator

### Navigation Flow

```
                    ┌───────────────────┐
                    │   Coordinator     │
                    │                   │
                    │  coordinate(      │
                    │    action:        │◀──────────────────┐
                    │  )                │                   │
                    └─────────┬─────────┘                   │
                              │                             │
                    ┌─────────▼─────────┐                   │
                    │                   │                   │
                    │  navigate(        │                   │
                    │    to: VC,        │                   │
                    │    with: action   │                   │
                    │  )                │                   │
                    └─────────┬─────────┘                   │
                              │                             │
              ┌───────────────┼───────────────┐             │
              │               │               │             │
              ▼               ▼               ▼             │
        ┌──────────┐   ┌──────────┐   ┌──────────┐         │
        │  .push   │   │ .present │   │  .modal  │         │
        └──────────┘   └──────────┘   └──────────┘         │
                              │                             │
                    ┌─────────▼─────────┐                   │
                    │                   │                   │
                    │ PageHostController│                   │
                    │  ┌─────────────┐  │                   │
                    │  │    Page     │  │                   │
                    │  │ ┌─────────┐ │  │                   │
                    │  │ │ViewModel├─┼──┼───────────────────┘
                    │  │ └─────────┘ │  │   coordinate(action:)
                    │  └─────────────┘  │
                    └───────────────────┘
```

### Page Composition

```
┌─────────────────────────────────────────────────────────┐
│                         Page                            │
│                                                         │
│  init(coordinator: Coordinating)                        │
│    │                                                    │
│    ├──▶ viewState = ViewState()                         │
│    │                                                    │
│    ├──▶ viewModel = ViewModel(                          │
│    │        coordinator: coordinator,                   │
│    │        viewState: viewState                        │
│    │    )                                               │
│    │                                                    │
│    └──▶ view = View(                                    │
│             viewState: viewState,                       │
│             handler: PageEventHandler(viewModel)        │
│         )                                               │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Start

### 1. Generate a Page

Use the included generator script:

```bash
# Standard page
swift Scripts/generate_page.swift Settings

# Form page
swift Scripts/generate_page.swift Login --form
```

This creates 4 files:
- `SettingsPage.swift` - Page class
- `SettingsViewModel.swift` - Business logic
- `SettingsViewState.swift` - Observable state
- `SettingsView.swift` - SwiftUI view

### 2. Create a Coordinator

```swift
import PageKit

final class AppCoordinator: Coordinator {
    override func start(with action: NavigationAction) {
        showSettings()
    }

    func showSettings() {
        let page = SettingsPage(coordinator: self)
        let controller = PageHostController(
            page: page,
            mode: .normal,
            rewinder: Rewinder(rewindStyle: .chevron) { [weak self] in
                self?.rewind()
            }
        )
        navigate(to: controller, with: .push(rewindStyle: .chevron))
    }

    override func coordinate(action: CoordinatableAction) {
        switch action {
        case SettingsPage.Action.editProfile:
            showProfile()
        default:
            break
        }
    }
}
```

### 3. Start from SceneDelegate

```swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        coordinator = AppCoordinator(rootViewController: navigationController)
        coordinator?.start(with: .none)
    }
}
```

---

## Core Concepts

### Page

A `Page` represents a self-contained feature with its own view, state, and business logic:

```swift
public protocol Page {
    associatedtype Action: CoordinatableAction
    associatedtype Signal = Void
    associatedtype ViewModel: PageViewModel<Self>
    associatedtype ViewState: PageViewState
    associatedtype View: PageView

    var coordinator: Coordinating { get }
    var viewModel: ViewModel { get }
    var viewState: ViewState { get }
    var view: View { get }
}
```

Example implementation:

```swift
final class SettingsPage: Page {
    enum Action: CoordinatableAction {
        case editProfile
        case logout
    }

    let coordinator: Coordinating
    let viewState: SettingsViewState
    let viewModel: SettingsViewModel
    let view: SettingsView

    init(coordinator: Coordinating) {
        self.coordinator = coordinator
        self.viewState = SettingsViewState()
        self.viewModel = SettingsViewModel(coordinator: coordinator, viewState: viewState)
        self.view = SettingsView(viewState: viewState, handler: PageEventHandler(viewModel))
    }
}
```

### PageView

A SwiftUI view that conforms to `PageView`:

```swift
public protocol PageView: View {
    associatedtype State: PageViewState
    associatedtype Event = Void

    var viewState: State { get }
}
```

Example:

```swift
struct SettingsView: PageView {
    enum Event {
        case editProfileTapped
        case logoutTapped
    }

    @ObservedObject var viewState: SettingsViewState
    let handler: PageEventHandler<Event>

    var body: some View {
        List {
            Button("Edit Profile") {
                handler(.editProfileTapped)
            }

            Button("Logout") {
                handler(.logoutTapped)
            }
        }
    }
}
```

### PageViewModel

Handles business logic and lifecycle events:

```swift
open class PageViewModel<P: Page>: PageViewModelProtocol, PageEventHandlable {
    public let viewState: P.ViewState

    // Lifecycle methods
    open func onStart() async { }
    open func onResume() async { }
    open func onPause() async { }
    open func onEnd() { }

    // Event handling
    open func handle(event: P.View.Event) { }

    // Navigation
    public func coordinate(action: P.Action) { }
}
```

Example:

```swift
@MainActor
final class SettingsViewModel: PageViewModel<SettingsPage> {
    override func onStart() async {
        await loadSettings()
    }

    override func handle(event: SettingsView.Event) async {
        switch event {
        case .editProfileTapped:
            coordinate(action: .editProfile)
        case .logoutTapped:
            coordinate(action: .logout)
        }
    }

    private func loadSettings() async {
        viewState.isLoading = true
        // Load settings...
        viewState.isLoading = false
    }
}
```

### PageViewState

Observable state for the view:

```swift
open class PageViewState: ObservableObject {
    @Published public var isLoading: Bool = false
    @Published public var error: Error?
}
```

Example:

```swift
final class SettingsViewState: PageViewState {
    @Published var username: String = ""
    @Published var notificationsEnabled: Bool = true
}
```

### Coordinator

Manages navigation flow and child coordinators:

```swift
open class Coordinator: NSObject, Coordinating {
    // Navigation
    public func navigate(to viewController: UIViewController, with action: NavigationAction)
    public func rewind(animated: Bool = true)

    // Child coordinators
    public func startCoordinator<T: Coordinator>(_ coordinator: T, withAction action: NavigationAction) -> T

    // Signals
    public func send(signal: PageSignal)

    // Lifecycle
    open func start(with action: NavigationAction)
    open func willStart()
    open func didStart()
    open func willEnd()
    open func didEnd()
}
```

---

## Navigation

### Navigation Actions

| Action | Description | Example |
|--------|-------------|---------|
| `.push(rewindStyle:)` | Push onto navigation stack | Standard drill-down |
| `.present(rewindStyle:, transition:)` | Full-screen modal | Login flow |
| `.modal` | Bottom sheet modal | Action sheet |
| `.system` | System presentation style | Share sheet |
| `.window` | Window-level presentation | Onboarding |
| `.none` | No presentation | Initial setup |

### Rewind Styles

| Style | Button |
|-------|--------|
| `.chevron` | `<` back arrow |
| `.cancel` | "Cancel" text |
| `.x` | X mark |
| `.none` | No back button |

### Example Navigation

```swift
final class ProfileCoordinator: Coordinator {
    override func start(with action: NavigationAction) {
        let page = ProfilePage(coordinator: self)
        let controller = PageHostController(page: page, rewinder: makeRewinder())
        navigate(to: controller, with: action)
    }

    override func coordinate(action: CoordinatableAction) {
        switch action {
        case ProfilePage.Action.showSettings:
            let coordinator = SettingsCoordinator(rootViewController: activeViewController)
            startCoordinator(coordinator, withAction: .push(rewindStyle: .chevron))

        case ProfilePage.Action.showImagePicker:
            let picker = UIImagePickerController()
            navigate(to: picker, with: .modal)
        }
    }

    private func makeRewinder() -> Rewinder {
        Rewinder(rewindStyle: .chevron) { [weak self] in
            self?.rewind()
        }
    }
}
```

---

## Forms

PageKitForms provides form-specific protocols:

### FormPage

```swift
public protocol FormPage: Page where ViewState: FormViewState, ViewModel: FormViewModel<Self> { }
```

### FormViewState

```swift
open class FormViewState: PageViewState {
    @Published public var isSubmitting: Bool = false
    @Published public var formError: Error?
    @Published public var fieldErrors: [String: String] = [:]
    @Published public var isDirty: Bool = false

    open func validate() -> Bool
}
```

### FormViewModel

```swift
open class FormViewModel<P: Page>: PageViewModel<P> where P.ViewState: FormViewState {
    open func submit() async throws
    public func handleSubmit() async
}
```

### Example Form

```swift
// Page
final class LoginForm: FormPage {
    enum Action: CoordinatableAction {
        case loginSuccess
    }

    let coordinator: Coordinating
    let viewState: LoginViewState
    let viewModel: LoginViewModel
    let view: LoginFormView

    init(coordinator: Coordinating) {
        self.coordinator = coordinator
        self.viewState = LoginViewState()
        self.viewModel = LoginViewModel(coordinator: coordinator, viewState: viewState)
        self.view = LoginFormView(viewState: viewState, handler: FormEventHandler(viewModel))
    }
}

// ViewState
final class LoginViewState: FormViewState {
    @Published var email: String = ""
    @Published var password: String = ""

    override func validate() -> Bool {
        fieldErrors.removeAll()

        if email.isEmpty {
            fieldErrors["email"] = "Email is required"
        }
        if password.count < 8 {
            fieldErrors["password"] = "Password must be at least 8 characters"
        }

        return fieldErrors.isEmpty
    }
}

// ViewModel
@MainActor
final class LoginViewModel: FormViewModel<LoginForm> {
    override func submit() async throws {
        try await authService.login(
            email: formViewState.email,
            password: formViewState.password
        )
        coordinate(action: .loginSuccess)
    }
}

// View
struct LoginFormView: FormView {
    enum Event { }

    @ObservedObject var viewState: LoginViewState
    let handler: FormEventHandler<Event>

    var body: some View {
        Form {
            TextField("Email", text: $viewState.email)
            SecureField("Password", text: $viewState.password)

            if let error = viewState.fieldErrors["email"] {
                Text(error).foregroundColor(.red)
            }

            Button("Login") {
                Task { await viewModel.handleSubmit() }
            }
            .disabled(viewState.isSubmitting)
        }
    }
}
```

---

## Signals

Cross-page communication via signals:

```swift
// Define signal
struct UserUpdatedSignal: PageSignal {
    let userId: String
}

// Send signal
coordinator.send(signal: UserUpdatedSignal(userId: "123"))

// Receive in ViewModel
override func handle(signal: ProfilePage.Signal) {
    if let signal = signal as? UserUpdatedSignal {
        Task { await refreshUser(id: signal.userId) }
    }
}
```

---

## Child Coordinators

For modular navigation flows:

```swift
final class AppCoordinator: Coordinator {
    func showOnboarding() {
        let coordinator = OnboardingCoordinator(rootViewController: activeViewController)
        coordinator.onComplete = { [weak self] in
            self?.showHome()
        }
        startCoordinator(coordinator, withAction: .present(rewindStyle: .none))
    }

    func showHome() {
        let coordinator = HomeCoordinator(rootViewController: activeViewController)
        startCoordinator(coordinator, withAction: .push(rewindStyle: .none))
    }
}

final class OnboardingCoordinator: Coordinator {
    var onComplete: (() -> Void)?

    override func start(with action: NavigationAction) {
        showWelcome()
    }

    func showWelcome() {
        let page = WelcomePage(coordinator: self)
        // ...
    }

    func completeOnboarding() {
        end()
        onComplete?()
    }
}
```

---

## Property Wrappers

| Wrapper | Purpose | Example |
|---------|---------|---------|
| `@ExternalizedState` | Share state across views | `@ExternalizedState var count = 0` |
| `@AnimatedState` | Animated value changes | `@AnimatedState var progress = 0.5` |
| `OptionalBinding` | Unwrap optional bindings | `OptionalBinding($text)` |

---

## Theming

### Define a Theme

```swift
struct MyTheme: Theme {
    var colors: ColorStylesProviding { MyColors() }
    var spacing: SpacingStylesProviding { MySpacing() }
    var typography: TypographyStylesProviding { MyTypography() }
}
```

### Apply Theme

```swift
MyRootView()
    .environment(\.theme, AnyTheme(MyTheme()))
```

---

## License

Copyright 2025 PageKit. All rights reserved.
