# Cleanup Plan - Remove TheCut-Specific Code

## Summary

We can keep most of the framework! The problematic code is mostly **business logic methods** that don't belong in a generic framework anyway.

## Files Requiring Changes

### 1. Coordinator.swift - REMOVE Business Logic Methods

**Lines to DELETE entirely (300-493):**
- Line 290-298: `BarButtonItem` with L10n/Icons (rewind button styling)
- Line 301-323: `requestTab()` methods for ClientTabCoordinator, BarberTabCoordinator, OwnerTabCoordinator
- Line 327-337: `ModalViewControllerDelegate` methods
- Line 406-419: `showConfirmation()` - uses Confirmation/ConfirmationModalViewController
- Line 429-454: `navigateToMapsApp()` - uses Address/AddressFormatter/Logger
- Line 456-472: `openURL()` - uses Analytics/Logger
- Line 474-483: `share()` - uses ShareItem/ShareMedium
- Line 485-491: `initiateCall()` - business logic

**Lines to MODIFY:**
- Line 210: Change `NavigationController` to `UINavigationController`
- Line 37: Remove `ModalViewControllerDelegate` protocol conformance
- Line 224: Remove/comment out `ModalViewControllerDelegatable` line

**KEEP (Core Framework):**
- All coordinator lifecycle methods (start, end, willStart, didStart, etc.)
- navigate(to:with:) - core navigation
- rewind() - core navigation
- coordinate(action:) - core pattern
- UINavigationControllerDelegate extension
- Navigator extension (basic push/present)

### 2. Coordination/Coordinating.swift - Check Navigator Protocol

Need to verify if `Navigator` is defined in Framework or is TheCut-specific.

### 3. Module/ModuleViewModel.swift - Remove Analytics

Find Analytics usage and remove it.

### 4. Check Cartography Usage

**Files using Cartography:**
- Coordinator.swift
- Presentation/Page/PageController.swift

**Decision**: Remove Cartography imports and any layout code using it (likely not in core coordinator logic)

## Recommendation

**Phase 1: Remove Business Logic Methods**
1. Edit Coordinator.swift - remove methods lines 406-491
2. Edit Coordinator.swift - remove specific tab coordinator methods lines 301-323
3. Edit Coordinator.swift - comment out ModalViewController delegate lines 327-337
4. Fix NavigationController reference (line 210)
5. Remove BarButtonItem configuration (lines 286-298) - replace with basic UIBarButtonItem

**Phase 2: Remove/Stub Remaining Dependencies**
1. Check other 4 files for dependencies
2. Remove Cartography or replace with plain AutoLayout

**Result**: Clean, UIKit-based coordinator framework with no business logic

## Do We Need These Files?

### ✅ DEFINITELY KEEP (Core Framework)

**Coordination/** (10 files)
- ✅ Coordinator.swift (after cleanup)
- ✅ Coordinating.swift
- ✅ CoordinatingAction.swift
- ✅ CoordinatingNavigation.swift
- ✅ CoordinatingTabs.swift
- ✅ CoordinatableAction.swift
- ✅ CoordinatingHandoff.swift
- ✅ CoordinatorHistoryItem.swift
- ✅ NavigationAction.swift
- ✅ RewindStyle.swift

**Module/** (12 files)
- ✅ Module.swift
- ✅ ModuleController.swift
- ✅ ModuleView.swift
- ✅ ModuleViewModel.swift (after removing Analytics)
- ✅ ModuleViewState.swift
- ✅ ModuleViewEventHandler.swift
- ✅ ModuleSignal.swift
- ✅ ModuleSignalPublisher.swift
- ✅ Form/ subfolder (5 files)
- ✅ Configurable/ subfolder (4 files)

**Presentation/** (9 files)
- ✅ Modal/ModalController.swift
- ✅ Modal/ModalPresenter.swift
- ✅ Modal/ModalContentWrapper.swift
- ✅ Page/PageController.swift
- ✅ Page/PagePresenter.swift
- ✅ Page/PageContentWrapper.swift
- ✅ Page/PageMode.swift
- ✅ Tab/TabController.swift
- ✅ Tab/TabPresenter.swift
- ✅ Tab/TabTransitionAnimator.swift

**Environment/** (6 files)
- ✅ All 6 files

**Preferences/** (6 files)
- ✅ All 6 files

**Modifiers/** (14 files)
- ✅ All 14 files

**PropertyWrappers/** (3 files)
- ✅ All 3 files

**Theming/** (14 files)
- ⚠️ Check if AppTheme/ subfolder has TheCut-specific styling
- ✅ Base theme structure is generic

**Configurations/** (4 files)
- ✅ All 4 files

**Protocols/** (1 file)
- ✅ Refreshable.swift

**ViewEntity/** (1 file)
- ✅ ViewEntity.swift

### ❓ NEED TO CHECK
- Theming/Themes/AppTheme/* - May have TheCut-specific colors/fonts

## Estimated Work

- **Remove business methods from Coordinator**: 10 minutes
- **Fix NavigationController/BarButtonItem**: 5 minutes
- **Remove Analytics from ModuleViewModel**: 2 minutes
- **Check/remove Cartography**: 10 minutes
- **Test build**: 5 minutes

**Total: ~30 minutes to clean build**
