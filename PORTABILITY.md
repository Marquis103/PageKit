# PageKit portability — Android (Skip Fuse)

Since 2.1.0, `PageKitCore`, `PageKitTheming` and `PageKitUI` compile and compose for
Android under [Skip Fuse](https://skip.dev). `PageKitUIKit`, the `PageKit` umbrella,
`PageKitForms`, `PageKitContainers` and `PageFramework` are Darwin-only and never enter
the Android graph.

## How the Android graph is wired

The manifest gates every Skip dependency on `Context.environment["SKIP_ANDROID"]` —
a variable the consuming Skip app's build owns and must export for the **whole**
gradle session: `SKIP_ANDROID=1 gradle -p Android launchDebug` (the Ayes repo
exports it in its android CI job and `Scripts/skip-env.sh`). When it is unset (every
Xcode build, every iOS consumer), PageKit declares **zero package dependencies and no
plugins**: iOS consumers resolve exactly the pre-2.1 graph. When set, the three
Android-graph targets gain the `SkipFuseUI` product and the `skipstone` plugin, and
each carries `Sources/<Target>/Skip/skip.yml` with `mode: native`, `bridging: false`.

Why not skip's own `TARGET_OS_ANDROID` (measured, W2.1): skip's tooling sets that
variable selectively for Android-destination compiles only — the skipstone
plugin/transpile pass runs *without* it, so a manifest gated on it never attaches the
plugin ("missing inputs: `outputs/pagekit/*.sourcehash`"); exporting it globally
instead breaks skip-fuse-ui's own host compile (circular `SwiftUI`/`SkipSwiftUI`
modules). Forgetting `SKIP_ANDROID` fails loudly with the missing-inputs error above.

Two rules the code depends on — do not "clean up" either:

1. **Conformers of `TextConfigurable` / `ButtonConfigurable` must list `View`
   directly** in their own inheritance clause (`struct HeroText: TextConfigurable,
   View`). SkipUI composes only views whose `View` conformance is stated on the type;
   conformance arriving solely through a refining protocol renders **empty** on
   Android, with no compile error (B1 probes P10/P11). The same applies to any new
   protocol that refines `View` — including app-side conformers of `PageView`.
2. **Lines marked `// skipstone: internal`** are deliberately `internal` rather than
   `private`: skipstone's processing of an Android-graph module requires view/modifier
   types and property-wrapped state (`@State`, `@Environment`, …) to be visible to
   codegen. Reverting one to `private` breaks the Android build or silently drops the
   view.

## Component status on Android

| Component | Android status | Successor / note |
|---|---|---|
| `HeroText` and the 7 other text components | composes (verified on-emulator, W2.1) | — |
| `BaseButton` + the 6 styled buttons | compiles; direct-`View` fix applied | throttle state does not persist across renders (plain storage, no `@StateObject`); no `truncationMode`/`contentShape` — W3/W5 interactivity pass |
| `Icon` | compiles | — |
| `ScrollView` (refreshable) | compiles | — |
| `LoadableContent` + default state views | compiles | — |
| `LoadingSpinner` / `LoadingView` | compiles | — |
| `TappableRow` | compiles | no `contentShape`; Compose hit-tests row bounds |
| `onTap` | Android variant | plain `onTapGesture`, **no double-tap throttle** — W3/W5 |
| `onLongPress` | Android variant | plain `onLongPressGesture`, no sequenced two-stage gesture — W3/W5 |
| `Interaction` / `Throttler` / `ExternalizedState` | `@Observable` Android variants | keep the two branches in sync |
| **Toast / ToastManager / ToastView** | **Darwin-only** (UIKit-window presentation) | the W4 Android shell presents its own banner overlay; Ayes does not consume this subsystem |
| **`List` / `HorizontalList`** | **Darwin-only** (skipstone rejects the `RandomAccessCollection` generic) | Android call sites compose SkipUI's native `List` / `LazyHStack`; W3.4 attributes Ayes call sites per-site |
| **`bottomPinnedView` / `BottomPinnedViewModifier`** | **Darwin-only** (generic shadows `ViewModifier.Content`; `@ViewBuilder` public extension) | unused by Ayes; W3 assesses a successor if a consumer needs one |
| `ThemeFontWeight.uiFontWeight` | Darwin-only (`UIFont`) | Android consumers use `swiftUIWeight` |
| system gray backgrounds | RGB literals on Android | keep in sync with UIKit's light-mode `systemGray5/6` |

## Known open questions (owned by W3)

- `import SkipFuse` in files defining `@Observable` types: the measured spike state
  compiled with plain `import Observation`; whether observation drives recomposition
  in every case is unverified until W3 exercises interactivity.
- Generic views (`BaseButton<T>`, `Icon<T>`): compile for Android; composition of
  generic library views has not been render-verified (`HeroText` is non-generic).
