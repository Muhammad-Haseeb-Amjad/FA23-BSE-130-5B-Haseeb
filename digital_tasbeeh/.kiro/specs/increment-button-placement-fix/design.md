# Increment Button Placement Fix — Bugfix Design

## Overview

The transparent increment tap zone (`CircleTapTarget` with key `allah_tap_area`) is mispositioned
because its center coordinates and radius are computed against the raw `imageSide` square, while
the golden circle in the image asset sits inside the opaque content region — which is smaller than
the full square and offset from its top-left corner when `BoxFit.contain` letterboxes the image.

The fix is a **single call-site change**: replace the raw-fraction arguments passed to
`_buildCenteredCircleTapZone` for `allah_tap_area` with values that go through the existing
`_mapContentX`, `_mapContentY`, and `_mapContentWidth` helpers, exactly as the LCD text overlay
already does. Save and Replay button positions are **not changed** — their constants are already
calibrated to the full `imageSide` coordinate space and are correct.

---

## Glossary

- **Bug_Condition (C)**: The condition that triggers the bug — the `allah_tap_area` is positioned
  using raw `imageSide`-relative fractions instead of opaque-content-mapped coordinates.
- **Property (P)**: The desired behavior — the transparent tap zone center and radius match the
  visible golden circle on every screen size and aspect ratio.
- **Preservation**: Save button, Replay button, LCD text overlay, and all other behaviors that
  must remain unchanged after the fix.
- **`_opaqueImageRect`**: A `Rect` (in normalised `[0,1]` coordinates relative to `imageSide`)
  that describes the bounding box of the opaque pixels in the image asset, computed once at load
  time by `_computeOpaqueImageRect`.
- **`_mapContentX(x)`**: Maps a content-relative X fraction to an `imageSide`-relative X fraction
  by applying `_opaqueImageRect.left + _opaqueImageRect.width * x`.
- **`_mapContentY(y)`**: Maps a content-relative Y fraction to an `imageSide`-relative Y fraction
  by applying `_opaqueImageRect.top + _opaqueImageRect.height * y`.
- **`_mapContentWidth(f)`**: Scales a content-relative width/radius factor to an
  `imageSide`-relative factor by applying `_opaqueImageRect.width * f`.
- **`_buildCenteredCircleTapZone`**: Helper that places a `CircleTapTarget` inside a `Positioned`
  widget; it receives already-mapped `centerX`, `centerY`, and `radius` values and multiplies them
  by `imageSide` to get pixel coordinates.
- **`_allahCenterX / _allahCenterY`**: Content-relative fractions (0.5, 0.735) locating the
  golden circle centre within the opaque image content.
- **`_allahRadiusFactor`**: Content-relative radius fraction (0.106) of the golden circle.

---

## Bug Details

### Bug Condition

The bug manifests when `_opaqueImageRect` has been computed and the `allah_tap_area`
`CircleTapTarget` is positioned. The `_buildCenteredCircleTapZone` call for `allah_tap_area`
passes `centerX: _allahCenterX` and `centerY: _allahCenterY` as raw content-relative fractions,
but the helper multiplies them directly by `imageSide` — treating them as fractions of the full
square. Because the opaque content does not fill the full square (it is offset by
`_opaqueImageRect.left` / `_opaqueImageRect.top` and scaled by `_opaqueImageRect.width` /
`_opaqueImageRect.height`), the resulting pixel position is wrong.

**Formal Specification:**

```
FUNCTION isBugCondition(callSiteArgs)
  INPUT:  callSiteArgs — the arguments passed to _buildCenteredCircleTapZone for allah_tap_area
  OUTPUT: boolean

  RETURN callSiteArgs.centerX  == _allahCenterX          // raw, not mapped
         AND callSiteArgs.centerY == _allahCenterY        // raw, not mapped
         AND callSiteArgs.radius  == imageSide * _allahRadiusFactor  // scaled to full square
END FUNCTION
```

### Examples

- **Small phone (360 × 640 dp)**: `imageSide ≈ 331 dp`. Opaque rect ≈ `(0.04, 0.02, 0.96, 0.98)`.
  - Buggy centre: `(331 × 0.5, 331 × 0.735) = (165.5, 243.3)` dp
  - Correct centre: `(331 × (0.04 + 0.92 × 0.5), 331 × (0.02 + 0.96 × 0.735)) = (331 × 0.5, 331 × 0.7256) ≈ (165.5, 240.2)` dp
  - Buggy radius: `331 × 0.106 ≈ 35.1` dp
  - Correct radius: `331 × (0.92 × 0.106) ≈ 32.3` dp

