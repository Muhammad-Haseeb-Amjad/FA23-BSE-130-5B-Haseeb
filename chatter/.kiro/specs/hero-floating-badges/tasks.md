# Implementation Plan: Hero Floating Badges

## Overview

Convert the five hero floating cards in `chatter_backend/resources/views/landing.blade.php` into premium hover-expand icon badges. The change is purely presentational — CSS rules are added inside the existing `<style>` block, the five `.hero-glass-card` divs are replaced with `.hfb-badge` divs, and a small inline JS block is added for mobile tap toggle.

## Tasks

- [x] 1. Add `.hfb-badge` CSS rules to the existing style block
  - Add the `.hfb-badge`, `.hfb-badge:hover/:focus-visible/.hfb-expanded`, `.hfb-icon`, `.hfb-label`, and expanded-label rules inside the existing `<style>` block, after the `.hero-glass-card` rule
  - Add `.hfb-badge{display:none;}` to the existing `@media(max-width:768px)` rule alongside `.hero-glass-card{display:none;}`
  - Add `.hfb-badge{transition:none;}` and `.hfb-label{transition:none;}` to the existing `@media(prefers-reduced-motion:reduce)` block
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 3.2, 3.4, 3.5, 5.1, 5.2, 5.3, 5.4, 9.1, 9.2, 10.1, 10.2_

- [x] 2. Replace the five `.hero-glass-card` divs with `.hfb-badge` HTML
  - Remove all five existing `.hero-glass-card` divs from the mockup wrapper
  - Insert the five new `.hfb-badge` divs with correct icons, accent colors, positions, float classes, `role="img"`, `aria-label`, `title`, and `tabindex="0"`
  - _Requirements: 1.5, 3.1, 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 7.1, 7.2, 8.1, 8.2, 8.3, 8.4_

- [x] 3. Add mobile tap-toggle JavaScript
  - Add the HFB mobile tap toggle IIFE before the closing `</body>` tag (near existing inline scripts)
  - The script must handle: single tap to expand, second tap to collapse, tap outside to collapse all, `stopPropagation` on badge tap, `{passive:true}` listeners
  - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5_

- [x] 4. Final checkpoint — verify all changes are consistent
  - Ensure all tests pass, ask the user if questions arise.
