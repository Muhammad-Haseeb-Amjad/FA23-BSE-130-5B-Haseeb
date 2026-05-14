# Requirements Document

## Introduction

Convert the five hero floating cards on the CUICHAT landing page into premium hover-expand icon badges. Each badge renders as a compact circular glassmorphism icon in its default state and smoothly expands into a labeled pill on hover, keyboard focus, or mobile tap. The change is purely presentational — only the hero floating card HTML and the associated CSS/JS inside `chatter_backend/resources/views/landing.blade.php` are modified.

## Glossary

- **Badge**: A `.hfb-badge` element — the root interactive container for each floating icon badge.
- **Icon_Circle**: A `.hfb-icon` element — the always-visible 30×40px circular icon container inside a badge.
- **Label**: A `.hfb-label` element — the text span that slides in when a badge is expanded.
- **Expanded_State**: The visual state of a badge when it shows both the icon and the label (triggered by hover, focus-visible, or `.hfb-expanded` class).
- **Collapsed_State**: The default visual state of a badge showing only the icon circle (40×40px).
- **HFB_System**: The complete hero floating badges feature — all five badges, their CSS rules, and the mobile JS toggle.
- **Landing_Page**: `chatter_backend/resources/views/landing.blade.php`.
- **Float_Animation**: The continuous vertical floating keyframe animation applied via `ph-float`, `ph-float-2`, `ph-float-3`, `ph-float-4` CSS classes.

---

## Requirements

### Requirement 1: Default Collapsed State

**User Story:** As a visitor to the landing page, I want the hero badges to appear as clean icon-only circles by default, so that the hero section looks uncluttered and premium without overwhelming the main content.

#### Acceptance Criteria

1. THE HFB_System SHALL render each Badge as a circular element with `width: 40px` and `height: 40px` on page load.
2. THE HFB_System SHALL apply a glassmorphism background (`rgba(255,255,255,0.08)`) with `backdrop-filter: blur(24px)` to each Badge in Collapsed_State.
3. THE HFB_System SHALL hide each Label visually in Collapsed_State via `opacity: 0` and `transform: translateX(-8px)`.
4. THE HFB_System SHALL clip Label overflow using `overflow: hidden` on the Badge in Collapsed_State so no label text is visible.
5. THE HFB_System SHALL keep the Icon_Circle always visible at `width: 30px; height: 30px` in both Collapsed_State and Expanded_State.

---

### Requirement 2: Hover Expand Interaction

**User Story:** As a desktop visitor, I want badges to expand and reveal their label when I hover over them, so that I can read the context of each badge without the labels cluttering the default view.

#### Acceptance Criteria

1. WHEN a pointer device enters a Badge, THE HFB_System SHALL transition the Badge to Expanded_State within 0.35 seconds.
2. WHEN a Badge enters Expanded_State, THE HFB_System SHALL expand the Badge width to fit the label text up to a maximum of 220px.
3. WHEN a Badge enters Expanded_State, THE HFB_System SHALL transition the Label to `opacity: 1` and `transform: translateX(0)` with a 0.05s delay for a staggered slide-in effect.
4. WHEN a Badge enters Expanded_State, THE HFB_System SHALL apply `transform: translateY(-3px)` to lift the Badge 3px upward.
5. WHEN a Badge enters Expanded_State, THE HFB_System SHALL intensify the box-shadow to `0 12px 40px rgba(0,0,0,0.35), 0 0 20px rgba(131,51,198,0.25)`.
6. WHEN a pointer device leaves a Badge, THE HFB_System SHALL transition the Badge back to Collapsed_State within 0.35 seconds.
7. THE HFB_System SHALL use CSS `transition` properties exclusively for expand/collapse animation — no JavaScript animation loops.

---

### Requirement 3: Keyboard Focus Interaction

**User Story:** As a keyboard user, I want to navigate to each badge using the Tab key and see it expand on focus, so that I can access the same information as mouse users without needing a pointer device.

#### Acceptance Criteria

1. THE HFB_System SHALL assign `tabindex="0"` to each Badge so it is reachable via keyboard Tab navigation.
2. WHEN a Badge receives `:focus-visible`, THE HFB_System SHALL apply the same Expanded_State visual treatment as hover.
3. WHEN a Badge loses focus (blur), THE HFB_System SHALL return the Badge to Collapsed_State.
4. THE HFB_System SHALL use the `:focus-visible` CSS pseudo-class (not `:focus`) so that focus rings and expansion do not trigger on mouse click.
5. THE HFB_System SHALL suppress the default browser outline on focused Badges via `outline: none` on the `:focus-visible` rule, relying on the expanded visual state as the focus indicator.

---

### Requirement 4: Mobile Tap Toggle

**User Story:** As a mobile visitor, I want to tap a badge to expand it and see its label, so that I can interact with the badges on a touch device where hover events do not fire.

#### Acceptance Criteria

1. WHEN a touch device user taps a Badge, THE HFB_System SHALL add the `.hfb-expanded` class to that Badge to trigger Expanded_State.
2. WHEN a Badge with `.hfb-expanded` is tapped again, THE HFB_System SHALL remove `.hfb-expanded` to return it to Collapsed_State.
3. WHEN a Badge is tapped and another Badge already has `.hfb-expanded`, THE HFB_System SHALL remove `.hfb-expanded` from the previously expanded Badge before adding it to the tapped Badge.
4. WHEN a touch event occurs outside any Badge, THE HFB_System SHALL remove `.hfb-expanded` from all Badges.
5. THE HFB_System SHALL register `touchstart` event listeners with `{ passive: true }` to avoid blocking scroll performance.

