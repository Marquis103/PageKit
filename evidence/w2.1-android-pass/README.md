# W2.1 on-device evidence — HeroText composes on Android

Captured 2026-09-06 on the `ayes_pixel` AVD (Android 16 / API 36 / arm64-v8a), app
`com.thatswiftguy.ayes` built from the Ayes repo's `AyesApp/` composition root with an
uncommitted path-dep override to this branch, via
`SKIP_ANDROID=1 gradle -p Android launchDebug` (BUILD SUCCESSFUL in 2m 46s, 245 tasks).

- `emulator-herotext.png` — the Welcome tab scrolled to the W2.1 block: `HeroText`
  ("W2.1 HERO RENDER") rendered in themed hero typography inside the red-tinted slot
  (B1's collapse instrument — the slot collapses if the subtree composes empty), and a
  `PrimaryButton` ("W2.1 BUTTON") rendered inside the blue-tinted slot. The W0.4
  (13/13 decode) and W1.3 (3/3) proof blocks above both still pass.
- `emulator-welcome-top.png` — the same screen from the top.
- `uiautomator-dump.xml` — `adb shell uiautomator dump`. The load-bearing nodes:

```
text='W2.1 HERO RENDER' class=android.widget.TextView bounds=[63,1780][449,1829]
text='W2.1 BUTTON'      class=android.widget.TextView bounds=[423,1995][657,2038]
```

This render retires B1/Gate-1b's headline finding (indirect `View` conformance via
`TextConfigurable` composes empty): with the direct `View` listing of commit 1, the
real `HeroText` — not a clone — composes from a library module. The button node also
answers the open generic-view question for `ButtonConfigurable` conformers.
