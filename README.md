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
- **View Modifiers**: Animation and layout utilities

### Modules

As of 2.0.0 the page system is split along a portability seam:

| Module | Depends on | Contents |
|--------|-----------|----------|
| `PageKitCore` | — | The portable page system: `Page`, `PageView`, `PageViewModel`, `PageViewState`, `PageEventHandler`, `CoordinatableAction`, `PageSignal`, and the `Coordinating` contract. **Contains no UIKit and no Combine**, enforced by a test. |
| `PageKitUIKit` | `PageKitCore` | The platform layer: `Coordinator`, `NavigationAction`, `CoordinatingNavigation`, `PageController`, and the host/sheet/modal presentation stack. |
| `PageKit` | both | Umbrella that `@_exported import`s both halves. This is what most consumers import. |
| `PageKitTheming` | — | Protocol-based theming. |
| `PageKitUI` | `PageKitTheming`, `PageKitCore` | Buttons, icons, text, and other components. Since 2.1.0 it depends on `PageKitCore` directly rather than the `PageKit` umbrella, so it can enter the Android graph without the UIKit half; the umbrella `@_exported`s Core, so consumers see the same API. |
| `PageKitForms` | `PageKit` | Form handling with validation and submission. |
| `PageKitContainers` | `PageKit` | Multi-page container layouts for iPad. |
| `PageFramework` | all of the above | Convenience umbrella over the whole framework. |

The `PageKitCore` split exists so the page system can be ported to non-Apple platforms;
keeping it free of UIKit and Combine is a deliberate constraint, not an accident.

## Requirements

- iOS 17.0+ (required by `@Observable`)
- Swift 5.9+
- Xcode 16.0+

## Installation

### Swift Package Manager

Add PageKit to your project using Xcode:

1. File > Add Package Dependencies
2. Enter: `https://github.com/Marquis103/PageKit`
3. Select "Up to Next Major Version" from `2.0.0`

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Marquis103/PageKit", from: "2.0.0")
]
```

> **Note**: Pin to a version, not to `main`. PageKit follows semantic versioning, and
> `main` carries breaking changes between major releases. See
> [Migrating to 2.0.0](#migrating-to-200) if you are coming from 1.x.

Then import the packages you need:

```swift
import PageKit        // Umbrella — re-exports PageKitCore + PageKitUIKit
import PageKitForms   // Form handling
import PageKitTheming // Theming system
import PageKitUI      // UI components
```

Most consumers want the `PageKit` umbrella. Import the halves directly only when you
need to be explicit about portability:

```swift
import PageKitCore    // Portable page system — no UIKit, no Combine
import PageKitUIKit   // Coordinator, navigation, and presentation stack
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
└──────────────┘    @Observable  └──────────────┘                 └──────────────┘
       │                                │
       │         PageEventHandler       │
       └────────────────────────────────┘
```

- **PageView** observes ViewState for UI updates via `@Observable`
- **PageView** sends events to ViewModel via PageEventHandler
- **PageViewModel** mutates ViewState in response to events (async)
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

    var viewState: SettingsViewState
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

Handles business logic and lifecycle events. All methods are async and the class requires `@MainActor`:

```swift
@MainActor
open class PageViewModel<P: Page>: PageViewModelProtocol, PageEventHandlable {
    public let viewState: P.ViewState

    // Lifecycle methods
    open func onStart() async { }
    open func onResume() async { }
    open func onPause() async { }
    nonisolated open func onEnd() { }

    // Event handling (async)
    open func handle(event: P.View.Event) async { }

    // Signal handling (async)
    open func handle(signal: P.Signal) async { }

    // Navigation
    public func coordinate(action: P.Action) { }
}
```

Example:

```swift
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
        viewState.isRefreshing = true
        // Load settings...
        viewState.isRefreshing = false
    }
}
```

### PageViewState

Observable state for the view using Swift's `@Observable` macro:

```swift
@Observable
open class PageViewState {
    public var isRefreshing = false