---

### Requirement 5: Label Text Integrity

**User Story:** As a visitor, I want badge labels to always display on a single line without wrapping, so that the expand animation looks clean and the pill shape is preserved.

#### Acceptance Criteria

1. THE HFB_System SHALL apply `white-space: nowrap` to each Label so it never wraps to a second line at any viewport width.
2. THE HFB_System SHALL apply `flex-shrink: 0` to each Label so it is not compressed by the flex container.
3. THE HFB_System SHALL set `pointer-events: none` on each Label in Collapsed_State to prevent accidental hover capture by the label element.
4. WHEN a Badge is in Expanded_State, THE HFB_System SHALL set `pointer-events: auto` on the Label.

---

### Requirement 6: Five Badge Definitions

**User Story:** As a visitor, I want to see five specific informational badges in the hero section, so that I get a quick visual impression of the platform's features and community.

#### Acceptance Criteria

1. THE HFB_System SHALL render a "Verified Student" Badge using the `verified` Material Symbol icon (FILL 1) with accent color `#00fbfb`, positioned at `top: 12%; left: -18%`.
2. THE HFB_System SHALL render a "12 new messages" Badge using the `mark_chat_unread` Material Symbol icon with accent color `#dfb7ff`, positioned at `top: 28%; right: -20%`.
3. THE HFB_System SHALL render a "3 Notifications" Badge using the `notifications_active` Material Symbol icon (FILL 1) with accent color `#ff6b6b`, positioned at `bottom: 32%; left: -22%`.
4. THE HFB_System SHALL render a "CS Study Room" Badge using the `menu_book` Material Symbol icon with accent color `#00fbfb`, positioned at `bottom: 14%; right: -18%`.
5. THE HFB_System SHALL render an "Islamabad Campus" Badge using the `location_on` Material Symbol icon (FILL 1) with accent color `#b3c5ff`, positioned at `top: 58%; left: -20%`.
6. THE HFB_System SHALL apply per-badge accent colors to the Icon_Circle background and border using semi-transparent variants of the accent color.

---

### Requirement 7: Floating Animation Preservation

**User Story:** As a visitor, I want the badges to continue their floating animation while idle, so that the hero section retains its lively, premium feel.

#### Acceptance Criteria

1. THE HFB_System SHALL apply the existing `ph-float`, `ph-float-2`, `ph-float-3`, `ph-float-4` Float_Animation classes to the appropriate Badges.
2. THE HFB_System SHALL assign staggered `animation-delay` values to each Badge so the five badges float out of phase with each other.
3. WHEN a Badge is in Expanded_State, THE HFB_System SHALL allow the hover `transform: translateY(-3px)` to take visual precedence over the Float_Animation transform, which is an acceptable and intentional behavior.

---

### Requirement 8: Accessibility Labels

**User Story:** As a screen reader user, I want each badge to have a descriptive accessible label, so that I understand what each badge represents without relying on the visual icon.

#### Acceptance Criteria

1. THE HFB_System SHALL set `role="img"` on each Badge element.
2. THE HFB_System SHALL set an `aria-label` attribute on each Badge containing the full human-readable label text (e.g., `aria-label="Verified Student"`).
3. THE HFB_System SHALL set a `title` attribute on each Badge containing the same full human-readable label text as the `aria-label`.
4. THE HFB_System SHALL ensure every Badge has a non-empty `aria-label` that matches its visible Label text.

---

### Requirement 9: Mobile Visibility

**User Story:** As a mobile visitor, I want the hero section to remain clean and uncluttered on small screens, so that the badges do not overflow or obscure the main hero content on narrow viewports.

#### Acceptance Criteria

1. WHEN the viewport width is 768px or less, THE HFB_System SHALL hide all Badges via `display: none`.
2. THE HFB_System SHALL apply the mobile hide rule to the `.hfb-badge` class so it replaces the previous `.hero-glass-card` rule at the same breakpoint.
3. WHEN the viewport width is greater than 768px, THE HFB_System SHALL display all Badges in their Collapsed_State.

---

### Requirement 10: Reduced Motion Support

**User Story:** As a visitor with vestibular or motion sensitivity, I want badge animations to be disabled when I have enabled reduced motion in my OS settings, so that the page does not cause discomfort.

#### Acceptance Criteria

1. WHEN the `prefers-reduced-motion: reduce` media query is active, THE HFB_System SHALL set `transition: none` on all Badge elements.
2. WHEN the `prefers-reduced-motion: reduce` media query is active, THE HFB_System SHALL set `transition: none` on all Label elements.
3. WHEN the `prefers-reduced-motion: reduce` media query is active, THE HFB_System SHALL disable the Float_Animation on all Badges (consistent with the existing reduced-motion rule for `ph-float*` classes).

---

### Requirement 11: Scope Constraint — No Side Effects

**User Story:** As a developer, I want the hero floating badges change to be fully self-contained, so that no other part of the application is inadvertently affected.

#### Acceptance Criteria

1. THE HFB_System SHALL modify only the hero floating card HTML markup and the associated CSS/JS within `landing.blade.php`.
2. THE HFB_System SHALL NOT modify any routes, controllers, database models, admin panel views, Flutter code, or other Blade templates.
3. THE HFB_System SHALL NOT introduce any new external dependencies — all icons, fonts, and utilities are already loaded on the Landing_Page.
4. THE HFB_System SHALL NOT alter the hero section's heading text, subheading text, CTA buttons, or mockup image.
5. THE HFB_System SHALL NOT alter the header, footer, or any section outside the hero floating card group.