- **Tablet (768 × 1024 dp)**: `imageSide ≈ 707 dp`. Opaque rect ≈ `(0.04, 0.02, 0.96, 0.98)`.
  - Buggy centre: `(353.5, 519.6)` dp — visibly above and outside the golden circle.
  - Correct centre: `(353.5, 512.9)` dp — centred on the golden circle.
  - Radius error: `707 × 0.106 ≈ 74.9` dp (buggy) vs `707 × 0.0975 ≈ 68.9` dp (correct).

- **Landscape phone (640 × 360 dp)**: `imageSide ≈ 331 dp`. Same opaque rect.
  - The letterboxing is on the left/right sides; the vertical offset is the dominant error.

- **Edge case — `_opaqueImageRect` not yet computed** (initial load, fallback `Rect(0,0,1,1)`):
  - `_mapContentX(0.5) = 0.5`, `_mapContentY(0.735) = 0.735`, `_mapContentWidth(0.106) = 0.106`
  - The mapped values equal the raw values, so behaviour is identical to the buggy code until
    the rect is computed — no regression during the loading phase.

---

## Expected Behavior

### Preservation Requirements

**Unchanged Behaviors:**
- Mouse/touch taps on the Save button (left small golden circle) MUST continue to trigger
  `_saveCurrentCount` and display the "Count saved" snackbar.
- Mouse/touch taps on the Replay/Reset button (right small golden circle) MUST continue to
  trigger `_confirmReset` and show the reset confirmation dialog.
- The LCD counter text overlay MUST continue to use `_mapContentX`/`_mapContentY` for its
  position, remaining correctly aligned over the LCD display area.
- The `Stack` layout MUST continue to scale proportionally using `imageSide` from
  `LayoutBuilder` constraints.
- The fallback to `Rect.fromLTWH(0, 0, 1, 1)` when `_opaqueImageRect` has not yet been
  computed MUST continue to prevent crashes during initial load.
- When `_showDebugZones` is `true`, debug overlays MUST continue to render at the corrected
  positions matching the updated tap zone positions.

**Scope:**
All inputs that do NOT involve tapping the `allah_tap_area` golden circle are completely
unaffected by this fix. This includes:
- Taps on the Save button (`save_tap_area`)
- Taps on the Replay/Reset button (`replay_tap_area`)
- Vibration and Mute toggle buttons
- Navigation via the side drawer
- Counter text display and formatting

---

## Hypothesized Root Cause

Based on code inspection, the root cause is a **coordinate-space mismatch at the call site**:

1. **Inconsistent coordinate mapping**: The `_allahCenterX` / `_allahCenterY` constants are
   defined as fractions within the opaque image content (same coordinate space as `_lcdCenterX`
   etc.), but the `allah_tap_area` call to `_buildCenteredCircleTapZone` passes them raw, without
   going through `_mapContentX` / `_mapContentY`. The LCD overlay was correctly updated to use
   the mapping helpers; the `allah_tap_area` call was not.

2. **Radius scaled to full square**: `radius: imageSide * _allahRadiusFactor` scales the radius
   against the full `imageSide` square. The correct scale is against the opaque content width:
   `imageSide * _mapContentWidth(_allahRadiusFactor)`.

3. **Save/Replay buttons are exempt**: Their constants (`_saveCenterX`, `_replayCenterX`, etc.)
   are calibrated to the full `imageSide` space (not content-relative), so they do not need
   mapping and MUST NOT be changed.

---

## Correctness Properties

Property 1: Bug Condition — Allah Tap Area Centred on Golden Circle

_For any_ screen size where `_opaqueImageRect` has been computed, the fixed `allah_tap_area`
`CircleTapTarget` SHALL be positioned such that its centre pixel coordinates equal
`imageSide × _mapContentX(_allahCenterX)` (horizontal) and
`imageSide × _mapContentY(_allahCenterY)` (vertical), and its radius SHALL equal
`imageSide × _mapContentWidth(_allahRadiusFactor)`, so that the tap zone is centred inside
the visible golden circle and sized to match it.

**Validates: Requirements 2.1, 2.2, 2.3**

