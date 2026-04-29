# Implementation Plan

- [x] 1. Write bug condition exploration test
  - Property 1: Bug Condition - Allah Tap Area Mispositioned (Raw vs Mapped Coordinates)
  - CRITICAL: This test MUST FAIL on unfixed code - failure confirms the bug exists
  - DO NOT attempt to fix the test or the code when it fails
  - NOTE: This test encodes the expected behavior - it will validate the fix when it passes after implementation
  - GOAL: Surface counterexamples that demonstrate the coordinate-space mismatch
  - Scoped PBT Approach: Scope the property to concrete screen sizes (360x640, 430x932, 768x1024)
  - Add a new testWidgets group in test/widget_test.dart (or a new file test/allah_tap_placement_test.dart)
  - For each screen size, pump CounterScreen, wait for lcd_counter_text to appear (confirming _opaqueImageRect has been computed)
  - Read the rendered Rect of allah_tap_area using tester.getRect(find.byKey(const Key('allah_tap_area')))
  - Derive imageSide from the rendered size of the Stack
  - Assert: allahRect.center.dx approx imageSide x _mapContentX(0.5) (within 1 dp tolerance)
  - Assert: allahRect.center.dy approx imageSide x _mapContentY(0.735) (within 1 dp tolerance)
  - Assert: allahRect.width / 2 approx imageSide x _mapContentWidth(0.106) (within 1 dp tolerance)
  - Run test on UNFIXED code - the actual centre will be imageSide x 0.5 / imageSide x 0.735 and radius imageSide x 0.106, which differ from the mapped values
  - EXPECTED OUTCOME: Test FAILS (this is correct - it proves the bug exists)
  - Document counterexamples found
  - Mark task complete when test is written, run, and failure is documented
  - Requirements: 1.1, 1.2, 1.3

- [x] 2. Write preservation property tests (BEFORE implementing fix)
  - Property 2: Preservation - Save and Replay Button Positions Unchanged Across Screen Sizes
  - IMPORTANT: Follow observation-first methodology
  - Observe: on unfixed code at imageSide = 400, record save_tap_area centre and radius
  - Observe: on unfixed code at imageSide = 400, record replay_tap_area centre and radius
  - Write a parameterised widget test that pumps CounterScreen at multiple screen sizes and asserts that save_tap_area and replay_tap_area geometry matches the formula imageSide x rawConstant exactly
  - For each size: assert saveRect.center.dx approx imageSide x 0.313, saveRect.center.dy approx imageSide x 0.496, saveRect.width / 2 approx imageSide x 0.066
  - For each size: assert replayRect.center.dx approx imageSide x 0.684, replayRect.center.dy approx imageSide x 0.496, replayRect.width / 2 approx imageSide x 0.066
  - Property-based approach: iterate over the list [360, 430, 540, 600, 768, 800] as representative imageSide proxies
  - Run tests on UNFIXED code
  - EXPECTED OUTCOME: Tests PASS (this confirms baseline Save/Replay positions to preserve)
  - Mark task complete when tests are written, run, and passing on unfixed code
  - Requirements: 3.1, 3.2, 3.3

- [x] 3. Fix allah_tap_area coordinate mapping in counter_screen.dart

  - [x] 3.1 Implement the fix - update allah_tap_area call site
    - In lib/screens/counter_screen.dart, inside build -> LayoutBuilder -> Stack children, locate the _buildCenteredCircleTapZone call for _allahTapKey
    - Change centerX: _allahCenterX to centerX: _mapContentX(_allahCenterX)
    - Change centerY: _allahCenterY to centerY: _mapContentY(_allahCenterY)
    - Change radius: imageSide * _allahRadiusFactor to radius: imageSide * _mapContentWidth(_allahRadiusFactor)
    - Also update the debug circle for allah_tap_area inside if (_showDebugZones): change its centerX, centerY, and radius arguments to use the same mapped values
    - Do NOT change save_tap_area, replay_tap_area, their debug circles, the LCD overlay, or any other code
    - Requirements: 2.1, 2.2, 2.3, 3.1, 3.2, 3.6

  - [x] 3.2 Verify bug condition exploration test now passes
    - Property 1: Expected Behavior - Allah Tap Area Centred on Golden Circle
    - IMPORTANT: Re-run the SAME test from task 1 - do NOT write a new test
    - Run the exploration test on the FIXED code
    - EXPECTED OUTCOME: Test PASSES (confirms the coordinate-space mismatch is resolved)
    - Requirements: 2.1, 2.2, 2.3

  - [x] 3.3 Verify preservation tests still pass
    - Property 2: Preservation - Save and Replay Button Positions Unchanged
    - IMPORTANT: Re-run the SAME tests from task 2 - do NOT write new tests
    - Run the preservation property tests from step 2 on the FIXED code
    - EXPECTED OUTCOME: Tests PASS (confirms no regressions to Save/Replay positions)
    - Confirm all preservation assertions still hold after the fix

- [x] 4. Checkpoint - Ensure all tests pass
  - Run the full test suite: flutter test
  - Confirm the bug condition exploration test (Property 1) passes
  - Confirm the preservation property tests (Property 2) pass
  - Confirm all pre-existing widget tests in test/widget_test.dart still pass
  - Ensure all tests pass; ask the user if questions arise
