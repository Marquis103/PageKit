# Files to Remove - ModuleFramework Cleanup

## Strategy: Keep Core Framework, Remove TheCut-Specific UI Components

Based on build errors, we'll remove files that depend on TheCut-specific UI components and business types.

---

## Files to REMOVE (21 files)

### Configurations/ - REMOVE ALL (4 files)
These depend on TheCut's `Icon`, `HyperLink`, and other UI components:
- ❌ `ButtonConfigurable.swift` - uses `Icon`
- ❌ `CalendarConfigurable.swift` - likely uses TheCut components
- ❌ `LinkConfigurable.swift` - uses `HyperLink`
- ❌ `TextConfigurable.swift` - likely uses TheCut components

**Reason**: These are configuration helpers for TheCut's specific UI components. Not generic.

---

### Modifiers/ - REMOVE 3 files (keep 11)
- ❌ `BadgeModifier.swift` - uses TheCut's `Badge` component
- ❌ `LoadableModifier.swift` - uses `LoadableContentState` (TheCut type)
- ❌ `OnTapModifier.swift` - uses `Throttler` (TheCut utility)

**Keep these 11 modifiers** (generic SwiftUI extensions):
- ✅ `BottomPinnedViewModifier.swift`
- ✅ `FadeInModifier.swift`
- ✅ `HiddenModifier.swift`
- ✅ `IfModifier.swift`
- ✅ `LetModifier.swift`
- ✅ `OnLongPressModifier.swift`
- ✅ `OnSizeChangeModifier.swift`
- ✅ `PopModifier.swift`
- ✅ `ShakeModifier.swift`
- ✅ `StrikethroughModifier.swift`

---

### Presentation/Tab/ - REMOVE ALL (3 files)
These depend on TheCut's `TabBar` component:
- ❌ `TabController.swift` - uses `TabBar`, `HostingController`
- ❌ `TabPresenter.swift` - uses `TabBar`
- ❌ `TabTransitionAnimator.swift` - Tab-specific animation

**Reason**: TheCut has a custom TabBar component. Use standard UIKit/SwiftUI tabs in your app.

---

### Coordination/ - REMOVE 1 file (keep 9)
- ❌ `CoordinatingTabs.swift` - references `TabBar`

**Keep these 9 core coordination files**:
- ✅ `Coordinator.swift` (already cleaned up)
- ✅ `Coordinating.swift` (needs UIKit import fix)
- ✅ `CoordinatingAction.swift`
- ✅ `CoordinatingHandoff.swift`
- ✅ `CoordinatingNavigation.swift`
- ✅ `CoordinatableAction.swift`
- ✅ `CoordinatorHistoryItem.swift` (needs UIKit import fix)
- ✅ `NavigationAction.swift`
- ✅ `RewindStyle.swift`

---

### Preferences/Navigation/ - REMOVE ALL (2 files)
These depend on TheCut's `NavigationButton` component:
- ❌ `Navigation.swift` - uses `NavigationButton`
- ❌ `NavigationPreference.swift` - uses `NavigationButton`

**Reason**: References custom NavigationButton. Use standard SwiftUI buttons.

---

### Module/Form/ - REMOVE ALL (5 files)
Form module uses `LoadableContentState` and `FormFieldObservable`:
- ❌ `FormModule.swift`
- ❌ `FormView.swift`
- ❌ `FormViewEventHandler.swift`
- ❌ `FormViewModel.swift`
- ❌ `FormViewState.swift` - uses `LoadableContentState`, `FormFieldObservable`

**Reason**: Tightly coupled to TheCut's form system. Build your own or keep generic Module pattern.

---

### Theming/Themes/AppTheme/ - REMOVE ALL (5 files)
TheCut-specific theme implementation:
- ❌ `AppButtonStyles.swift` - uses TheCut `Colors`
- ❌ `AppColorStyles.swift` - uses TheCut `Colors`
- ❌ `AppSizingStyles.swift` - TheCut-specific sizes
- ❌ `AppSpacingStyles.swift` - TheCut-specific spacing
- ❌ `AppTypographyStyles.swift` - TheCut-specific fonts

**Reason**: These are TheCut's specific design system values. The base theme structure is still available.

---

## Files to KEEP and FIX (63 files)

### Need UIKit Import Fix (3 files)
- ✅ `Coordination/Coordinating.swift` - add `import UIKit`
- ✅ `Coordination/CoordinatorHistoryItem.swift` - add `import UIKit`
- ✅ `Module/ModuleController.swift` - add `import UIKit`

### Need to Remove/Stub Methods (2 files)
- ✅ `Coordination/Coordinating.swift` - remove `showConfirmation` method (uses `Confirmation`)
- ✅ `Module/ModuleViewModel.swift` - remove `showConfirmation` method (uses `Confirmation`)

### Need to Check ViewMode (1 file)
- ⚠️ `Module/ModuleViewState.swift` - uses `ViewMode` - check if this is a simple enum we can keep

### Keep As-Is (57 files)
All other files should compile once we:
1. Remove the 21 problematic files
2. Fix the 3 UIKit import issues
3. Remove Confirmation-related methods

---

## Summary

**REMOVE: 21 files**
- Configurations/ (4 files)
- 3 Modifiers
- Presentation/Tab/ (3 files)
- CoordinatingTabs.swift
- Preferences/Navigation/ (2 files)
- Module/Form/ (5 files)
- Theming/Themes/AppTheme/ (5 files)

**KEEP: 63 files** (with minor fixes)
- Core Coordination pattern ✅
- Base Module system ✅
- Presentation/Modal/ ✅
- Presentation/Page/ ✅
- Most Modifiers (11) ✅
- PropertyWrappers (3) ✅
- Environment (6) ✅
- Base Theming structure ✅
- Preferences/KeyboardAdaptability/ ✅
- Preferences/Onboarding/ ✅

---

## What You'll Have

A clean, generic UIKit-based coordinator framework with:
- ✅ Coordinator pattern (navigation, modal, handoff)
- ✅ Module pattern for feature composition
- ✅ Page presentation system
- ✅ Modal presentation system
- ✅ Basic theming infrastructure
- ✅ Useful SwiftUI/UIKit extensions
- ✅ Property wrappers for state management
- ✅ Environment value extensions

**You can build back up:**
- Your own TabBar coordinator
- Your own Form system
- Your own button/badge components
- Your app-specific theme values
- Your own loadable state handling