Property 2: Preservation — Save and Replay Button Positions Unchanged

_For any_ screen size, the fixed code SHALL produce exactly the same `Positioned` left/top/width/
height values for `save_tap_area` and `replay_tap_area` as the original code, preserving all
existing save and reset tap behaviour.

**Validates: Requirements 3.1, 3.2, 3.3**

---

## Fix Implementation

### Changes Required

**File**: `lib/screens/counter_screen.dart`

**Location**: Inside `build` → `LayoutBuilder` → `Stack` children, the `_buildCenteredCircleTapZone`
call for `_allahTapKey`.

**Current (buggy) code:**

```dart
_buildCenteredCircleTapZone(
  key: _allahTapKey,
  imageSide: imageSide,
  centerX: _allahCenterX,
  centerY: _allahCenterY,
  radius: imageSide * _allahRadiusFactor,
  onTap: _incrementCount,
),
```

**Fixed code:**

```dart
_buildCenteredCircleTapZone(
  key: _allahTapKey,
  imageSide: imageSide,
  centerX: _mapContentX(_allahCenterX),
  centerY: _mapContentY(_allahCenterY),
  radius: imageSide * _mapContentWidth(_allahRadiusFactor),
  onTap: _incrementCount,
),
```

**Specific Changes:**

1. **`centerX` argument**: Replace `_allahCenterX` with `_mapContentX(_allahCenterX)`.
   - `_mapContentX` converts the content-relative fraction to an `imageSide`-relative fraction
     by applying `_opaqueImageRect.left + _opaqueImageRect.width * x`.

2. **`centerY` argument**: Replace `_allahCenterY` with `_mapContentY(_allahCenterY)`.
   - `_mapContentY` converts the content-relative fraction to an `imageSide`-relative fraction
     by applying `_opaqueImageRect.top + _opaqueImageRect.height * y`.

3. **`radius` argument**: Replace `imageSide * _allahRadiusFactor` with
   `imageSide * _mapContentWidth(_allahRadiusFactor)`.
   - `_mapContentWidth` scales the content-relative factor by `_opaqueImageRect.width`, giving
     the correct pixel radius relative to the opaque content size.

4. **Debug circle for `allah_tap_area`** (inside `if (_showDebugZones)`): Update the
   `_buildDebugCircle` call for the green circle to use the same mapped values:
   - `centerX: _mapContentX(_allahCenterX)`
   - `centerY: _mapContentY(_allahCenterY)`
   - `radius: imageSide * _mapContentWidth(_allahRadiusFactor)`

5. **No changes** to `save_tap_area`, `replay_tap_area`, their debug circles, the LCD overlay,
   `_buildCenteredCircleTapZone` helper, `CircleTapTarget`, or any other code.

---

## Testing Strategy

### Validation Approach

The testing strategy follows a two-phase approach: first, surface counterexamples that demonstrate
the bug on unfixed code, then verify the fix works correctly and preserves existing behaviour.

### Exploratory Bug Condition Checking

**Goal**: Surface counterexamples that demonstrate the bug BEFORE implementing the fix. Confirm
or refute the root cause analysis. If we refute, we will need to re-hypothesize.

**Test Plan**: Write widget tests that pump `CounterScreen` with a known `_opaqueImageRect` (by
injecting a test image or mocking the rect), then use `tester.getCenter(find.byKey(Key('allah_tap_area')))`
to read the rendered centre position and compare it against the expected mapped coordinates.
Run these tests on the UNFIXED code to observe failures.

**Test Cases:**

1. **Centre X alignment test**: Assert that the `allah_tap_area` widget centre X equals
   `imageSide × _mapContentX(_allahCenterX)` — will fail on unfixed code because the actual
   value is `imageSide × _allahCenterX`.

2. **Centre Y alignment test**: Assert that the `allah_tap_area` widget centre Y equals
   `imageSide × _mapContentY(_allahCenterY)` — will fail on unfixed code.

3. **Radius size test**: Assert that the `allah_tap_area` widget width/2 equals
   `imageSide × _mapContentWidth(_allahRadiusFactor)` — will fail on unfixed code because the
   actual radius is `imageSide × _allahRadiusFactor`.

4. **Non-square opaque rect test**: Use a rect where `left ≠ 0` or `top ≠ 0` (simulating
   letterboxing) and assert the tap zone is offset accordingly — will fail on unfixed code.