    public init() {}
}
```

Example:

```swift
@Observable
final class SettingsViewState: PageViewState {
    var username: String = ""
    var notificationsEnabled: Bool = true
}
```

### Coordinator

Manages navigation flow and child coordinators:

```swift
open class Coordinator: NSObject, Coordinating, CoordinatingAction {
    // Properties
    public var coordinators: [Coordinator?] = []
    public var hasEnded: Bool { get }
    public private(set) var rootViewController: UIViewController
    public var history: [CoordinatorHistoryItem] = []
    public var activeNavigationController: UINavigationController? { get }
    public var activeViewController: UIViewController { get }
    public weak var delegate: CoordinatorDelegate?

    // Navigation
    public func navigate(to viewController: UIViewController, with action: NavigationAction)
    public func rewind(animated: Bool = true, shouldEndIfNeeded: Bool = true, completion: (() -> Void)? = nil)

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

### CoordinatorDelegate

Protocol for receiving coordinator lifecycle events:

```swift
public protocol CoordinatorDelegate: AnyObject {
    func coordinatorWillStart(_ coordinator: Coordinator)
    func coordinatorDidStart(_ coordinator: Coordinator)
    func coordinatorWillEnd(_ coordinator: Coordinator)
    func coordinatorDidEnd(_ coordinator: Coordinator)
}
```

---

## Navigation

### Navigation Actions

| Action | Description | Example |
|--------|-------------|---------|
| `.push(rewindStyle:)` | Push onto navigation stack | Standard drill-down |
| `.present(rewindStyle:, transition:)` | Full-screen modal | Login flow |
| `.sheet(configuration:)` | Native iOS bottom sheet | Settings, filters |
| `.system` | System presentation style | Share sheet |
| `.window` | Window-level presentation | Onboarding |
| `.container` | Container slot content | Multi-pane layouts |
| `.none` | No presentation | Initial setup |

> **Note**: `.modal(rewindStyle:)` is deprecated. Use `.sheet()` instead for native iOS bottom sheet presentation.

### Rewind Styles

| Style | Button |
|-------|--------|
| `.chevron` | `<` back arrow |
| `.cancel` | "Cancel" text |
| `.x` | X mark |
| `.none` | No back button |

### Sheet Configuration

The `.sheet()` action uses native `UISheetPresentationController` with full PageKit integration:
- Signals flow from parent coordinator to sheet
- Actions flow from sheet back to coordinator
- Interactive dismissal automatically updates coordinator history

#### Configuration Options

```swift
SheetConfiguration(
    detents: [.medium, .large],           // Available heights
    selectedDetent: .medium,              // Initial height
    showsGrabber: true,                   // Shows drag indicator
    cornerRadius: 16,                     // Custom corner radius
    isDismissible: true,                  // Allow swipe to dismiss
    largestUndimmedDetent: .medium,       // Dim only above this
    rewindStyle: .none,                   // Back button style
    prefersEdgeAttachedInCompactHeight: false,
    prefersScrollingExpandsWhenScrolledToEdge: true
)
```

#### Presets

| Preset | Detents | Dismissible | Use Case |
|--------|---------|-------------|----------|
| `.standard` | medium, large | Yes | General purpose |
| `.compact` | medium | Yes | Quick actions |
| `.fullScreen` | large | Yes | Full content |
| `.required` | large | No | Mandatory flows |
| `.card(height:)` | fixed height | Yes | Fixed-size cards |
| `.expandable(from:)` | fraction, large | Yes | Expandable panels |

#### Detent Types

| Detent | Description |
|--------|-------------|
| `.medium` | Half screen height |
| `.large` | Full screen height |
| `.fraction(CGFloat)` | Percentage of screen (0.0-1.0) |
| `.height(CGFloat)` | Fixed point height |

#### Usage Examples

```swift
// Standard sheet with medium/large detents
navigate(to: settingsPage, with: .sheet())

// Compact half-height sheet
navigate(to: filtersPage, with: .sheet(.compact))

// Non-dismissible for required flows
navigate(to: onboardingPage, with: .sheet(.required))

// Custom configuration
let config = SheetConfiguration(
    detents: [.fraction(0.25), .medium, .large],
    showsGrabber: true,
    cornerRadius: 24
)
navigate(to: detailsPage, with: .sheet(config))
```

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
            navigate(to: picker, with: .sheet(.compact))
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
@Observable
open class FormViewState: PageViewState {
    // State properties
    public private(set) var isValid: Bool = false
    public private(set) var errors: [String: String] = [:]
    public var isSubmitting: Bool = false
    public var isDirty: Bool = false
    public var formError: String?

