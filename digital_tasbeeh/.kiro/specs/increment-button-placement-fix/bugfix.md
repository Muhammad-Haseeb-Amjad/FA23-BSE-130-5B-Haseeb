# Bugfix Requirements Document

## Introduction

The transparent increment button (the `CircleTapTarget` with key `allah_tap_area`) in `lib/screens/counter_screen.dart` is mispositioned within the `Stack` layout. Its center coordinates and radius are calculated directly against the full `imageSide` dimension, but the golden circular button in the image asset does not occupy the full square — it sits within the opaque content region of the image. As a result, the transparent tap zone is placed on top of the image widget rather than being fitted and centered inside the visible golden circle boundary. This causes missed taps when the user presses the golden button and unintended taps in areas outside the golden circle.

## Bug Analysis

### Current Behavior (Defect)

1.1 WHEN the counter screen renders and `_opaqueImageRect` has been computed, THEN the transparent increment button (`allah_tap_area`) is positioned using raw `imageSide * _allahCenterX` and `imageSide * _allahCenterY` coordinates that do not account for the opaque content offset within the image, causing the tap zone to be offset from the visible golden circle.

1.2 WHEN the radius of the increment tap zone is calculated as `imageSide * _allahRadiusFactor`, THEN the radius is scaled against the full container dimension rather than the opaque content width, making the tap zone larger or smaller than the actual golden circle boundary.

1.3 WHEN the image is rendered with `BoxFit.contain` inside a square `SizedBox`, THEN the opaque image content may be letterboxed (padded with transparent space) on two sides, and the tap zone does not compensate for this offset, so it sits on top of the wrong area of the screen.

### Expected Behavior (Correct)

2.1 WHEN the counter screen renders and `_opaqueImageRect` has been computed, THEN the transparent increment button SHALL be positioned using `_mapContentX(_allahCenterX)` and `_mapContentY(_allahCenterY)` — the same coordinate-mapping helpers already used for the LCD text overlay — so that its center aligns with the center of the visible golden circle.

2.2 WHEN the radius of the increment tap zone is calculated, THEN it SHALL be derived from `imageSide * _mapContentWidth(_allahRadiusFactor)` (or the equivalent height factor) so that it matches the actual pixel size of the golden circle in the rendered image.

2.3 WHEN the image is rendered with `BoxFit.contain` and transparent padding is present, THEN the increment button SHALL be offset by the same opaque-content mapping applied to the save and reset tap zones, ensuring correct placement on all screen sizes and aspect ratios.

### Unchanged Behavior (Regression Prevention)

3.1 WHEN the user taps the save button area (left small golden circle), THEN the system SHALL CONTINUE TO trigger `_saveCurrentCount` and display the "Count saved" snackbar.

3.2 WHEN the user taps the reset/replay button area (right small golden circle), THEN the system SHALL CONTINUE TO trigger `_confirmReset` and show the reset confirmation dialog.

3.3 WHEN the counter screen loads on any screen size or aspect ratio, THEN the system SHALL CONTINUE TO scale the entire `Stack` layout proportionally using the `imageSide` dimension derived from `LayoutBuilder` constraints.

3.4 WHEN the LCD counter text overlay is rendered, THEN the system SHALL CONTINUE TO use `_mapContentX`/`_mapContentY` for its position, remaining correctly aligned over the LCD display area of the image.

3.5 WHEN `_opaqueImageRect` has not yet been computed (initial load), THEN the system SHALL CONTINUE TO fall back to `Rect.fromLTWH(0, 0, 1, 1)` so that tap zones are rendered without crashing, even if temporarily misaligned.

3.6 WHEN the debug zones flag `_showDebugZones` is enabled, THEN the system SHALL CONTINUE TO render the debug circle overlays at the corrected positions matching the updated tap zone positions.