**Expected Counterexamples:**
- `allah_tap_area` centre is at `(imageSide × 0.5, imageSide × 0.735)` instead of the
  content-mapped position.
- Radius is `imageSide × 0.106` instead of `imageSide × _opaqueImageRect.width × 0.106`.

### Fix Checking

**Goal**: Verify that for all inputs where the bug condition holds, the fixed function produces
the expected behaviour.

**Pseudocode:**

```
FOR ALL screenSize IN [small_phone, medium_phone, large_phone, tablet] DO
  imageSide := computeImageSide(screenSize)
  opaqueRect := _computeOpaqueImageRect(assetPath)

  result := render allah_tap_area with fixed code
  
  ASSERT result.centerX == imageSide * _mapContentX(_allahCenterX)
  ASSERT result.centerY == imageSide * _mapContentY(_allahCenterY)
  ASSERT result.radius  == imageSide * _mapContentWidth(_allahRadiusFactor)
END FOR
```

### Preservation Checking

**Goal**: Verify that for all inputs where the bug condition does NOT hold, the fixed function
produces the same result as the original function.

**Pseudocode:**

```
FOR ALL tap IN [save_tap_area, replay_tap_area, lcd_counter_text] DO
  positionBefore := render(tap, originalCode)
  positionAfter  := render(tap, fixedCode)
  ASSERT positionBefore == positionAfter
END FOR
```

**Testing Approach**: Property-based testing is recommended for preservation checking because:
- It generates many `imageSide` values automatically across the plausible range (200–900 dp).
- It catches edge cases (very small or very large screens) that manual unit tests might miss.
- It provides strong guarantees that Save/Replay positions are unchanged for all screen sizes.

**Test Plan**: Observe Save and Replay button positions on unfixed code first, then write
property-based tests asserting those positions are identical after the fix.

**Test Cases:**

1. **Save button preservation**: For any `imageSide` in [200, 900], assert that `save_tap_area`
   centre and radius are identical before and after the fix.

2. **Replay button preservation**: For any `imageSide` in [200, 900], assert that `replay_tap_area`
   centre and radius are identical before and after the fix.

3. **LCD overlay preservation**: Assert that the `lcd_counter_text` `Positioned` left/top/width/
   height values are unchanged after the fix.

4. **Fallback rect preservation**: When `_opaqueImageRect == Rect.fromLTWH(0, 0, 1, 1)`,
   assert that `allah_tap_area` position equals the pre-fix position (mapping is identity when
   rect is the unit square).

### Unit Tests

- Test `_mapContentX`, `_mapContentY`, `_mapContentWidth` with a known non-unit `_opaqueImageRect`
  to confirm they produce the expected output values.
- Test that `allah_tap_area` `Positioned` left/top/width/height match the mapped values for a
  given `imageSide` and `_opaqueImageRect`.
- Test edge cases: `_opaqueImageRect` is the unit square (no letterboxing), and a heavily
  letterboxed rect (e.g., `Rect.fromLTRB(0.1, 0.05, 0.9, 0.95)`).

### Property-Based Tests

- Generate random `imageSide` values in [200.0, 900.0] and random `_opaqueImageRect` values
  (left ∈ [0, 0.2], top ∈ [0, 0.2], right ∈ [0.8, 1.0], bottom ∈ [0.8, 1.0]) and verify that
  the `allah_tap_area` centre equals `imageSide × _mapContentX(_allahCenterX)` (X) and
  `imageSide × _mapContentY(_allahCenterY)` (Y).
- Generate random `imageSide` values and verify that `save_tap_area` and `replay_tap_area`
  positions are unchanged by the fix (preservation property).
- Generate random `_opaqueImageRect` values and verify that when the rect is the unit square,
  the mapped position equals the raw position (identity property).

### Integration Tests

- Pump `CounterScreen` in a widget test with a real or mocked image asset, wait for
  `_opaqueImageRect` to be computed, then assert that tapping the `allah_tap_area` increments
  the counter (end-to-end tap registration).
- Pump `CounterScreen` at multiple `MediaQuery` sizes (360 × 640, 414 × 896, 768 × 1024) and
  assert that the `allah_tap_area` centre is within 2 dp of the expected mapped position.
- Pump `CounterScreen` and assert that tapping `save_tap_area` and `replay_tap_area` still
  trigger their respective actions after the fix is applied.