    // Validation
    @discardableResult open func validate() -> Bool
    @discardableResult public func validateField<Value>(_ field: String, value: Value, validators: [FormValidator<Value>]) -> Bool
    public func errorForField(_ field: String) -> String?
    public func hasError(for field: String) -> Bool

    // State management
    public func clearErrors()
    public func clearError(for field: String)
    public func setError(for field: String, error: String)
    public func reset()

    // Submission helpers
    public func beginSubmission()
    public func endSubmission()
    public func handleSubmissionError(_ error: Error)
}
```

### FormViewModel

```swift
@MainActor
open class FormViewModel<P: Page>: PageViewModel<P> where P.ViewState: FormViewState {
    public var formViewState: P.ViewState { viewState }

    open func submit() async throws
    public func handleSubmit() async
    @discardableResult public func validate() -> Bool
    @discardableResult open func validateField(_ field: String) -> Bool
}
```

### FormError

```swift
public enum FormError: LocalizedError {
    case validationFailed
    case submissionFailed(String)
    case networkError
    case unknown
}
```

### Built-in Validators

```swift
// String validators
FormValidator.required           // Non-empty string
FormValidator.email              // Valid email format
FormValidator.minLength(8)       // Minimum length
FormValidator.maxLength(100)     // Maximum length
FormValidator.exactLength(6)     // Exact length
FormValidator.regex(pattern, message:) // Custom regex
FormValidator.containsUppercase  // At least one uppercase
FormValidator.containsLowercase  // At least one lowercase
FormValidator.containsNumber     // At least one digit
FormValidator.containsSpecialCharacter // Special character
FormValidator.phoneNumber        // US phone format
FormValidator.url                // Valid URL

// Comparable validators
FormValidator.min(0)             // Minimum value
FormValidator.max(100)           // Maximum value
FormValidator.range(0, 100)      // Value range

// Composition
validator1.and(validator2)       // Both must pass
validator1.or(validator2)        // Either must pass
FormValidator.compose([...])     // Chain multiple
validator.optional()             // Allow nil
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
        self.view = LoginFormView(viewState: viewState, handler: PageEventHandler(viewModel))
    }
}

// ViewState
@Observable
final class LoginViewState: FormViewState {
    var email: String = ""
    var password: String = ""

    override func validate() -> Bool {
        validateField("email", value: email, validators: [.required, .email])
        validateField("password", value: password, validators: [.required, .minLength(8)])
        return isValid
    }
}

// ViewModel
final class LoginViewModel: FormViewModel<LoginForm> {
    private let authService: AuthService

    init(coordinator: Coordinating, viewState: LoginViewState, authService: AuthService = .shared) {
        self.authService = authService
        super.init(coordinator: coordinator, viewState: viewState)
    }

    override func submit() async throws {
        try await authService.login(
            email: formViewState.email,
            password: formViewState.password
        )
        coordinate(action: .loginSuccess)
    }
}

// View
struct LoginFormView: PageView {
    enum Event { }

    var viewState: LoginViewState
    let handler: PageEventHandler<Event>

    var body: some View {
        Form {
            TextField("Email", text: Binding(
                get: { viewState.email },
                set: { viewState.email = $0; viewState.isDirty = true }
            ))

            SecureField("Password", text: Binding(
                get: { viewState.password },
                set: { viewState.password = $0; viewState.isDirty = true }
            ))

            if let error = viewState.errorForField("email") {
                Text(error).foregroundColor(.red)
            }

            if let error = viewState.errorForField("password") {
                Text(error).foregroundColor(.red)
            }

            if let formError = viewState.formError {
                Text(formError).foregroundColor(.red)
            }

            Button("Login") {
                // Submit handled via ViewModel
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
override func handle(signal: ProfilePage.Signal) async {
    if let signal = signal as? UserUpdatedSignal {
        await refreshUser(id: signal.userId)
    }
}
```

`PageViewModel` subscribes for you, so `handle(signal:)` is all most code needs. To
observe the stream directly, use `signals()`:

```swift
for await signal in coordinator.signals() {
    // ...
}
```

`signals()` is multicast — every caller gets its own `AsyncStream` and every subscriber
receives every signal.

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

## View Modifiers

PageKit includes utility view modifiers:

| Modifier | Purpose | Usage |
|----------|---------|-------|
| `.fadeIn()` | Fade in animation on appear | `view.fadeIn()` |
| `.shake(_:count:duration:maxOffset:)` | Shake animation | `view.shake($trigger)` |
| `.hidden(_:)` | Conditional visibility | `view.hidden(isHidden)` |
| `.if(_:then:)` | Conditional modifier | `view.if(condition) { $0.opacity(0.5) }` |
| `.let(_:transform:)` | Unwrap and transform | `view.let(optionalValue) { v, val in ... }` |
| `.pop(trigger:scale:)` | Pop scale animation | `view.pop(trigger: $trigger)` |
| `.strikethrough(_:)` | Animated strikethrough | `view.strikethrough(isComplete)` |
| `.bottomPinned()` | Pin content to bottom | `view.bottomPinned()` |
| `.onLongPress(_:minimumDuration:)` | Long press gesture | `view.onLongPress { ... }` |
| `.onSizeChange(_:)` | Size change callback | `view.onSizeChange { size in ... }` |

Example usage:

```swift
VStack {
    Text("Hello")
        .fadeIn()

    Button("Submit") { }
        .shake($showError, count: 5, duration: 0.3)

    Text("Optional content")
        .hidden(shouldHide)
}
```

---

## Preferences

### KeyboardAdaptability

Control keyboard behavior for views:

```swift
public struct KeyboardAdaptability: Equatable {
    public var preventResizing: Bool    // Prevent view resizing
    public var preventShifting: Bool    // Prevent view shifting
    public var preventDismissOnTap: Bool // Prevent tap-to-dismiss

    public init(
        preventResizing: Bool = false,
        preventShifting: Bool = false,
        preventDismissOnTap: Bool = false
    )
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

## 2.1.0 — the Android pass

`PageKitCore`, `PageKitTheming` and `PageKitUI` compile and compose for Android under
[Skip Fuse](https://skip.dev). **iOS consumers are unaffected**: the manifest declares
zero package dependencies and no plugins unless the consuming Skip app's build exports
`SKIP_ANDROID` for its gradle session, so a plain Xcode resolve of 2.1.0 sees exactly
the 2.0.0 graph. The full wiring, the two source rules the Android pass depends on
(direct `View` listing on `TextConfigurable`/`ButtonConfigurable` conformers, and the
`// skipstone: internal` markers), and the per-component status table live in
[`PORTABILITY.md`](./PORTABILITY.md). On-device render evidence for the 2.1.0 pass is
committed under [`evidence/w2.1-android-pass/`](./evidence/w2.1-android-pass/).

---

## Migrating to 2.0.0

2.0.0 splits `PageKit` into `PageKitCore` (portable) and `PageKitUIKit` (platform), with
`PageKit` remaining as an `@_exported` umbrella over both. **If you `import PageKit`, your
imports need no changes.**

There is one source-breaking change and one subtler one.

### `signalPublisher` is removed

`PageSignalPublisher.signalPublisher` — `AnyPublisher<PageSignal, Never>` — is gone.
Signals are now delivered as an `AsyncStream`:

```swift
// Before (1.x)
coordinator.signalPublisher
    .sink { signal in handle(signal) }
    .store(in: &cancellables)

// After (2.0.0)
for await signal in coordinator.signals() {
    handle(signal)
}
```

If you subscribed inside a type with a lifetime, hold the loop in a `Task` and cancel it
on teardown. `PageViewModel` already does this for you.

### `Coordinating` no longer inherits `CoordinatorDelegate`

The portable `Coordinating` contract is now just `{ coordinate(action:), send(signal:) }`.
The UIKit `Coordinator` base class conforms to `CoordinatorDelegate` explicitly, so
**subclasses of `Coordinator` are unaffected**. Only types that conformed to `Coordinating`
directly *and* relied on inheriting the delegate requirements need to add that conformance
themselves.

### Unchanged

`send(signal:)`, `handle(signal:)`, `coordinate(action:)`, `navigate`, `startCoordinator`,
child-coordinator tracking, and the entire presentation stack behave identically.
`PageKitUI`, `PageKitForms`, `PageKitContainers`, and `PageFramework` are untouched.

---

## License

PageKit is available under the MIT License. See [LICENSE](LICENSE) for the full text.
